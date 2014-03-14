//
//  NSObject-MissingKV.m
//  iContractor
//  Created by yexuan on 12-2523.
//  Copyright 2012年 ADP. All rights reserved.
//
//

#import "NSObject-MissingKV.h"

#ifdef TARGET_OS_IPHONE
@implementation NSObject(MissingKV)
- (void)takeValuesFromDictionary:(NSDictionary *)properties
{
	for (id oneKey in [properties allKeys])
	{
		id oneObject = [properties objectForKey:oneKey];
		[self setValue:oneObject forKey:oneKey];
	}
}
- (void)takeValue:(id)value forKey:(NSString *)key
{
	[self setValue:value forKey:key];
}
@end
#endif