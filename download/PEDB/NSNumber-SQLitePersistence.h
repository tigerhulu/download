//
//  NSNumber-SQLitePersistence.h
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "NSObject-SQLitePersistence.h"

@interface NSNumber(SQLitePersistence)  <SQLitePersistence>

/*!
 This method initializes an NSNumber from REAL colum data pulled from the database.
 */
+ (id)objectWithSqlColumnRepresentation:(NSString *)columnData;

/*!
 This method returns self as a number.
 */
- (NSString *)sqlColumnRepresentationOfSelf;

/*!
 Returns YES to indicate it can be stored in a column of a database
 */
+ (BOOL)canBeStoredInSQLite;

/*!
 Returns REAL to inidicate this object can be stored in a REAL column
 */
+ (NSString *)columnTypeForObjectStorage;

+ (BOOL)shouldBeStoredInBlob;
@end
