//
//  ImageVC.m
//  download
//
//  Created by Haijiao on 14-3-12.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "ImageVC.h"

@interface ImageVC ()

@end

@implementation ImageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"图片预览";
    m_img_bg.image = [UIImage imageWithContentsOfFile:_ImgPath];
}

- (void)dealloc
{
    self.ImgPath = nil;
    [m_img_bg release];
    [super dealloc];
}

@end
