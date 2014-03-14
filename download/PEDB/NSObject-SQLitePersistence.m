//
//  NSObject-SQLitePersistence.m
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------

#import "NSObject-SQLitePersistence.h"
#import "NSObject-ClassName.h"


@implementation NSObject(SQLitePersistence)

+ (BOOL)canBeStoredInSQLite;
{
	return [self conformsToProtocol:@protocol(NSCoding)];
}
+ (NSString *)columnTypeForObjectStorage 
{
	return kSQLiteColumnTypeBlob;
}
- (NSData *)sqlBlobRepresentationOfSelf
{
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:self forKey:[self className]];
	[archiver finishEncoding];
	[archiver release];
	return [data autorelease];
}
+ (BOOL)shouldBeStoredInBlob
{
	return YES;
}
+ (id)objectWithSQLBlobRepresentation:(NSData *)data;
{
	if (data == nil || [data length] == 0)
		return nil;
	
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	id ret = [unarchiver decodeObjectForKey:[self className]];
	[unarchiver finishDecoding];
	[unarchiver release];
	
	return ret;
}
@end
