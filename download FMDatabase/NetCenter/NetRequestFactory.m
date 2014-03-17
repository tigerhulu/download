//
//  NetRequestFactory.m
//  FpiFramework
//
//  Created by hj on 13-8-20.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import "NetRequestFactory.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "Resource.h"

#define NET_INFO_REQUEST   @"NET_INFO_REQUEST"
#define NET_INFO_TYPE      @"NET_INFO_TYPE"
#define NET_INFO_WEB       @"NET_INFO_WEB"
#define NET_INFO_FILE      @"NET_INFO_FILE"
#define NET_INFO_UPLOAD    @"NET_INFO_UPLOAD"

#define NET_INFO_PATH      @"NET_INFO_PATH"

#define TIME_OUT_SECONDS 30

@interface NetRequestFactory ()
{
    ASINetworkQueue * m_newtworkQueue;
    NSLock * m_lock;
}

@end

@implementation NetRequestFactory

/**
	创建下载文件路径
	@param file 文件名
	@returns 完整文件路径
 */
-(NSString *)dealDownloadPath:(NetRequestTask * )task
{
    NSString * destinationPath = task.LocalPath;
    if (destinationPath) {
        [Resource createPath:destinationPath];
        return destinationPath;
    }
    
    NSString * file = task.Url;
    if (file.length>7 && [[[file substringToIndex:7] lowercaseString] compare:@"http://"]==NSOrderedSame) {
        file = [file substringFromIndex:7];
    }
    
    destinationPath=[NSString stringWithFormat:@"%@%@",[Resource getResourcesPath],file];
    [Resource createPath:destinationPath];
    
    return destinationPath;
}

#pragma mark - SYN
//同步数据请求
-(NSString *)synRequestWeb:(NetRequestTask *)requestTask
{
    if (!requestTask) {
        return nil;
    }
    NSURL * url = [NSURL URLWithString:requestTask.Url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.timeOutSeconds = TIME_OUT_SECONDS;
    if (requestTask.Param) {
        for (NSString * key in [requestTask.Param allKeys]) {
            [request setPostValue:[requestTask.Param objectForKey:key] forKey:key];
        }
    }
    [request startSynchronous];
    return [self dealWith:request];
}

//同步文件请求
-(NSString *)synRequestResource:(NetRequestTask *)requestTask
{
    if (!requestTask) {
        return nil;
    }
    NSURL * url = [NSURL URLWithString:requestTask.Url];
    NSString * destination = [self dealDownloadPath:requestTask];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadDestinationPath:destination];
    [request setDownloadProgressDelegate:requestTask.ProgressBar];
    [request startSynchronous];
    
    BOOL dirExist=[[NSFileManager defaultManager] fileExistsAtPath:destination isDirectory:nil];
    if (dirExist) {
        return destination;
    }
    return nil;
}

//同步文件上传
-(NSString *)synUpload:(NetRequestTask *)requestTask
{
    if (!requestTask) {
        return nil;
    }
    NSArray * file = requestTask.File;
    if (!file || [file count]<1) {
        return nil;
    }
    NSURL * url = [NSURL URLWithString:requestTask.Url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if (requestTask.Param) {
        for (NSString * key in [requestTask.Param allKeys]) {
            [request setPostValue:[requestTask.Param objectForKey:key] forKey:key];
        }
    }
    for (NSString * path in [file objectEnumerator]) {
        [request setFile:path forKey:@"file"];
    }
    [request setUploadProgressDelegate:requestTask.ProgressBar];
    [request startSynchronous];
    return [self dealWith:request];
}

-(NSString *)dealWith:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if (!error && request.responseStatusCode != 404) {
        return [request responseString];
    }
    return nil;
}

#pragma mark - ASY
//异步数据请求
-(void)asyRequestWeb:(NetRequestTask *)requestTask
{
    if (!requestTask) {
        return;
    }
    NSURL * url = [NSURL URLWithString:requestTask.Url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.timeOutSeconds = TIME_OUT_SECONDS;
    
    NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:requestTask, NET_INFO_REQUEST, NET_INFO_WEB,NET_INFO_TYPE, nil];
    [request setUserInfo:info];
    
    if (requestTask.Param) {
        for (NSString * key in [requestTask.Param allKeys]) {
            [request setPostValue:[requestTask.Param objectForKey:key] forKey:key];
        }
    }
    [m_lock lock];
    [m_newtworkQueue addOperation:request];
    [m_newtworkQueue go];
    [m_lock unlock];
}

//异步文件请求
-(void)asyRequestResource:(NetRequestTask *)requestTask
{
    if (!requestTask) {
        return;
    }
    NSURL * url = [NSURL URLWithString:requestTask.Url];
    NSString * destination = [self dealDownloadPath:requestTask];
    NSString * tempPath = [destination stringByAppendingString:@".download"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadProgressDelegate:requestTask.ProgressBar];
    [request setDownloadDestinationPath:destination];
    [request setTemporaryFileDownloadPath:tempPath];
    [request setAllowResumeForFileDownloads:YES];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
    NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:requestTask, NET_INFO_REQUEST, NET_INFO_FILE, NET_INFO_TYPE, destination, NET_INFO_PATH, nil];
    [request setUserInfo:info];
    [m_lock lock];
    [m_newtworkQueue addOperation:request];
    [m_newtworkQueue go];
    [m_lock unlock];
}

//异步文件上传
-(void)asyUpload:(NetRequestTask *)requestTask
{
    if (!requestTask) {
        return;
    }
    NSArray * file = requestTask.File;
    if (!file || [file count]<1) {
        return;
    }
    NSURL * url = [NSURL URLWithString:requestTask.Url];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if (requestTask.Param) {
        for (NSString * key in [requestTask.Param allKeys]) {
            [request setPostValue:[requestTask.Param objectForKey:key] forKey:key];
        }
    }
    for (NSString * path in [file objectEnumerator]) {
        [request setFile:path forKey:@"file"];
    }
    [request setUploadProgressDelegate:requestTask.ProgressBar];
    NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:requestTask, NET_INFO_REQUEST, NET_INFO_UPLOAD, NET_INFO_TYPE, nil];
    [request setUserInfo:info];
    [m_lock lock];
    [m_newtworkQueue addOperation:request];
    [m_newtworkQueue go];
    [m_lock unlock];
}

//取消请求
-(void)cancelRequest:(NSString *)callback
{
    if (!callback || callback.length<1) {
        return;
    }
    [m_lock lock];
    
    for (ASIHTTPRequest * request in [m_newtworkQueue operations]) {
        NSDictionary * info = request.userInfo;
        NetRequestTask * task = [info objectForKey:NET_INFO_REQUEST];
        if ([task.CallBack compare:callback] == NSOrderedSame) {
            task.Delegate = nil;
            [request clearDelegatesAndCancel];
            break;
        }
    }
    
    [m_lock unlock];
}

#pragma mark - ASIDelegate
/**
    HTTP请求开始
 */
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSDictionary * info = request.userInfo;
    NetRequestTask * task = [info objectForKey:NET_INFO_REQUEST];
    task.TotalSize = request.contentLength;
    id <NetRequestProxy> _Delegate = task.Delegate;
    if (_Delegate && [_Delegate respondsToSelector:@selector(onResourceRequestStartTask:)]) {
        [_Delegate onResourceRequestStartTask:task];
    }
}

/**
	HTTP请求成功
 */
-(void)onRequestFinish:(ASIHTTPRequest *)request
{
    NSDictionary * info = request.userInfo;
    NetRequestTask * task = [info objectForKey:NET_INFO_REQUEST];
    id <NetRequestProxy> _Delegate = task.Delegate;
    NSString * type = [info objectForKey:NET_INFO_TYPE];
    NSError *error = [request error];
    if ([type compare:NET_INFO_WEB]==NSOrderedSame || [type compare:NET_INFO_UPLOAD]==NSOrderedSame) {
        if (_Delegate && [_Delegate respondsToSelector:@selector(onWebRequestTask:Response:)]) {
            if (!error && request.responseStatusCode!=404) {
                [_Delegate onWebRequestTask:task Response:[request responseString]];
            }else{
                [_Delegate onWebRequestTask:task Response:nil];
            }
        }
    }else{
        if (_Delegate && [_Delegate respondsToSelector:@selector(onResourceRequestTask:Resource:)]) {
            NSString * path = [info objectForKey:NET_INFO_PATH];
            BOOL dirExist=[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil];
            if (!error && request.responseStatusCode!=404 && dirExist){
                [_Delegate onResourceRequestTask:task Resource:path];
            }else{
                [_Delegate onResourceRequestTask:task Resource:nil];
            }
        }
    }
}

/**
	HTTP请求失败
 */
-(void)onRequestFailed:(ASIHTTPRequest *)request
{
    NSDictionary * info = request.userInfo;
    NetRequestTask * task = [info objectForKey:NET_INFO_REQUEST];
    id <NetRequestProxy> _Delegate = task.Delegate;
    NSString * type = [info objectForKey:NET_INFO_TYPE];
    if ([type compare:NET_INFO_WEB]==NSOrderedSame || [type compare:NET_INFO_UPLOAD]==NSOrderedSame) {
        if (_Delegate && [_Delegate respondsToSelector:@selector(onWebRequestTask:Response:)]) {
            [_Delegate onWebRequestTask:task Response:nil];
        }
    }else{
        if (_Delegate && [_Delegate respondsToSelector:@selector(onResourceRequestTask:Resource:)]) {
            [_Delegate onResourceRequestTask:nil Resource:nil];
        }
    }
}


static NetRequestFactory * _NetRequestFactory;
#pragma mark -
+(NetRequestFactory *)shared
{
    if (!_NetRequestFactory) {
		@synchronized(self) {
			if (!_NetRequestFactory) {
				_NetRequestFactory = [[[self class] alloc] init];
			}
		}
	}
    return _NetRequestFactory;
}

-(id)init
{
    if (self= [super init]) {
        
        m_newtworkQueue = [[ASINetworkQueue alloc] init];
        [m_newtworkQueue reset];
        [m_newtworkQueue setDelegate:self];
        [m_newtworkQueue setShowAccurateProgress:YES];
        [m_newtworkQueue setShouldCancelAllRequestsOnFailure:NO];
        [m_newtworkQueue setRequestDidReceiveResponseHeadersSelector:@selector(request:didReceiveResponseHeaders:)];
        [m_newtworkQueue setRequestDidFinishSelector:@selector(onRequestFinish:)];
        [m_newtworkQueue setRequestDidFailSelector:@selector(onRequestFailed:)];
        
        m_lock = [[NSLock alloc] init];
        
    }
    return self;
}

@end
