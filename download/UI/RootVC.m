//
//  RootVC.m
//  download
//
//  Created by Haijiao on 14-3-10.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "RootVC.h"
#import "DownloadCell.h"
#import "ImageVC.h"

@interface RootVC ()

@end

@implementation RootVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
-(IBAction)onAddClick:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"网络URL" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 5;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    [alert release];
}

-(IBAction)onDeleteClick:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"是否删除所有任务和文件？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 10;
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==5) {
        if (buttonIndex==1) {
            NSString * url = [alertView textFieldAtIndex:0].text;
            if ([@"ttpod" isEqualToString:url]) {
                NSString * file = [[NSBundle mainBundle] pathForResource:@"urlfile" ofType:@"plist"];
                NSArray * arr = [NSArray arrayWithContentsOfFile:file];
                for (url in [arr objectEnumerator]) {
                    [[DownManage shared] addDonwloadWithUrl:url];
//                    if ([m_arr_item count]>4) {
//                        break;
//                    }
                }
                return;
            }
            if (![url hasPrefix:@"http://"] || url.length<10) {
                [MessageCenter showAlertMsg:@"请输入正确的网络URL"];
                return;
            }else{
                [[DownManage shared] addDonwloadWithUrl:url];
            }
        }
    }else{
        if (buttonIndex==1) {
            for (BE_Download * download in [m_arr_item objectEnumerator]) {
                NSString * url = download.Url;
                [[DownManage shared] removeDownloadWithUrl:url DeleteFile:YES];
            }
            [[NSFileManager defaultManager] removeItemAtPath:[Resource getResourcesPath] error:nil];
            [m_arr_item removeAllObjects];
            [m_dic_cach removeAllObjects];
            [m_table reloadData];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"我的下载";
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddClick:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    [leftItem release];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(onDeleteClick:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [rightItem release];
    
    [m_table setTableFooterView:[[[UIView alloc] initWithFrame:CGRectZero] autorelease]];
    m_arr_item = [[NSMutableArray alloc] initWithArray:[DownManage shared].ArrItem];
    m_dic_cach = [[NSCache alloc] init];
    
    [DownManage shared].Delegate = self;
}

-(void)DownloadDataAddDownload:(BE_Download *)download
{
    if (!download) {
        return;
    }
    [m_arr_item addObject:download];
    [m_table reloadData];
}

-(IBAction)onRunBtnClick:(UIButton *)sender
{
    UIView * view = sender.superview;
    while (![view isKindOfClass:[DownloadCell class]]) {
        view = view.superview;
    }
    DownloadCell * cell = (DownloadCell *)view;
    NSIndexPath * indexPath = [m_table indexPathForCell:cell];
    if (indexPath) {
        BE_Download * download = [m_arr_item objectAtIndex:indexPath.row];
        switch (download.DownloadType) {
            case DownLoad_Wait:[download runThread:Download_Stop];break;
            case Download_Run:[download runThread:Download_Stop];break;
            case Download_Stop:[download runThread:Download_Run];break;
            case Download_Complete:break;
            case Download_Fail:[download runThread:Download_Run];break;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex>2) {
        return;
    }
    int index = actionSheet.tag;
    BE_Download * download = nil;
    if (index<[m_arr_item count])
        download = [m_arr_item objectAtIndex:index];
    if (!download) {
        return;
    }
    NSString * url = download.Url;
    switch (buttonIndex) {
        case 0:  //查看文件
            if ([url hasSuffix:@".jpg"] || [url hasSuffix:@".png"]) {
                ImageVC * vc = [[ImageVC alloc] init];
                vc.ImgPath = [Resource getResourcePathWithName:url];
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            }
            break;
        default: //删除任务
            [[DownManage shared] removeDownloadWithUrl:url DeleteFile:buttonIndex==1];
            
            [m_dic_cach removeObjectForKey:url];
            [m_arr_item removeObjectAtIndex:index];
            [m_table deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看",@"删除任务文件",@"删除任务保留文件", nil];
    sheet.tag = indexPath.row;
    [sheet showInView:self.view];
    [sheet release];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arr_item count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BE_Download * download = [m_arr_item objectAtIndex:indexPath.row];
    NSString * key = download.Url;
    DownloadCell * cell = [m_dic_cach objectForKey:key];
    if (!cell) {
        cell = [[[DownloadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        [cell.BtnRun addTarget:self action:@selector(onRunBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [m_dic_cach setObject:cell forKey:key];
    }
    
    cell.Title.text = download.Url;
    [cell DownloadDelegateStatueChange:download.DownloadType];
    
    [download setDelegate:cell];
    
    return cell;
}

- (void)dealloc
{
    [m_table release];
    [m_arr_item release];
    [m_dic_cach release];
    [super dealloc];
}

@end
