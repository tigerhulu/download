//
//  NetRequestTask.h
//  FpiFramework
//
//  Created by hj on 13-8-20.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetRequestTask;
@protocol NetRequestProxy <NSObject>

/**
	异步请求回调接口
 */
@optional
-(void)onWebRequestTask:(NetRequestTask *)requestTask Response:(NSString*)response;
-(void)onResourceRequestTask:(NetRequestTask *)requestTask Resource:(NSString *)resource;
-(void)onResourceRequestStartTask:(NetRequestTask *)requestTask;

@end

/**
	网络请求对象，异步请求请设置id<NetRequestProxy>
 */
@interface NetRequestTask : NSObject

/**
	请求URL
 */
@property (nonatomic,retain) NSString * Url;

/**
	回调接口
 */
@property (nonatomic,retain) NSString * CallBack;

/**
	参数
 */
@property (nonatomic,retain) NSDictionary * Param;

/**
	上传文件路径
 */
@property (nonatomic,retain) NSArray * File;

/**
    文件保存路径
 */
@property (nonatomic,retain) NSString * LocalPath;

/**
    文件大小
 */
@property (nonatomic,assign) long long TotalSize;

/**
	进度条
 */
@property (nonatomic,assign) id ProgressBar;

/**
	回调对象
 */
@property (nonatomic,assign) id<NetRequestProxy> Delegate;


+(NetRequestTask *)TaskWithProxy:(id<NetRequestProxy>)delegate;

@end
