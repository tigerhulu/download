// UIImage-SQLitePersistence.h
// ----------------------------------------------------------------------
// Part of the SQLite Persistent Objects for Cocoa and Cocoa Touch
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------
#if (TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>

@interface UIImage(SQLitePersistence) <SQLitePersistence>
+ (id)objectWithSQLBlobRepresentation:(NSData *)data;
- (NSData *)sqlBlobRepresentationOfSelf;
+ (BOOL)canBeStoredInSQLite;
+ (NSString *)columnTypeForObjectStorage;
+ (BOOL)shouldBeStoredInBlob;
@end
#endif