//
//  DownloadCell.h
//  download
//
//  Created by Haijiao on 14-3-11.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BE_Download.h"

@interface DownloadCell : UITableViewCell<DownloadDelegate>

@property (nonatomic,assign) UIButton * BtnRun;

@property (nonatomic,assign) UILabel * Title;

@property (nonatomic,assign) UIProgressView * Progress;

@property (nonatomic,assign) UILabel * Percent;

@property (nonatomic,assign) UILabel * Result;

-(void)DownloadDelegateStatueChange:(DownloadType)downloadType;

@end
