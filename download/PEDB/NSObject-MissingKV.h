//
//  NSObject-MissingKV.h
//  iContractor
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#ifdef TARGET_OS_IPHONE
@interface NSObject(MissingKV) 
- (void)takeValuesFromDictionary:(NSDictionary *)properties;
- (void)takeValue:(id)value forKey:(NSString *)key;
@end
#endif
