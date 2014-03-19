//
//  DB_Download.h
//  download
//
//  Created by Haijiao on 14-3-17.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "DB_Base.h"
#import "ET_Download.h"

@interface DB_Download : DB_Base

+(void)createTableDownload;

+(NSArray *)queryDownloadWithUrl:(NSString *)url;

+(void)deleteDownloadWithUrl:(NSString *)url;

+(void)addDownload:(ET_Download *)download;

+(void)updateDownload:(ET_Download *)download;

@end
