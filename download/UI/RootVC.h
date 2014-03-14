//
//  RootVC.h
//  download
//
//  Created by Haijiao on 14-3-10.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "VCBase.h"
#import "DownManage.h"

@interface RootVC : VCBase<DownloadDataDelegate,DownloadDelegate,UIActionSheetDelegate>{
    IBOutlet UITableView * m_table;
    NSMutableArray * m_arr_item;
}

@end
