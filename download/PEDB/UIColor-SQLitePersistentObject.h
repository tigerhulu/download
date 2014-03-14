//
//  UIColor-SQLitePersistentObject.h
//  KnitMinder
//
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
//

#if (TARGET_OS_IPHONE)
#import "NSObject-SQLitePersistence.h"
#import <UIKit/UIKit.h>

@interface UIColor(SQLitePersistence) <SQLitePersistence> 
+ (id)objectWithSQLBlobRepresentation:(NSData *)data;
- (NSData *)sqlBlobRepresentationOfSelf;
+ (BOOL)canBeStoredInSQLite;
+ (NSString *)columnTypeForObjectStorage;
+ (BOOL)shouldBeStoredInBlob;
@end
#endif