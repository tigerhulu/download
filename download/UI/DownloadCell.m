//
//  DownloadCell.m
//  download
//
//  Created by Haijiao on 14-3-11.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "DownloadCell.h"

@implementation DownloadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.BtnRun = [UIButton buttonWithType:UIButtonTypeCustom];
        _BtnRun.frame = CGRectMake(5, 10, 60, 60);
        [self addSubview:_BtnRun];
        
        self.Title = [[[UILabel alloc] initWithFrame:CGRectMake(60, 13, 240, 20)] autorelease];
        _Title.lineBreakMode = UILineBreakModeMiddleTruncation;
        _Title.font = [UIFont systemFontOfSize:15];
        [self addSubview:_Title];
        
        self.Progress = [[[UIProgressView alloc] initWithFrame:CGRectMake(60, 47, 150, 40)] autorelease];
        _Progress.progressViewStyle = UIProgressViewStyleBar;
        _Progress.trackTintColor = [UIColor colorWithRed:208.0/255 green:226.0/255 blue:240.0/255 alpha:1];
        _Progress.progressTintColor = [UIColor colorWithRed:16.0/255 green:130.0/255 blue:182.0/255 alpha:1];
        _Progress.progress = 1;
        [self addSubview:_Progress];
        
        self.Percent = [[[UILabel alloc] initWithFrame:CGRectMake(220, 36, 90, 20)] autorelease];
        _Percent.font = [UIFont systemFontOfSize:12];
        [self addSubview:_Percent];
        
        self.Result = [[[UILabel alloc] initWithFrame:CGRectMake(60, 57, 200, 20)] autorelease];
        _Result.font = [UIFont systemFontOfSize:12];
        [self addSubview:_Result];
        
    }
    return self;
}

-(void)DownloadDelegateSetProgressCurSize:(long long)curSize TotalSize:(long long)totalSize Anim:(BOOL)anim
{
    float total = totalSize;
    if (total==0) {
        _Percent.text = @"--/--";
        [_Progress setProgress:0 animated:NO];
        return;
    }
    
    NSString * unit = nil;
    if (total>1024*1024) {
        total = totalSize/1024.0/1024.0;
        unit = @"M";
    }else{
        total = totalSize/1024.0;
        unit = @"K";
    }
    
    float cur = [unit isEqual:@"K"]?curSize/1024.0:curSize/1024.0/1024.0;
    [_Progress setProgress:cur/total animated:anim];
    _Percent.text = [NSString stringWithFormat:@"%0.1f%@/%0.1f%@",cur,unit,total,unit];
}

-(void)DownloadDelegateStatueChange:(DownloadType)downloadType
{
    switch (downloadType) {
        case DownLoad_Wait:
            [_BtnRun setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
            _Result.text = @"等待下载...";
            break;
        case Download_Run:
            [_BtnRun setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
            _Result.text = @"下载中...";
            break;
        case Download_Stop:
            [_BtnRun setImage:[UIImage imageNamed:@"run.png"] forState:UIControlStateNormal];
            _Result.text = @"已暂停，点击继续下载";
            break;
        case Download_Complete:
            [_Progress setProgress:1 animated:YES];
            [_BtnRun setImage:nil forState:UIControlStateNormal];
            _Result.text = @"下载完成";
            break;
        case Download_Fail:
            [_BtnRun setImage:[UIImage imageNamed:@"fail.png"] forState:UIControlStateNormal];
            _Result.text = @"下载失败，点击重试";
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
