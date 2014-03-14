//
//  NSString-SQLitePersistence.m
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------
#import "NSString-SQLitePersistence.h"
 

@implementation NSString(SQLitePersistence)
+ (id)objectWithSqlColumnRepresentation:(NSString *)columnData
{
	return columnData;
}
- (NSString *)sqlColumnRepresentationOfSelf
{
	return self;
}
+ (BOOL)canBeStoredInSQLite;
{
	return YES;
}
+ (NSString *)columnTypeForObjectStorage
{
	return kSQLiteColumnTypeText;
}
+ (BOOL)shouldBeStoredInBlob
{
	return NO;
}
@end
