//
//  Util_Button.m
//  FpiFramework
//
//  Created by hj on 13-8-12.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import "Util_Button.h"

@implementation UIButton (Util_Button)

-(void)setNormalBackgroundImage:(UIImage *)image{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

@end
