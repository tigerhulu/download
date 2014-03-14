//
//  VCManage.m
//  download
//
//  Created by Haijiao on 14-3-10.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "VCManage.h"

@interface VCManage ()

@end

static VCManage * _VCManage;
@implementation VCManage

+(VCManage *)shared
{
    if (!_VCManage) {
		@synchronized(self) {
			if (!_VCManage) {
                RootVC * vc = [[RootVC alloc] init];
				_VCManage = [[[VCManage alloc] initWithRootViewController:vc] autorelease];
                _VCManage.RootVC = vc;
                [vc release];
			}
		}
	}
    return _VCManage;
}

@end
