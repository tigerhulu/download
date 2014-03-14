//
//  NSDate-SQLitePersistence.h
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "NSObject-SQLitePersistence.h"

@interface NSDate(SQLitePersistence) <SQLitePersistence>
/*!
 This method initializes an NSDate from REAL colum data pulled from the database.
 */
+ (id)objectWithSqlColumnRepresentation:(NSString *)columnData;

/*!
 This method returns self the time interval since 1970 ncoded NSString.
 */
- (NSString *)sqlColumnRepresentationOfSelf;

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
