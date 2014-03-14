//
//  Util_Tableview.m
//  FpiFramework
//
//  Created by hj on 13-8-12.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import "Util_Tableview.h"
#import <objc/runtime.h>

#define UTIL_TABLEHEAD      @"Util_TableHead"
#define UTIL_TABLEFOOT      @"Util_TableFoot"
#define UTIL_TABLEDELEGATE  @"Util_TableDelegate"
#define UTIL_TABLEISLOADING @"Util_TableIsLoading"
#define UTIL_TABLELASTPOINT @"Util_TableLastPoint"

@implementation UITableView (Util_Table)

-(void)UtilTableViewAddHeadWithObj:(id)obj{
    if (!self.m_refreshHeaderView) {
		EGORefreshTableHeaderView * view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
		view.delegate = self;
		[self addSubview:view];
		self.m_refreshHeaderView = view;
		[view release];
	}
    self.UtilDelegate =obj;
}

-(void)UtilTableViewAddFootWithObj:(id)obj{
    if (!self.m_refreshFooterView) {
		EGORefreshTableFootView * view = [[EGORefreshTableFootView alloc] initWithFrame: CGRectMake(0, self.contentSize.height, self.frame.size.width, 650)];
		view.delegate = self;
		[self addSubview:view];
		self.m_refreshFooterView = view;
        [view release];
        self.UtilDelegate =obj;
	}
}

//Begin Head Reflesh
-(void)UtilTableViewBeginReflesh{
    if (!self.m_refreshHeaderView || [self.m_refreshHeaderView isHidden]) {
        return;
    }
    self.UtilIsLoading = YES;
    [self.m_refreshHeaderView egoRefreshScrollViewBeginReflesh:self];
}

//Begin Foot Load
-(void)UtilTableViewLoadMore{
    if (!self.m_refreshFooterView || [self.m_refreshFooterView isHidden]) {
        return;
    }
    self.UtilIsLoading = YES;
    [self.UtilDelegate UtilTableViewDelegateLoadMore];
}

//required
-(void)UtilTableViewWillBeginDecelerate:(UIScrollView *)scrollView{
    self.UtilLastPoint = CGPointMake(0, 0);
}

-(void)UtilTableViewDidScroll:(UIScrollView *)scrollView{
    CGPoint curPoint = scrollView.contentOffset;
    if (curPoint.y==self.UtilLastPoint.y) {
        return;
    }
    if (curPoint.y < self.UtilLastPoint.y) {
        if (!self.m_refreshHeaderView || [self.m_refreshHeaderView isHidden]) {
            return;
        }
        [self.m_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }else {
        if (!self.m_refreshFooterView || [self.m_refreshFooterView isHidden]) {
            return;
        }
        [self.m_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

-(void)UtilTableViewDidEndDragging:(UIScrollView *)scrollView{
    CGPoint curPoint = scrollView.contentOffset;
    if (curPoint.y < self.UtilLastPoint.y) {
        if (!self.m_refreshHeaderView || [self.m_refreshHeaderView isHidden]) {
            return;
        }
        [self.m_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }else {
        if (!self.m_refreshFooterView || [self.m_refreshFooterView isHidden]) {
            return;
        }
        [self.m_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma - mark
-(void)UtilTableViewModifyMoreFrame{
    if (!self.m_refreshFooterView || [self.m_refreshFooterView isHidden]) {
        return;
    }
    self.m_refreshFooterView.frame = CGRectMake(0.0f, self.contentSize.height, self.frame.size.width, 650);
}

//head
-(void)UtilTableViewDidRefleshData{
    [self UtilTableViewModifyMoreFrame];
    self.UtilIsLoading = NO;
    if (self.m_refreshHeaderView) {
        [self.m_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
}

//foot
-(void)UtilTableViewDidLoadMoreData{
    [self UtilTableViewModifyMoreFrame];
    self.UtilIsLoading = NO;
    if (self.m_refreshFooterView) {
        [self.m_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
}

#pragma mark - EGO delegate
//head
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    if (self.UtilDelegate && [self.UtilDelegate respondsToSelector:@selector(UtilTableViewDelegateReflesh)]) {
        self.UtilIsLoading = YES;
        [self.UtilDelegate UtilTableViewDelegateReflesh];
    }
    
    //    [self performSelector:@selector(UtilTableViewDidRefleshData) withObject:nil afterDelay:1];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return self.UtilIsLoading;
}

//foot
- (void)egoRefreshTableFootDidTriggerRefresh:(EGORefreshTableFootView*)view{
    if (self.UtilDelegate && [self.UtilDelegate respondsToSelector:@selector(UtilTableViewDelegateLoadMore)]) {
        self.UtilIsLoading = YES;
        [self.UtilDelegate UtilTableViewDelegateLoadMore];
    }
    
    //    [self performSelector:@selector(UtilTableViewDidLoadMoreData) withObject:nil afterDelay:1];
}

- (BOOL)egoRefreshTableFootDataSourceIsLoading:(EGORefreshTableFootView*)view{
    return self.UtilIsLoading;
}

//Clear CellSubView
-(void)ClearCellSubView{
    for (int i=0; i<[self numberOfSections]; i++) {
        for (int j=0; j<[self numberOfRowsInSection:i]; j++) {
            UITableViewCell * cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            if (cell) {
                [cell clearAllSubView];
                [cell.contentView clearAllSubView];
            }
        }
    }
}

#pragma mark - Property
-(id<UtilTableViewDelegate>)UtilDelegate{
    return objc_getAssociatedObject(self, UTIL_TABLEDELEGATE);
}

-(void)setUtilDelegate:(id<UtilTableViewDelegate>)UtilDelegate{
    objc_setAssociatedObject(self, UTIL_TABLEDELEGATE, UtilDelegate, OBJC_ASSOCIATION_ASSIGN);
}

-(EGORefreshTableHeaderView *)m_refreshHeaderView{
    return objc_getAssociatedObject(self, UTIL_TABLEHEAD);
}

-(void)setM_refreshHeaderView:(EGORefreshTableHeaderView *)m_refreshHeaderView{
    objc_setAssociatedObject(self, UTIL_TABLEHEAD, m_refreshHeaderView, OBJC_ASSOCIATION_ASSIGN);
}

-(EGORefreshTableFootView *)m_refreshFooterView{
    return objc_getAssociatedObject(self, UTIL_TABLEFOOT);
}

-(void)setM_refreshFooterView:(EGORefreshTableFootView *)m_refreshFooterView{
    objc_setAssociatedObject(self, UTIL_TABLEFOOT, m_refreshFooterView, OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)UtilIsLoading{
    return [objc_getAssociatedObject(self, UTIL_TABLEISLOADING) boolValue];
}

-(void)setUtilIsLoading:(BOOL)UtilIsLoading{
    objc_setAssociatedObject(self, UTIL_TABLEISLOADING, [NSNumber numberWithBool:UtilIsLoading], OBJC_ASSOCIATION_ASSIGN);
}

-(CGPoint)UtilLastPoint{
    return [objc_getAssociatedObject(self, UTIL_TABLELASTPOINT) CGPointValue];
}

-(void)setUtilLastPoint:(CGPoint)UtilLastPoint{
    objc_setAssociatedObject(self, UTIL_TABLELASTPOINT, [NSValue valueWithCGPoint:UtilLastPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)dealloc{
    objc_setAssociatedObject(self, UTIL_TABLELASTPOINT, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [super dealloc];
}

@end
