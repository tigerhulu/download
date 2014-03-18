//
//  Util_View.m
//  UtilView
//
//  Created by hj on 13-8-1.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import "Util_View.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

#define kScaleMin                           0.007f
#define kScaleDefault                       1.0f
#define kScaleDelta                         0.05f


#define kFirstAnimateTime                   0.3f
#define kSecondAnimateTime                  0.2f

#define kMaskViewFinalAlpha                 0.2f    //背景的透明度

@interface ViewInfo : NSObject{
    AnimateType     aType;              //动画类型
    UIView          *displayView;       //显示页面
    CGRect          displayRect;        //显示的位置
    UIControl       *maskView;          //遮挡页面
    void            (^showBlock)(BOOL finished);
    void            (^hideBlock)(BOOL finished);
}

@property (retain, nonatomic)   UIView          *displayView;
@property (assign, nonatomic)   AnimateType     aType;
@property (assign, nonatomic)   CGRect          displayRect;
@property (retain, nonatomic)   UIControl       *maskView;
@property (copy, nonatomic)     void            (^showBlock)(BOOL finished);
@property (copy, nonatomic)     void            (^hideBlock)(BOOL finished);
@end

@implementation ViewInfo

@synthesize displayView,aType,maskView,displayRect,showBlock,hideBlock;
- (void)dealloc{
    Block_release(hideBlock);
    Block_release(showBlock);
    [maskView release];
    [displayView release];
    [super dealloc];
}

@end

@implementation UIView (Util_View)

-(void)setRadiusCorner{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

-(void)setRadiusCorner:(int)radius{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

-(void)clearAllSubView{
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
}

-(void)resignResponder{
    for (id txf in [self subviews]) {
        if ([txf isKindOfClass:[UITextField class]]) {
            [(UITextField *)txf resignFirstResponder];
        }
        if ([txf isKindOfClass:[UITextView class]]) {
            [(UITextView *)txf resignFirstResponder];
        }
    }
}

-(void)setBackGradient:(NSArray *)colorArr From:(CGPoint)stratPot End:(CGPoint)endPot{
    CAGradientLayer * _gradient = [CAGradientLayer layer];
    [_gradient setFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    [_gradient setStartPoint:stratPot];
    [_gradient setEndPoint:endPot];
    [self.layer insertSublayer:_gradient atIndex:0];
    [self setBackgroundColor:[UIColor clearColor]];
    [_gradient setColors:colorArr];
}

- (UIImage*)image{
    CGSize imageSize = [self bounds].size;// [[UIScreen mainScreen] bounds].size;
    
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width *[[window layer] anchorPoint].x,
                                  -[window bounds].size.height *[[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 
static NSMutableArray   *displayViewAry;//已显示的页面数组

+ (UIView *)getTopView{
    return nil;
}

+ (void)setTopMaskViewCanTouch:(BOOL)_canTouch{
    ViewInfo *info = [displayViewAry lastObject];
    if (_canTouch)
        [info.maskView addTarget:self action:@selector(maskViewTouch) forControlEvents:UIControlEventTouchUpInside];
    else
        [info.maskView removeTarget:self action:@selector(maskViewTouch) forControlEvents:UIControlEventTouchUpInside];
}

+ (void)showView:(UIView*)_view animateType:(AnimateType)_aType finalRect:(CGRect)_fRect completion:(void(^)(BOOL finished))completion{
    //初始化页面数组
    if (displayViewAry == nil)
        displayViewAry = [[NSMutableArray alloc]init];
    
    UIView * topView = [UIView getTopView];
    
    //存储页面信息
    ViewInfo *info = [[ViewInfo alloc]init];
    info.displayView = _view;
    info.aType = _aType;
    info.displayRect = _fRect;
    
    //初始化遮罩页面
    UIControl *maskView = [[UIControl alloc] init];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0;
    maskView.frame = topView.bounds;
    [maskView addTarget:self action:@selector(maskViewTouch) forControlEvents:UIControlEventTouchUpInside];
    //添加页面
    [topView addSubview:maskView];
    [topView bringSubviewToFront:maskView];
    
    info.maskView = maskView;
    [maskView release];
    
    if (completion)
        info.showBlock = completion;
    
    [displayViewAry addObject:info];
    [info release];
    
    
    //根据不同的动画类型显示
    switch (_aType) {
        case AnimateTypeOfTV:
            [UIView showTV];
            break;
        case AnimateTypeOfPopping:
            [UIView showPopping];
        default:
            break;
    }
}

+ (void)showView:(UIView*)_view{
//    CGRect rect = [VCManage shared].view.frame;
//    rect.origin.y = 0;
//    [self showView:_view animateType:AnimateTypeOfPopping finalRect:rect completion:nil];
}

+ (void)showView:(UIView*)_view animateType:(AnimateType)_aType finalRect:(CGRect)_fRect{
    [self showView:_view animateType:_aType finalRect:_fRect completion:nil];
}

+ (void)hideViewByCompletion:(void(^)(BOOL finished))completion{
    if ([displayViewAry count] > 0){
        ViewInfo *info = [displayViewAry lastObject];
        if (completion)
            info.hideBlock = completion;
    }
    [UIView maskViewTouch];
}

+ (void)hideViewByType:(AnimateType)_aType completion:(void(^)(BOOL finished))completion{
    if ([displayViewAry count] > 0){
        ViewInfo *info = [displayViewAry lastObject];
        info.aType = _aType;
        if (completion)
            info.hideBlock = completion;
    }
    [UIView maskViewTouch];
}

+ (void)hideView{
    [UIView hideViewByCompletion:nil];
}

+ (void)hideViewByType:(AnimateType)_aType{
    [UIView hideViewByType:_aType completion:nil];
}

+ (void)maskViewTouch{
    if ([displayViewAry count] > 0){
        ViewInfo *info = [displayViewAry lastObject];
        
        //根据不同类型隐藏
        switch (info.aType) {
            case AnimateTypeOfTV:
                [UIView hideTV];
                break;
            case AnimateTypeOfPopping:
                [UIView hidePopping];
                break;
            default:
                break;
        }
    }
}

+ (void)removeMaskViewAndDisplay:(ViewInfo*)info{
    if (info.aType == AnimateTypeOfTV || info.aType == AnimateTypeOfPopping)  //TV,Popping 类型需要还原
        info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleDefault);
    
    [info.displayView removeFromSuperview];
    [info.maskView removeFromSuperview];
    [displayViewAry removeObject:info];
}

+ (void)showTV{
    ViewInfo *info = [displayViewAry lastObject];
    UIView *topView = [UIView getTopView];
    info.displayView.frame = info.displayRect;
    [topView addSubview:info.displayView];
    [topView bringSubviewToFront:info.displayView];
    
    info.displayView.transform = CGAffineTransformMakeScale(kScaleMin, kScaleMin);
    
    //开始动画
    [UIView animateWithDuration:kSecondAnimateTime animations:^{
        info.maskView.alpha = 0.1f;
        info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleMin);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:kFirstAnimateTime animations:^{
            info.maskView.alpha = kMaskViewFinalAlpha;
            info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleDefault);
        }completion:^(BOOL finish){
            //调用完成动画块
            if (info.showBlock)
                info.showBlock(finish);
        }];
    }];
}

+ (void)hideTV{
    
    ViewInfo *info = [displayViewAry lastObject];
    
    [UIView animateWithDuration:kSecondAnimateTime animations:^{
        info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleMin);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:kFirstAnimateTime animations:^{
            info.displayView.transform = CGAffineTransformMakeScale(kScaleMin, kScaleMin);
            info.maskView.alpha = 0;
        }completion:^(BOOL finish){
            //调用完成动画块
            if (info.hideBlock)
                info.hideBlock(finish);
            [UIView removeMaskViewAndDisplay:info];
        }];
    }];
}

+ (void)showPopping{
    ViewInfo *info = [displayViewAry lastObject];
    UIView *topView = [UIView getTopView];
    info.displayView.frame = info.displayRect;
    [topView addSubview:info.displayView];
    [topView bringSubviewToFront:info.displayView];
    
    info.displayView.transform = CGAffineTransformMakeScale(kScaleMin, kScaleMin);
    
    //开始动画
    [UIView animateWithDuration:kFirstAnimateTime animations:^{
        info.maskView.alpha = kMaskViewFinalAlpha;
        info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault+kScaleDelta, kScaleDefault+kScaleDelta);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:kSecondAnimateTime animations:^{
            info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault-kScaleDelta, kScaleDefault-kScaleDelta);
        }completion:^(BOOL finish){
            [UIView animateWithDuration:kSecondAnimateTime animations:^{
                info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleDefault);
            }completion:^(BOOL finish){
                //调用完成动画块
                if (info.showBlock)
                    info.showBlock(finish);
            }];
        }];
    }];
}

+ (void)hidePopping{
    ViewInfo *info = [displayViewAry lastObject];
    
    [UIView animateWithDuration:kFirstAnimateTime animations:^{
        info.maskView.alpha = 0;
        info.displayView.transform = CGAffineTransformMakeScale(kScaleMin, kScaleMin);
    }completion:^(BOOL finish){
        //调用完成动画块
        if (info.hideBlock)
            info.hideBlock(finish);
        [UIView removeMaskViewAndDisplay:info];
    }];
}

@end


