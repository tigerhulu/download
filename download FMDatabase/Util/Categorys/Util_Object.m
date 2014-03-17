//
//  Util_Object.m
//  JGMobile
//
//  Created by hj on 13-8-1.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import "Util_Object.h"
#import <objc/runtime.h>

@implementation NSObject (Util_Object)

-(NSArray*)propertyKeys{
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
        [propertyName release];
    }
    free(properties);
    return [keys autorelease];
    
}

-(NSDictionary *)propertValueAndKey{
    
    NSArray * allKey = [self propertyKeys];
    NSMutableDictionary * newDic = [[NSMutableDictionary alloc] initWithCapacity:[allKey count]];
    for (NSString * key in allKey) {
        [newDic setValue:[self valueForKey:key] forKey:key];
    }
    return [newDic autorelease];
    
}

@end

