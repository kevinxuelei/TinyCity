//
//  CDConvsVC.m
//  LeanChat
//
//  Created by lzw on 15/4/10.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDConvsVC.h"
#import "CDUtils.h"
#import "CDIMService.h"
#import "CDFriendListVC.h"

@interface CDConvsVC () <CDChatListVCDelegate>

@end

@implementation CDConvsVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"消息";
//        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_chat_active"];
        self.chatListDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"联系人" style:(UIBarButtonItemStylePlain) target:self action:@selector(toAddress)];
}

- (void)toAddress
{
    CDFriendListVC *cdF = [[CDFriendListVC alloc] init];
    [self.navigationController pushViewController:cdF animated:YES];
}

- (void)viewController:(UIViewController *)viewController didSelectConv:(AVIMConversation *)conv {
    [[CDIMService service] goWithConv:conv fromNav:viewController.navigationController];
}

- (void)setBadgeWithTotalUnreadCount:(NSInteger)totalUnreadCount {
    if (totalUnreadCount > 0) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)totalUnreadCount];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalUnreadCount];
    }
    else {
        self.tabBarItem.badgeValue = nil;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

@end
