//
//  Util_View.h
//  UtilView
//
//  Created by hj on 13-8-1.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDefaultAnimateTime             0.25f

typedef enum AnimateType{       //动画类型
    AnimateTypeOfTV,            //电视
    AnimateTypeOfPopping,       //弹性缩小放大
    AnimateTypeOfLeft,          //左
    AnimateTypeOfRight,         //右
    AnimateTypeOfTop,           //上
    AnimateTypeOfBottom         //下
}AnimateType;

@interface UIView (Util_View)

/*圆角*/
-(void)setRadiusCorner;

-(void)setRadiusCorner:(int)radius;

-(void)clearAllSubView;

-(void)resignResponder;

//设置渐变背景 colorArr : [UIColor redColor].CGColor
-(void)setBackGradient:(NSArray *)colorArr From:(CGPoint)stratPot End:(CGPoint)endPot;

-(UIImage*)image;


#pragma mark -
+ (void)setTopMaskViewCanTouch:(BOOL)_canTouch;

+ (void)showView:(UIView*)_view;

+ (void)showView:(UIView*)_view animateType:(AnimateType)_aType finalRect:(CGRect)_fRect;

+ (void)hideView;

+ (void)hideViewByType:(AnimateType)_aType;

//下面的增加了完成块
+ (void)showView:(UIView*)_view animateType:(AnimateType)_aType finalRect:(CGRect)_fRect completion:(void(^)(BOOL finished))completion;

+ (void)hideViewByCompletion:(void(^)(BOOL finished))completion;

+ (void)hideViewByType:(AnimateType)_aType completion:(void(^)(BOOL finished))completion;

@end
