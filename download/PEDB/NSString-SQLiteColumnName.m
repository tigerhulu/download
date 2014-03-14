//
//  NSString-SQLiteColumnName.m
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------

#import "NSString-SQLiteColumnName.h"

@implementation NSString(SQLiteColumnName)
- (NSString *)stringAsSQLColumnName
{
    return  self;
//	NSMutableString *ret = [NSMutableString string];
//	for (int i=0; i < [self length]; i++)
//	{
//		NSRange sRange = NSMakeRange(i,1);
//		NSString *oneChar = [self substringWithRange:sRange];
//		if ([oneChar isEqualToString:[oneChar uppercaseString]] && i > 0)
//			[ret appendFormat:@"_%@", [oneChar lowercaseString]];
//		else
//			[ret appendString:[oneChar lowercaseString]];
//	}
//	return ret;
  
}
- (NSString *)stringAsPropertyString
{
	BOOL lastWasUnderscore = NO;
	NSMutableString *ret = [NSMutableString string];
	for (int i=0; i < [self length]; i++)
	{
		NSRange sRange = NSMakeRange(i,1);
		NSString *oneChar = [self substringWithRange:sRange];
		if ([oneChar isEqualToString:@"_"])
			lastWasUnderscore = YES;
		else
		{
			if (lastWasUnderscore)
				[ret appendString:[oneChar uppercaseString]];
			else
				[ret appendString:oneChar];
			
			lastWasUnderscore = NO;
		}
	}
	return ret;
}
@end
