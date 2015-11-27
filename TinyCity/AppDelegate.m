//
//  AppDelegate.m
//  TinyCity
//
//  Created by lanou3g on 15/11/11.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "CDAddRequest.h"
#import "CDAbuseReport.h"
#import "CDUserFactory.h"
#import "UserInfoModel.h"
#import "ZBarSDK.h"
#import "CommentModel.h"
#import "AVImageUrl.h"
#import "AppStartViewController.h"
#import "UIWindow+SwitchVC.h"
#import "LZPushManager.h"

@interface AppDelegate ()<UMSocialUIDelegate>
@property (nonatomic, strong) BMKMapManager *mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window switchRootViewController];
    [self.window makeKeyAndVisible];
    
    

    [UMSocialData setAppKey:APPKey];
    //    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
    //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1104890839" appKey:@"WZ31hlKOFGFw1zTU" url:@"http://www.umeng.com/social"];
    [UMSocialWechatHandler setWXAppId:@"wx46f68b330a5c5036" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.umeng.com/social"];
    
    //启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"MCOCc4PdGQhKjkQoI2KF31wo" generalDelegate:nil];
    if (!ret) {
        NSLog(@"地图初始化失败");
    }
    [UserInfoModel registerSubclass];
    [CDAddRequest registerSubclass];
    [CDAbuseReport registerSubclass];
    [CommentModel registerSubclass];
    // 设置leanCloudAPPKEY
    [AVOSCloud setApplicationId:ID clientKey:KEY];
    [AVOSCloud setLastModifyEnabled:YES];
    
    [[LZPushManager manager] registerForRemoteNotification];
    
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
//    [CDChatManager manager].userDelegate = [[CDUserFactory alloc] init];
    
  
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  
    [[LZPushManager manager] syncBadge];
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}

//检测baiduMap网络
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}
//检测baiduMap授权
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[LZPushManager manager] saveInstallationWithDeviceToken:deviceToken userId:[AVUser currentUser].objectId];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive) {
        // 应用在前台时收到推送，只能来自于普通的推送，而非离线消息推送
    }
    else {
        //  当使用 https://github.com/leancloud/leanchat-cloudcode 云代码更改推送内容的时候
        //        {
        //            aps =     {
        //                alert = "lzwios : sdfsdf";
        //                badge = 4;
        //                sound = default;
        //            };
        //            convid = 55bae86300b0efdcbe3e742e;
        //        }
        [[CDChatManager manager] didReceiveRemoteNotification:userInfo];
        [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    DLog(@"receiveRemoteNotification");
}

@end
