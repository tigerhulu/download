//
//  VCManage.h
//  download
//
//  Created by Haijiao on 14-3-10.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCBase.h"
#import "RootVC.h"

@interface VCManage : UINavigationController

@property (nonatomic,retain) RootVC * RootVC;

+(VCManage *)shared;

@end
