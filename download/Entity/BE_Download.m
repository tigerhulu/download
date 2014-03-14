//
//  BE_Download.m
//  download
//
//  Created by Haijiao on 14-3-10.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "BE_Download.h"
#import "DownManage.h"

@implementation BE_Download

+(BE_Download *)getObjectWithUrl:(NSString *)url
{
    if (url.length<10) {
        return nil;
    }
    BE_Download * download = (BE_Download *)[BE_Download findFirstByCriteria:[NSString stringWithFormat:@"WHERE Url = '%@'",url]];
    return download;
}

-(void)setDelegate:(id<DownloadDelegate>)Delegate
{
    if (m_delegate) {
        [m_delegate release];
        m_delegate = nil;
    }
    
    if (Delegate) {
        m_delegate = [Delegate retain];
        if (_TotalSize==0) {
            if ([m_delegate respondsToSelector:@selector(DownloadDelegateSetProgressCurSize:TotalSize:Anim:)]) {
                [m_delegate DownloadDelegateSetProgressCurSize:0 TotalSize:0 Anim:NO];
            }
            return;
        }
        if ([m_delegate respondsToSelector:@selector(DownloadDelegateSetProgressCurSize:TotalSize:Anim:)]) {
            [m_delegate DownloadDelegateSetProgressCurSize:_CurSize TotalSize:_TotalSize Anim:NO];
        }
        if (_IsFinish && [m_delegate respondsToSelector:@selector(DownloadDelegateStatueChange:)]) {
            [m_delegate DownloadDelegateStatueChange:Download_Complete];
        }
    }
}

-(void)runThread:(DownloadType)downType
{
    DownManage * manage = [DownManage shared];
    switch (downType) {
        case DownLoad_Wait:
            _DownloadType = downType;
            if (m_delegate && [m_delegate respondsToSelector:@selector(DownloadDelegateStatueChange:)]) {
                [m_delegate DownloadDelegateStatueChange:DownLoad_Wait];
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
            if (m_delegate && [m_delegate respondsToSelector:@selector(DownloadDelegateStatueChange:)]) {
                [m_delegate DownloadDelegateStatueChange:Download_Run];
            }
            
            NetRequestTask * newTask = [NetRequestTask TaskWithProxy:self];
            newTask.ProgressBar = self;
            newTask.Url = _Url;
            newTask.CallBack = _Url;
            [[NetRequestFactory shared] asyRequestResource:newTask];
            break;
        case Download_Stop:
            if (_DownloadType!=DownLoad_Wait && _DownloadType!=Download_Run) {
                return;
            }
            
            _DownloadType = downType;
            if (m_delegate && [m_delegate respondsToSelector:@selector(DownloadDelegateStatueChange:)]) {
                [m_delegate DownloadDelegateStatueChange:Download_Stop];
            }
            
            [[NetRequestFactory shared] cancelRequest:_Url];
            break;
        case Download_Complete:
            if (_IsFinish) {
                return;
            }
            _IsFinish = YES;
            
            _DownloadType = downType;
            if (m_delegate && [m_delegate respondsToSelector:@selector(DownloadDelegateStatueChange:)]) {
                [m_delegate DownloadDelegateStatueChange:downType];
            }
            break;
        case Download_Fail:
            _DownloadType = downType;
            if (m_delegate && [m_delegate respondsToSelector:@selector(DownloadDelegateStatueChange:)]) {
                [m_delegate DownloadDelegateStatueChange:downType];
            }
            break;
    }
    
    [self markDirty];
    [self save];
    
    [manage dealChange:self];
}

#pragma mark - 
-(void)setProgress:(float)progress
{
    _CurSize = _TotalSize*progress;
    if (m_delegate && [m_delegate respondsToSelector:@selector(DownloadDelegateSetProgressCurSize:TotalSize:Anim:)] && _DownloadType==Download_Run) {
        [m_delegate DownloadDelegateSetProgressCurSize:_CurSize TotalSize:_TotalSize Anim:YES];
    }
}

-(void)onResourceRequestStartTask:(NetRequestTask *)requestTask
{
    if (_TotalSize==0) {
        self.TotalSize = requestTask.TotalSize;
        [self save];
    }
}

-(void)onResourceRequestTask:(NetRequestTask *)requestTask Resource:(NSString *)resource
{
    if (resource.length>0) {
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
    NSString * path = [Resource getResourcePathWithName:_Url];
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]){ //文件存在
        _DownloadType = Download_Complete;
        _TotalSize = [[manager attributesOfItemAtPath:path error:nil] fileSize];
        _CurSize = _TotalSize;
        _IsFinish = YES;
        [self markDirty];
        [self save];
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
    
    [m_delegate release];    
    [super dealloc];
}

@end
