//
//  NSNumber-SQLitePersistence.m
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------
#import "NSNumber-SQLitePersistence.h"


@implementation NSNumber(SQLitePersistence)
+ (id)objectWithSqlColumnRepresentation:(NSString *)columnData
{
	NSNumber *ret = nil;
	double doubleValue = [columnData doubleValue];
	long long longValue = [columnData longLongValue];
	
	if (doubleValue == longValue)
		ret = [[NSNumber alloc] initWithLongLong:longValue];
	else
		ret = [[NSNumber alloc] initWithDouble:doubleValue];
	
	return [ret autorelease];
}
- (NSString *)sqlColumnRepresentationOfSelf
{
	return [self stringValue];
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
