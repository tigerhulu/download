//
//  Util_Math.m
//  JGMobile
//
//  Created by hj on 13-8-6.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import "Util_Math.h"

@implementation Util_Math

+(float)getDistanceFrom:(CGPoint)ptStart To:(CGPoint)ptEnd{
    return sqrtf(powf((ptEnd.x-ptStart.x), 2)+powf((ptEnd.y-ptStart.y), 2));
}

+(float)getAngleFrom:(CGPoint)ptStart Center:(CGPoint)ptCenter;{
    float x=ptStart.x-ptCenter.x;
    float y=ptCenter.y-ptStart.y;
    if (y==0) {
        if (x==0) {
            return 0;
        }
        else if(x<0){
            return 270;
        }
        else{
            return 90;
        }
    }
    
    if (x==0) {
        if(y<0){
            return 180;
        }
        else{
            return 0;
        }
        
    }
    
    float angel=atanf(x/y)/M_PI*180;
    while (angel<0) {
        angel+=180;
    }
    if (x<0) {
        angel+=180;
    }
    return angel;
    
}

+(float)getRadianFromDegree:(float)degree{
    return degree*M_PI/180;
}

+(float)getDegreeFromRadian:(float)radian{
    return radian*180/M_PI;
}

//获取点相对于中心点，角度 半径的点，上方向为0度
+(CGPoint)getPointWithCenter:(CGPoint)ptCenter Angle:(float)angel Radiu:(float)radius{
    
    float xoff=sinf(angel/180*M_PI)*radius;
    float yoff=-1*cosf(angel/180*M_PI)*radius;
    NSLog(@"%f,  %f",xoff,yoff);
    return CGPointMake(ptCenter.x+xoff, ptCenter.y+yoff);
}

//求符号，正为1，负为－1，相等为0
+(int)getSign:(float)num{
    if (num<0) {
        return -1;
    }
    else if(num>0){
        return 1;
    }
    else{
        return 0;
    }
}

@end
