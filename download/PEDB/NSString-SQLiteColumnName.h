//
//  NSString-SQLiteColumnName.h
// ----------------------------------------------------------------------
//  Created by yexuan on 12-5-23.
//  Copyright 2012年 ADP. All rights reserved.
//
// ----------------------------------------------------------------------

#import <Foundation/Foundation.h>


@interface NSString(SQLiteColumnName)
- (NSString *)stringAsSQLColumnName;
- (NSString *)stringAsPropertyString;
@end
