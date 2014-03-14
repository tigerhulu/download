//
//  NSString-SQLitePersistence.h
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "NSObject-SQLitePersistence.h"

@interface NSString(SQLitePersistence) <SQLitePersistence>
/*!
 This method initializes an NSString from TEXT colum data pulled from the database.
 */
+ (id)objectWithSqlColumnRepresentation:(NSString *)columnData;

/*!
 This method returns self.
 */
- (NSString *)sqlColumnRepresentationOfSelf;

/*!
 Returns YES to indicate it can be stored in a column of a database
 */
+ (BOOL)canBeStoredInSQLite;

/*!
 Returns TEXT to inidicate this object can be stored in a TEXT column
 */
+ (NSString *)columnTypeForObjectStorage;

+ (BOOL)shouldBeStoredInBlob;
@end
