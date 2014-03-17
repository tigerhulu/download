//
//  Util_Object.h
//  JGMobile
//
//  Created by hj on 13-8-1.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EXRelase(__obj)     [__obj release];__obj = nil;

@interface NSObject (Util_Object)

//获取对象所有属性
-(NSArray *)propertyKeys;

//获取对象属性及值
-(NSDictionary *)propertValueAndKey;

@end
