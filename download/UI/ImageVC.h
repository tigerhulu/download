//
//  ImageVC.h
//  download
//
//  Created by Haijiao on 14-3-12.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "VCBase.h"

@interface ImageVC : VCBase{
    IBOutlet UIImageView * m_img_bg;
}

@property (nonatomic,copy) NSString * ImgPath;

@end
