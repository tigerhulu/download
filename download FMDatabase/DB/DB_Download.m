//
//  DB_Download.m
//  download
//
//  Created by Haijiao on 14-3-17.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "DB_Download.h"

#define Table_Download  @"Download"

@implementation DB_Download

+(void)createTableDownload
{
    NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (Url TEXT PRIMARY KEY NOT NULL, FilePath TEXT, CurSize INTEGER, TotalSize INTEGER, DownloadType INTEGER)",Table_Download];
    if ([[DB_Base shared] executeUpdate:sql]) {
        NSLog(@"create table success");
    }
}

+(void)addDownload:(BE_Download *)download
{
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO %@ (Url, FilePath, CurSize, TotalSize, DownloadType) VALUES ('%@', '%@', %lld, %lld, %d)",Table_Download,download.Url,download.FilePath,download.CurSize,download.TotalSize,download.DownloadType];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DB_Base shared] executeUpdate:sql];
    });
}

+(void)deleteDownloadWithUrl:(NSString *)url
{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@",Table_Download];
    if (url.length>0) {
        sql = [sql stringByAppendingFormat:@" WHERE Url = '%@'",url];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DB_Base shared] executeUpdate:sql];
    });
}

+(void)updateDownload:(BE_Download *)download
{
    if (download.Url.length<1) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:@"UPDATE %@ SET",Table_Download];
    if (download.FilePath) {
        sql = [sql stringByAppendingFormat:@" FilePath = '%@'",download.FilePath];
    }
    sql = [sql stringByAppendingFormat:@" ,CurSize = %lld",download.CurSize];
    sql = [sql stringByAppendingFormat:@" ,TotalSize = %lld",download.TotalSize];
    sql = [sql stringByAppendingFormat:@" ,DownloadType = %d",download.DownloadType];
    sql = [sql stringByAppendingFormat:@" WHERE Url = '%@'",download.Url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DB_Base shared] executeUpdate:sql];
    });
}

+(NSArray *)queryDownloadWithUrl:(NSString *)url
{
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@",Table_Download];
    if (url.length>0) {
        sql = [sql stringByAppendingFormat:@" WHERE Url = '%@'",url];
    }
    FMResultSet * rs = [[DB_Base shared] executeQuery:sql];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]) {
        BE_Download * download = [[BE_Download alloc] init];
        download.Url = [rs stringForColumn:@"Url"];
        download.FilePath = [rs stringForColumn:@"FilePath"];
        download.CurSize = [rs longLongIntForColumn:@"CurSize"];
        download.TotalSize = [rs longLongIntForColumn:@"TotalSize"];
        download.DownloadType = [rs intForColumn:@"DownloadType"];
        [array addObject:download];
        [download release];
	}
	[rs close];
    [[DB_Base shared].DBQueue close];
    return array;
}

@end
