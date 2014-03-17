//
//  DB_Base.m
//  download
//
//  Created by Haijiao on 14-3-17.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "DB_Base.h"
#import "DB_Download.h"

static DB_Base * _DB_Base;
@implementation DB_Base

+(DB_Base *)shared
{
    if (!_DB_Base) {
		@synchronized(self) {
			if (!_DB_Base) {
                _DB_Base = [[DB_Base alloc] init];
                [DB_Download createTableDownload];
			}
		}
	}
    return _DB_Base;
}

- (id) init
{
    self = [super init];
    if (self) {
        NSString * dbPath = [[Resource getDocmentsPath] stringByAppendingString:@"download.sqlite"];
        _DBQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
        [_DBQueue close];
    }
    return self;
}

-(BOOL)executeUpdate:(NSString*)sql
{
    __block BOOL result = NO;
    [self.DBQueue inDatabase:^(FMDatabase *db) {
         result = [db executeUpdate:sql];
    }];
    return result;
}

-(FMResultSet *)executeQuery:(NSString*)sql
{
    __block FMResultSet * set = nil;
    [self.DBQueue inDatabase:^(FMDatabase *db) {
        set = [db executeQuery:sql];        
    }];
    return set;
}

-(void)dealloc
{
    [_DBQueue release];
    [super dealloc];
}

@end
