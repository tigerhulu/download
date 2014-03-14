// ----------------------------------------------------------------------
// Part of the SQLite Persistent Objects for Cocoa and Cocoa Touch
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------

#if (TARGET_OS_IPHONE)
#import <Foundation/Foundation.h>

/*!
 On the iPhone NSObject does not provide the className method.
 */
@interface NSObject(ClassName)
- (NSString *)className;
+ (NSString *)className;
@end
#endif
