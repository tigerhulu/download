//
//  Util_Tableview.h
//  FpiFramework
//
//  Created by hj on 13-8-12.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFootView.h"

@protocol UtilTableViewDelegate <NSObject>
@optional
-(void)UtilTableViewDelegateReflesh;
-(void)UtilTableViewDelegateLoadMore;
@end

@interface UITableView (Util_Table)<EGORefreshTableHeaderDelegate,EGORefreshTableFootDelegate>

@property (nonatomic,assign) EGORefreshTableHeaderView * m_refreshHeaderView;
@property (nonatomic,assign) EGORefreshTableFootView   * m_refreshFooterView;
@property (nonatomic,assign) id <UtilTableViewDelegate> UtilDelegate;
@property (nonatomic,assign) BOOL UtilIsLoading;
@property (nonatomic,assign) CGPoint UtilLastPoint;

-(void)UtilTableViewAddHeadWithObj:(id)obj;
-(void)UtilTableViewAddFootWithObj:(id)obj;

//Begin Head Reflesh
-(void)UtilTableViewBeginReflesh;

//Begin Foot Load
-(void)UtilTableViewLoadMore;

//Optional Action
-(void)UtilTableViewDidRefleshData;
-(void)UtilTableViewDidLoadMoreData;
-(void)UtilTableViewModifyMoreFrame;

//Required Action
-(void)UtilTableViewWillBeginDecelerate:(UIScrollView *)scrollView;
-(void)UtilTableViewDidScroll:(UIScrollView *)scrollView;
-(void)UtilTableViewDidEndDragging:(UIScrollView *)scrollView;

//Clear CellSubView
-(void)ClearCellSubView;

@end