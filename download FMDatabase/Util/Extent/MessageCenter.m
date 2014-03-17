//
//  MessageCenter.m
//  FpiFramework
//
//  Created by hj on 13-8-13.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import "MessageCenter.h"

static MessageCenter * _MessageCenter;

@implementation MessageCenter

+(MessageCenter *)shared{
    if (!_MessageCenter) {
		@synchronized(self) {
			if (!_MessageCenter) {
				_MessageCenter=[[MessageCenter alloc] init];
			}
		}
	}
    return _MessageCenter;
}

-(void)showWaitView:(NSString*)msg{
    [self showWaitView:msg Enable:NO];
}

-(void)showWaitView:(NSString*)msg Enable:(BOOL)enable{
    if (!m_waitAnim) {
        UIView * vc = [UIApplication sharedApplication].keyWindow;
        m_waitAnim = [[MBProgressHUD alloc] initWithView:vc];
        [vc addSubview:m_waitAnim];
    }
    m_waitAnim.labelText = msg;
    m_waitAnim.hidden = NO;
    [m_waitAnim show:YES];
    m_waitAnim.userInteractionEnabled = !enable;
}

-(void)hideWaitView{
    m_waitAnim.hidden = YES;
}

//短信
-(void)sendSMS:(NSString *)phone title:(NSString *)title content:(NSString *)content{
    //    if([MFMessageComposeViewController canSendText]){
    //        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
    //        controller.recipients = [NSArray arrayWithObject:phone];
    //        controller.body = content;
    //        controller.messageComposeDelegate = self;
    //        [[VCManage shared].getCurView presentModalViewController:controller animated:YES];
    //        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    //    }else{
    //        [Util_Message showAlertMsg:@"该设备不支持短信功能"];
    //    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    //    [[VCManage shared].getCurView dismissModalViewControllerAnimated:YES];
}

#pragma mark -
+(void)showAlertOptionMsg:(NSString *)msg Delegate:(id)delegate Tag:(int)tag{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:delegate cancelButtonTitle:nil otherButtonTitles:@"取消", @"确定", nil];
    alert.tag = tag;
    [alert show];
    [alert release];
}

+(void)showAlertMsg:(NSString *)msg{
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+(void)showInfoMsg:(NSString *)msg{
    [MessageCenter showInfoMsg:msg PointY:150 IsDim:NO];
}

+(void)showInfoMsg:(NSString *)msg PointY:(float)pointY IsDim:(BOOL)isDim{
    UIView * view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.dimBackground = isDim;
	hud.mode = MBProgressHUDModeText;
	hud.labelText = msg;
	hud.margin = 10;
	hud.yOffset = pointY;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1];
}

@end
