//
//  DownloadCell.h
//  download
//
//  Created by Haijiao on 14-3-11.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BE_Download;

@interface DownloadCell : UITableViewCell

@property (nonatomic,assign) UIButton * BtnRun;

@property (nonatomic,assign) UILabel * Title;

@property (nonatomic,assign) UIProgressView * Progress;

@property (nonatomic,assign) UILabel * Percent;

@property (nonatomic,assign) UILabel * Result;

-(void)setProgressCurSize:(long long)curSize TotalSize:(long long)totalSize Anim:(BOOL)anim;

-(void)setCurStatue:(DownloadType)downloadType;

@end
