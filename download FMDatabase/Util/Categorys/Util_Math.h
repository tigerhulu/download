//
//  Util_Math.h
//  JGMobile
//
//  Created by hj on 13-8-6.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util_Math : NSObject


/**
	获取两点距离
	@param ptStart 起始点
	@param ptEnd 终止点
	@returns 两点之间的距离
 */
+(float)getDistanceFrom:(CGPoint)ptStart To:(CGPoint)ptEnd;
  
/**
	获取点相对于中心的角度，上方向为0度
	@param ptStart 起始点
	@param ptCenter 中心点
	@returns 弧度值
 */
+(float)getAngleFrom:(CGPoint)ptStart Center:(CGPoint)ptCenter;


//角度转化为弧度
+(float)getRadianFromDegree:(float)degree;

//弧度转化为角度
+(float)getDegreeFromRadian:(float)radian;

//获取点相对于中心点，角度 半径的点，上方向为0度
+(CGPoint)getPointWithCenter:(CGPoint)ptCenter Angle:(float)angel Radiu:(float)radius;

//求符号，正为1，负为－1，相等为0
+(int)getSign:(float)num;

@end
