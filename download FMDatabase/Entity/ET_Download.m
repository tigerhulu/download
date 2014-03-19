//
//  ET_Download.m
//  download
//
//  Created by Haijiao on 14-3-19.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "ET_Download.h"
#import "DB_Download.h"
#import "DownManage.h"

@implementation ET_Download

-(void)setDelegate:(id<DownloadDelegate>)Delegate
{
    _Delegate = Delegate;
    if (_Delegate) {
        if (_TotalSize==0) {
            if ([_Delegate respondsToSelector:@selector(DownloadDelegate:SetProgressAnim:)]) {
                [_Delegate DownloadDelegate:self SetProgressAnim:NO];
            }
            return;
        }
        if ([_Delegate respondsToSelector:@selector(DownloadDelegate:SetProgressAnim:)]) {
            [_Delegate DownloadDelegate:self SetProgressAnim:NO];
        }
        if (_IsFinish && [_Delegate respondsToSelector:@selector(DownloadDelegate:StatueChange:)]) {
            [_Delegate DownloadDelegate:self StatueChange:Download_Complete];
        }
    }
}

-(void)start
{
    [self runThread:Download_Run];
}

-(void)stop
{
    [self runThread:Download_Stop];
}

-(void)runThread:(DownloadType)downType
{
    DownManage * manage = [DownManage shared];
    switch (downType) {
        case DownLoad_Wait:
            _DownloadType = downType;
            if (_Delegate && [_Delegate respondsToSelector:@selector(DownloadDelegate:StatueChange:)]) {
                [_Delegate DownloadDelegate:self StatueChange:DownLoad_Wait];
            }
            break;
        case Download_Run:
            if (_DownloadType==Download_Run || _IsFinish || _Url.length<10) {
                return;
            }
            if (manage.RunCount==MAXDOWNCOUNT) {
                [self runThread:DownLoad_Wait];
                return;
            }
            
            _DownloadType = downType;
            if (_Delegate && [_Delegate respondsToSelector:@selector(DownloadDelegate:StatueChange:)]) {
                [_Delegate DownloadDelegate:self StatueChange:Download_Run];
            }
            
            NetRequestTask * newTask = [NetRequestTask TaskWithProxy:self];
            newTask.ProgressBar = self;
            newTask.Url = _Url;
            newTask.LocalPath = _FilePath;
            newTask.CallBack = _Url;
            [[NetRequestFactory shared] asyRequestResource:newTask];
            break;
        case Download_Stop:
            if (_DownloadType!=DownLoad_Wait && _DownloadType!=Download_Run) {
                return;
            }
            
            _DownloadType = downType;
            if (_Delegate && [_Delegate respondsToSelector:@selector(DownloadDelegate:StatueChange:)]) {
                [_Delegate DownloadDelegate:self StatueChange:Download_Stop];
            }
            
            [[NetRequestFactory shared] cancelRequest:_Url];
            break;
        case Download_Complete:
            if (_IsFinish) {
                return;
            }
            _IsFinish = YES;
            
            _DownloadType = downType;
            if (_Delegate && [_Delegate respondsToSelector:@selector(DownloadDelegate:StatueChange:)]) {
                [_Delegate DownloadDelegate:self StatueChange:downType];
            }
            break;
        case Download_Fail:
            _DownloadType = downType;
            if (_Delegate && [_Delegate respondsToSelector:@selector(DownloadDelegate:StatueChange:)]) {
                [_Delegate DownloadDelegate:self StatueChange:downType];
            }
            break;
    }
    
    [DB_Download updateDownload:self];
    
    [manage dealChange:self];
}

#pragma mark -
-(void)setProgress:(float)progress
{
    _CurSize = _TotalSize*progress;
    if (_Delegate && [_Delegate respondsToSelector:@selector(DownloadDelegate:SetProgressAnim:)] && _DownloadType==Download_Run) {
        [_Delegate DownloadDelegate:self SetProgressAnim:YES];
    }
}

-(void)onResourceRequestStartTask:(NetRequestTask *)requestTask
{
    if (_TotalSize==0) {
        self.TotalSize = requestTask.TotalSize;
        [DB_Download updateDownload:self];
    }
}

-(void)onResourceRequestTask:(NetRequestTask *)requestTask Resource:(NSString *)resource
{
    if (resource.length>0) {
        if (_TotalSize==0) {
            _TotalSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:resource error:nil] fileSize];
            _CurSize = _TotalSize;
        }
        [self runThread:Download_Complete];
    }else{
        [self runThread:Download_Fail];
    }
}

-(void)updateStatue
{
    if (_DownloadType==Download_Complete) {
        return;
    }
    if (_Url.length<10) {
        _DownloadType = Download_Fail;
        return;
    }
    if (_TotalSize==0) {
        _DownloadType = DownLoad_Wait;
        return;
    }
    NSString * path = _FilePath;
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]){ //文件存在
        _DownloadType = Download_Complete;
        _TotalSize = [[manager attributesOfItemAtPath:path error:nil] fileSize];
        _CurSize = _TotalSize;
        _IsFinish = YES;
        [DB_Download updateDownload:self];
        return;
    }else{
        path = [path stringByAppendingString:@".download"];
        if ([manager fileExistsAtPath:path]){ //下载文件
            _CurSize = [[manager attributesOfItemAtPath:path error:nil] fileSize];
        }
    }
}

-(void)dealloc
{
    self.Url = nil;
    self.FilePath = nil;
    [super dealloc];
}

@end
