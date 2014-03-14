//
//  NSMutableData-SQLitePersistence.m
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------

#import "NSMutableData-SQLitePersistence.h"


@implementation NSMutableData(SQLitePersistence)
- (id)initWithSQLBlobRepresentation:(NSData *)data
{
	return [self initWithData:data];
}
@end
