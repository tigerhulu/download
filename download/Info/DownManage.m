//
//  DownManage.m
//  download
//
//  Created by Haijiao on 14-3-10.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "DownManage.h"

static DownManage * _DownManage;
@implementation DownManage

+(DownManage *)shared
{
    if (!_DownManage) {
		@synchronized(self) {
            
			if (!_DownManage) {
                _DownManage = [[DownManage alloc] init];
                [_DownManage initData];
			}
		}
	}
    return _DownManage;
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
        BE_Download * download = [_ArrItem objectAtIndex:i];
        [download save];
    }
}

-(void)updateData
{
    [_ArrItem removeAllObjects];
    NSArray * arr = [BE_Download allObjects];
    if ([arr count]<1) {
        return;
    }
    [_ArrItem addObjectsFromArray:arr];
    [m_dic_item removeAllObjects];
    int count = [_ArrItem count];
    BE_Download * download = nil;
    for (int i=0; i<count; i++) {
        download = [_ArrItem objectAtIndex:i];
        [download updateStatue];
        [m_dic_item setObject:download forKey:download.Url];
        if (download.DownloadType==Download_Run) {
            download.DownloadType = DownLoad_Wait;
            [download runThread:Download_Run];
        }
    }
    [self continueDownload];
}

-(int)RunCount
{
    return [m_dic_run count];
}

-(void)dealChange:(BE_Download *)download
{
    NSString * url = download.Url;
    BE_Download * runDownload = [m_dic_run objectForKey:url];
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
    BE_Download * download = nil;
    
    for (int i=0; i<count; i++) {
        download = [_ArrItem objectAtIndex:i];
        if (download.DownloadType==DownLoad_Wait) {
            [download runThread:Download_Run];
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
    BE_Download * cach_download = [m_dic_item objectForKey:url];
    if (cach_download) {
        if (cach_download.DownloadType == Download_Stop) {
            [cach_download runThread:Download_Run];
        }
        return;
    }
    
    BE_Download * download = [[BE_Download alloc] init];
    download.Url = url;
    download.DownloadType = DownLoad_Wait;
    [download save];
    [download release];
    download = nil;
    
    download = [BE_Download getObjectWithUrl:url];
    if (!download) {
        return;
    }
    
    if (_Delegate && [_Delegate respondsToSelector:@selector(DownloadDataAddDownload:)]) {
        [_Delegate DownloadDataAddDownload:download];
    }
    
    [_ArrItem addObject:download];
    [m_dic_item setObject:download forKey:download.Url];
    
    [download runThread:Download_Run];
}

-(void)removeDownloadWithUrl:(NSString *)url DeleteFile:(BOOL)isDelete
{
    if (url.length<10) {
        return;
    }
    
    BE_Download * download = [m_dic_item objectForKey:url];
    if (download && download.DownloadType == Download_Run) {
        [download runThread:Download_Stop];
        [download setDelegate:nil];
    }
    
    NSString * filePath = [Resource getResourcePathWithName:url];
    NSFileManager * manager = [NSFileManager defaultManager];
    if (isDelete && filePath.length>0) {
        [manager removeItemAtPath:filePath error:nil];
        filePath = [filePath stringByAppendingString:@".download"];
        [manager removeItemAtPath:filePath error:nil];
    }
    
    [_ArrItem removeObject:download];
    [m_dic_item removeObjectForKey:url];
    
    download = (BE_Download *)[BE_Download getObjectWithUrl:url];
    [download deleteObject];
}

-(void)dealloc
{
    [m_dic_run release];
    [m_dic_item release];
    self.ArrItem = nil;
    [super dealloc];
}

@end
