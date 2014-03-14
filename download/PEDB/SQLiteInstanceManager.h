//
//  SQLiteInstanceManager.h
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------
#if (TARGET_OS_MAC && ! (TARGET_OS_EMBEDDED || TARGET_OS_ASPEN || TARGET_OS_IPHONE))	
#import <Foundation/Foundation.h>
#else
#import <UIKit/UIKit.h>
#endif
//#import "/usr/include/sqlite3.h"
#import <sqlite3.h>

#if (! TARGET_OS_IPHONE)
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

typedef enum SQLITE3AutoVacuum
{
	kSQLITE3AutoVacuumNoAutoVacuum = 0,
	kSQLITE3AutoVacuumFullVacuum,
	kSQLITE3AutoVacuumIncrementalVacuum,
		
} SQLITE3AutoVacuum;
typedef enum SQLITE3LockingMode
{
	kSQLITE3LockingModeNormal = 0,
	kSQLITE3LockingModeExclusive,
} SQLITE3LockingMode;


@interface SQLiteInstanceManager : NSObject {

	@private
	NSString *databaseFilepath;
	sqlite3 *database;
}

@property (readwrite,retain) NSString *databaseFilepath;

+ (id)sharedManager;
- (sqlite3 *)database;
- (BOOL)tableExists:(NSString *)tableName;
- (void)setAutoVacuum:(SQLITE3AutoVacuum)mode;
- (void)setCacheSize:(NSUInteger)pages;
- (void)setLockingMode:(SQLITE3LockingMode)mode;
- (void)deleteDatabase;
- (void)vacuum;
- (void)executeUpdateSQL:(NSString *) updateSQL;
- (NSString *)getDatabaseFilepath;
@end
