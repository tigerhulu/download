//
//  BE_Download.h
//  download
//
//  Created by Haijiao on 14-3-10.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "BE_Base.h"
#import "NetRequestTask.h"

typedef NS_ENUM(NSInteger, DownloadType)
{
    DownLoad_Wait = 0,
    Download_Run = 1,
    Download_Stop = 2,
    Download_Complete = 3,
    Download_Fail = 4,
};

@protocol DownloadDelegate <NSObject>

-(void)DownloadDelegateSetProgressCurSize:(long long)curSize TotalSize:(long long)totalSize Anim:(BOOL)anim;

-(void)DownloadDelegateStatueChange:(DownloadType)downloadType;

@end

@interface BE_Download : BE_Base<NetRequestProxy>{
    id<DownloadDelegate> m_delegate;
}

@property (nonatomic,copy) NSString * Url;

@property (nonatomic,assign) long long CurSize;

@property (nonatomic,assign) long long TotalSize;

@property (nonatomic,assign) BOOL IsFinish;

@property (nonatomic,assign) DownloadType DownloadType;

+(BE_Download *)getObjectWithUrl:(NSString *)url;

-(void)setDelegate:(id<DownloadDelegate>)Delegate;

-(void)runThread:(DownloadType)downType;

-(void)setProgress:(float)progress;

-(void)updateStatue;

@end
