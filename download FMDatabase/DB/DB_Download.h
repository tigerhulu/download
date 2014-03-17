//
//  DB_Download.h
//  download
//
//  Created by Haijiao on 14-3-17.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "DB_Base.h"
@class BE_Download;

@interface DB_Download : DB_Base

+(void)createTableDownload;

+(NSArray *)queryDownloadWithUrl:(NSString *)url;

+(void)deleteDownloadWithUrl:(NSString *)url;

+(void)addDownload:(BE_Download *)download;

+(void)updateDownload:(BE_Download *)download;

@end
