//
//  NetRequestFactory.h
//  FpiFramework
//
//  Created by hj on 13-8-20.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequestTask.h"

/**
	HTTP网络请求接口，主要负责网络的请求和取消
 */
@interface NetRequestFactory : NSObject

/**
	单例
 */
+(NetRequestFactory *)shared;


/**
	同步数据请求
	@returns 数据
 */
-(NSString *)synRequestWeb:(NetRequestTask *)requestTask;

/**
	同步文件请求
	@returns 文件路径
 */
-(NSString *)synRequestResource:(NetRequestTask *)requestTask;

/**
	同步文件上传
	@returns 数据
 */
-(NSString *)synUpload:(NetRequestTask *)requestTask;


/**
	异步数据请求
 */
-(void)asyRequestWeb:(NetRequestTask *)requestTask;

/**
	异步文件请求
 */
-(void)asyRequestResource:(NetRequestTask *)requestTask;

/**
	异步文件上传
 */
-(void)asyUpload:(NetRequestTask *)requestTask;

/**
	取消请求
	@param callback 回调接口
 */
-(void)cancelRequest:(NSString *)callback;

@end
