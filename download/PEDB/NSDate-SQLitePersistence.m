//
//  NSDate-SQLitePersistence.m
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------
#import "NSDate-SQLitePersistence.h"


@implementation NSDate(SQLitePersistence)
+ (id)objectWithSqlColumnRepresentation:(NSString *)columnData;
{
#ifdef TARGET_OS_COCOTRON
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d %H:%M:%S.%F" allowNaturalLanguage:NO] autorelease];
	NSDate *d;
	BOOL cvt = [dateFormatter getObjectValue:&d forString:columnData errorDescription:nil];
	assert(cvt);
	return d;
#else
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSS"];
	return [dateFormatter dateFromString:columnData];
#endif
}
- (NSString *)sqlColumnRepresentationOfSelf
{
#ifdef TARGET_OS_COCOTRON
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d %H:%M:%S.%F" allowNaturalLanguage:NO] autorelease];
	return [dateFormatter stringForObjectValue:self];
#else
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSS"];
	
	NSString *formattedDateString = [dateFormatter stringFromDate:self];
	[dateFormatter release];
	
	return formattedDateString;
#endif
}
+ (BOOL)canBeStoredInSQLite
{
	return YES;
}
+ (NSString *)columnTypeForObjectStorage
{
	return kSQLiteColumnTypeReal;
}
+ (BOOL)shouldBeStoredInBlob
{
	return NO;
}
@end
