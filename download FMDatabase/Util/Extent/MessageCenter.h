//
//  MessageCenter.h
//  FpiFramework
//
//  Created by hj on 13-8-13.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"

/**
	消息提示中心，用于显示等待视图、快速弹出提示消息
 */
@interface MessageCenter : NSObject<MFMessageComposeViewControllerDelegate>{
    MBProgressHUD * m_waitAnim;
}

+(MessageCenter *)shared;

-(void)showWaitView:(NSString*)msg;

-(void)showWaitView:(NSString*)msg Enable:(BOOL)enable;

-(void)hideWaitView;


/**
	发送短信
	@param phone 电话号码
	@param title 短信标题
	@param content 短信内容
 */
-(void)sendSMS:(NSString *)phone title:(NSString *)title content:(NSString *)content;


/**
	显示消息提示框，用户可以选择确定或者取消按钮
	@param msg 消息内容
	@param delegate 委托
	@param tag 标识
 */
+(void)showAlertOptionMsg:(NSString *)msg Delegate:(id)delegate Tag:(int)tag;


+(void)showAlertMsg:(NSString *)msg;

+(void)showInfoMsg:(NSString *)msg;

+(void)showInfoMsg:(NSString *)msg PointY:(float)pointY IsDim:(BOOL)isDim;

@end
