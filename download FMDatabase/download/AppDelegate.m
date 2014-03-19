//
//  AppDelegate.m
//  download
//
//  Created by Haijiao on 14-3-10.
//  Copyright (c) 2014年 Haijiao. All rights reserved.
//

#import "AppDelegate.h"
#import "DB_Download.h"
#import "DownManage.h"
#import "RootVC.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DB_Download createTableDownload];
    [[DownManage shared] updateData];
    
    m_backIdentifier = UIBackgroundTaskInvalid;
    
    RootVC * rootVC = [[RootVC alloc] init];
    UINavigationController * vc = [[[UINavigationController alloc] initWithRootViewController:rootVC] autorelease];
    [rootVC release];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[DownManage shared] storeStatue];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	m_backIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"background");
        [[DownManage shared] storeStatue];
        [application endBackgroundTask:m_backIdentifier];
        m_backIdentifier = UIBackgroundTaskInvalid;
    }];
#endif
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
