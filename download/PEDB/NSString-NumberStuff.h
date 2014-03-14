//
//  NSString-NumberStuff.h
//  CashFlow
//
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(NumberStuff)
- (BOOL)holdsFloatingPointValue;
- (BOOL)holdsFloatingPointValueForLocale:(NSLocale *)locale;
- (BOOL)holdsIntegerValue;
+ (id)formattedCurrencyStringWithValue:(float)inValue;
@end
