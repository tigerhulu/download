//
//  DownManage.h
//  download
//
//  Created by Haijiao on 14-3-10.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BE_Download.h"

#define MAXDOWNCOUNT 3

@protocol DownloadDataDelegate <NSObject>

-(void)DownloadDataAddDownload:(BE_Download *)download;

@end

@interface DownManage : NSObject{
    NSMutableDictionary * m_dic_run;
    NSMutableDictionary * m_dic_item;
}

@property (atomic,retain) NSMutableArray * ArrItem;

@property (nonatomic,assign) id<DownloadDataDelegate> Delegate;

@property (nonatomic,readonly) int RunCount;

+(DownManage *)shared;

-(void)storeStatue;

-(void)updateData;

-(void)dealChange:(BE_Download *)download;

-(void)addDonwloadWithUrl:(NSString *)url;

-(void)removeDownloadWithUrl:(NSString *)url DeleteFile:(BOOL)isDelete;

@end
