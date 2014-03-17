//
//  DB_Base.h
//  download
//
//  Created by Haijiao on 14-3-17.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface DB_Base : NSObject

@property (atomic, readonly) FMDatabaseQueue * DBQueue;

+(DB_Base *)shared;

-(BOOL)executeUpdate:(NSString*)sql;

-(FMResultSet *)executeQuery:(NSString*)sql;

@end
