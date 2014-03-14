// ----------------------------------------------------------------------
// Part of the SQLite Persistent Objects for Cocoa and Cocoa Touch
//
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------

#if (TARGET_OS_IPHONE)
#import "NSObject-ClassName.h"
#import <objc/runtime.h>

@implementation NSObject(ClassName)
- (NSString *)className
{
	return [NSString stringWithUTF8String:class_getName([self class])];
}
+ (NSString *)className
{
	return [NSString stringWithUTF8String:class_getName(self)];
}

@end
#endif
