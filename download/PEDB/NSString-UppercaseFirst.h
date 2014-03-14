//
//  NSString-UppercaseFirst.h
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------
#if (TARGET_OS_MAC && ! (TARGET_OS_EMBEDDED || TARGET_OS_ASPEN || TARGET_OS_IPHONE))	
#import <Foundation/Foundation.h>
#else
#import <UIKit/UIKit.h>
#endif


@interface NSString(UppercaseFirst)
- (NSString *) stringByUppercasingFirstLetter;
- (NSString *) stringByLowercasingFirstLetter;
@end
