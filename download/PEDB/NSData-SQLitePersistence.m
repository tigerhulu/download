//
//  NSData-SQLitePersistence.m
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------

#import "NSData-SQLitePersistence.h"
//#import "NSData-Base64.h"

@implementation NSData(SQLitePersistence)  

- (NSData *)sqlBlobRepresentationOfSelf
{
	return self;
}
+ (BOOL)canBeStoredInSQLite
{
	return YES;
}
+ (NSString *)columnTypeForObjectStorage
{
	return kSQLiteColumnTypeText; // Look at using blob
}
+ (BOOL)shouldBeStoredInBlob
{
	return YES;
}
+ (id)objectWithSQLBlobRepresentation:(NSData *)data;
{
	// Simple pass through
	return data;
}
@end