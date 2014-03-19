//
//  DownManage.m
//  download
//
//  Created by Haijiao on 14-3-10.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "DownManage.h"
#import "ET_Download.h"
#import "DB_Download.h"

@implementation DownManage

+(DownManage *)shared
{
    static DownManage * _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        [_sharedInstance initData];
    });
    return _sharedInstance;
}

-(void)initData
{
    m_dic_run = [[NSMutableDictionary alloc] init];
    m_dic_item = [[NSMutableDictionary alloc] init];
    self.ArrItem = [[[NSMutableArray alloc] init] autorelease];
}

-(void)storeStatue
{
    int count = [_ArrItem count];
    for (int i=0; i<count; i++) {
        ET_Download * download = [_ArrItem objectAtIndex:i];
        [DB_Download updateDownload:download];
    }
}

-(void)updateData
{
    [_ArrItem removeAllObjects];
    NSArray * arr = [DB_Download queryDownloadWithUrl:nil];
    if ([arr count]<1) {
        return;
    }
    [_ArrItem addObjectsFromArray:arr];
    [m_dic_item removeAllObjects];
    int count = [_ArrItem count];
    ET_Download * download = nil;
    for (int i=0; i<count; i++) {
        download = [_ArrItem objectAtIndex:i];
        [download updateStatue];
        [m_dic_item setObject:download forKey:download.Url];
        if (download.DownloadType==Download_Run) {
            download.DownloadType = DownLoad_Wait;
            [download start];
        }
    }
    [self continueDownload];
}

-(int)RunCount
{
    return [m_dic_run count];
}

-(void)dealChange:(ET_Download *)download
{
    NSString * url = download.Url;
    ET_Download * runDownload = [m_dic_run objectForKey:url];
    switch (download.DownloadType) {
        case DownLoad_Wait:
            break;
        case Download_Run:
            if ([self RunCount]==MAXDOWNCOUNT) {
                return;
            }
            if (!runDownload) {
                [m_dic_run setObject:download forKey:url];
            }
            break;
        case Download_Stop:
        case Download_Complete:
        case Download_Fail:
            if (runDownload) {
                [m_dic_run removeObjectForKey:url];
            }
            [self continueDownload];
            break;
    }
}

-(void)continueDownload
{
    int curCount = [self RunCount];
    if (curCount==MAXDOWNCOUNT) {
        return;
    }
    
    int count = [_ArrItem count];
    ET_Download * download = nil;
    
    for (int i=0; i<count; i++) {
        download = [_ArrItem objectAtIndex:i];
        if (download.DownloadType==DownLoad_Wait) {
            [download start];
            curCount++;
            if (curCount==MAXDOWNCOUNT) {
                break;
            }
        }
    }
}

#pragma mark -
-(void)addDonwloadWithUrl:(NSString *)url
{
    if (url.length<10) {
        return;
    }
    ET_Download * cach_download = [m_dic_item objectForKey:url];
    if (cach_download) {
        if (cach_download.DownloadType == Download_Stop) {
            [cach_download start];
        }
        return;
    }
    
    ET_Download * download = [[[ET_Download alloc] init] autorelease];
    download.Url = url;
    download.FilePath = [Resource getResourcePathWithName:[url lastPathComponent]];
    download.DownloadType = DownLoad_Wait;
    [DB_Download addDownload:download];
    
    if (_Delegate && [_Delegate respondsToSelector:@selector(DownloadDataAddDownload:)]) {
        [_Delegate DownloadDataAddDownload:download];
    }
    
    [_ArrItem addObject:download];
    [m_dic_item setObject:download forKey:download.Url];
    
    [download start];
}

-(void)removeDownloadWithUrl:(NSString *)url DeleteFile:(BOOL)isDelete
{
    if (url.length<10) {
        return;
    }
    
    ET_Download * download = [m_dic_item objectForKey:url];
    if (download && download.DownloadType == Download_Run) {
        [download stop];
        [download setDelegate:nil];
    }
    
    NSString * filePath = download.FilePath;
    NSFileManager * manager = [NSFileManager defaultManager];
    if (isDelete && filePath.length>0) {
        [manager removeItemAtPath:filePath error:nil];
        filePath = [filePath stringByAppendingString:@".download"];
        [manager removeItemAtPath:filePath error:nil];
    }
    
    [_ArrItem removeObject:download];
    [m_dic_item removeObjectForKey:url];
    
    [DB_Download deleteDownloadWithUrl:url];
}

-(void)dealloc
{
    [m_dic_run release];
    [m_dic_item release];
    self.ArrItem = nil;
    [super dealloc];
}

@end
