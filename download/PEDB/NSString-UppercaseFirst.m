//
//  NSString-UppercaseFirst.m
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------
#import "NSString-UppercaseFirst.h"


@implementation NSString(UppercaseFirst)
- (NSString *) stringByUppercasingFirstLetter
{
	NSRange firstLetterRange = NSMakeRange(0,1);
	NSRange restOfWordRange = NSMakeRange(1,[self length]-1);
	return [NSString stringWithFormat:@"%@%@", [[self substringWithRange:firstLetterRange] uppercaseString], [self substringWithRange:restOfWordRange]];
	
}
- (NSString *) stringByLowercasingFirstLetter
{
	NSRange firstLetterRange = NSMakeRange(0,1);
	NSRange restOfWordRange = NSMakeRange(1,[self length]-1);
	return [NSString stringWithFormat:@"%@%@", [[self substringWithRange:firstLetterRange] lowercaseString], [self substringWithRange:restOfWordRange]];
}
@end
