//
//  NSMutableData-SQLitePersistence.h
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSObject-SQLitePersistence.h"
#import "NSData-SQLitePersistence.h"

@interface NSMutableData(SQLitePersistence)
/*!
 This method initializes an NSData from blob pulled from the database.
 */
- (id)initWithSQLBlobRepresentation:(NSData *)data;
@end
