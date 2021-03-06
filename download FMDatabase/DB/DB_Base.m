//
//  DB_Base.m
//  download
//
//  Created by Haijiao on 14-3-17.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "DB_Base.h"
#import "DB_Download.h"

@implementation DB_Base

+(DB_Base *)shared
{
    static DB_Base * _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
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
    [self.DBQueue close];
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
