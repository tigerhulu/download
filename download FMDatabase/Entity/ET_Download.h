//
//  ET_Download.h
//  download
//
//  Created by Haijiao on 14-3-19.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequestTask.h"

typedef NS_ENUM(NSInteger, DownloadType)
{
    DownLoad_Wait = 0,
    Download_Run = 1,
    Download_Stop = 2,
    Download_Complete = 3,
    Download_Fail = 4,
};

@protocol DownloadDelegate;
@interface ET_Download : NSObject<NetRequestProxy>{
    
}

@property (nonatomic,copy) NSString * Url;

@property (nonatomic,copy) NSString * FilePath;

@property (nonatomic,assign) long long CurSize;

@property (nonatomic,assign) long long TotalSize;

@property (nonatomic,assign) BOOL IsFinish;

@property (nonatomic,assign) DownloadType DownloadType;

@property (nonatomic,assign) id<DownloadDelegate> Delegate;

-(void)updateStatue;

-(void)start;

-(void)stop;

@end

@protocol DownloadDelegate <NSObject>

-(void)DownloadDelegate:(ET_Download *)download SetProgressAnim:(BOOL)anim;

-(void)DownloadDelegate:(ET_Download *)download StatueChange:(DownloadType)downloadType;

@end
