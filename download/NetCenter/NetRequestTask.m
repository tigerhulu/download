//
//  NetRequestTask.m
//  FpiFramework
//
//  Created by hj on 13-8-20.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import "NetRequestTask.h"

@implementation NetRequestTask

+(NetRequestTask *)TaskWithProxy:(id<NetRequestProxy>)delegate
{
    return [[[NetRequestTask alloc] initWithProxy:delegate] autorelease];
}

-(id)initWithProxy:(id<NetRequestProxy>)delegate
{
    self=[self init];
    if (self) {
        self.Delegate = delegate;
    }
    return self;
}

-(void)dealloc
{
    self.Url = nil;
    self.CallBack = nil;
    self.Param = nil;
    self.File = nil;
    self.ProgressBar = nil;
    self.Delegate = nil;
    [super dealloc];
}

@end
