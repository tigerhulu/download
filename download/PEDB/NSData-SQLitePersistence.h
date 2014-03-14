//
//  NSData-SQLitePersistence.h
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import "NSObject-SQLitePersistence.h"

@interface NSData(SQLitePersistence) <SQLitePersistence>
/*!
 This method initializes an NSData from blob pulled from the database.
 */
+ (id)objectWithSQLBlobRepresentation:(NSData *)data;
/*!
 This method returns self as a Base-64 encoded NSString.
 */
- (NSData *)sqlBlobRepresentationOfSelf;

/*!
 Returns YES to indicate it can be stored in a column of a database
 */
+ (BOOL)canBeStoredInSQLite;

/*!
 Returns REAL to inidicate this object can be stored in a TEXT column
 */
+ (NSString *)columnTypeForObjectStorage;
+ (BOOL)shouldBeStoredInBlob;
@end
