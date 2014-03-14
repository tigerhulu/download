//
//  Util_Imageview.m
//  FpiFramework
//
//  Created by hj on 13-8-12.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import "Util_Imageview.h"

@implementation UIImageView (Util_ImageView)
@dynamic imgName;

-(void)setImageEx:(UIImage *)image{
    self.image = image;
    self.alpha = 0;
    [UIView animateWithDuration:1.5 animations:^{
        self.alpha = 1;
    }];
}

-(void)setImgName:(NSString *)imgName{
    //    UIImage * img = [Resource getImageWithName:imgName];
    //    if (img) {
    //        self.image = img;
    //    }else {
    //        [[DataCenter sharedDataCenter] requestImage:imgName DefaultImage:nil IsSmallImage:YES Target:self Action:@selector(setImageEx:)];
    //    }
}

@end