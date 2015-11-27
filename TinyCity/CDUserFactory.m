//
//  CDUserFactory.m
//  LeanChatExample
//
//  Created by lzw on 15/4/7.
//  Copyright (c) 2015年 avoscloud. All rights reserved.
//

#import "CDUserFactory.h"
#import "CDUser.h"

@implementation CDUserFactory

#pragma mark - CDUserDelegate

// cache users that will be use in getUserById
- (void)cacheUserByIds:(NSSet *)userIds block:(AVBooleanResultBlock)block {
    block(YES, nil); // don't forget it
}

- (id <CDUserModel> )getUserById:(NSString *)userId {
    CDUser *user = [[CDUser alloc] init];
    user.userId = userId;
    user.username = userId;
    user.avatarUrl = @"http://ac-x3o016bx.clouddn.com/86O7RAPx2BtTW5zgZTPGNwH9RZD5vNDtPm1YbIcu";
//    http://img0.imgtn.bdimg.com/it/u=2596087373,2714370257&fm=21&gp=0.jpg
//    user.avatarUrl = @"http://img0.imgtn.bdimg.com/it/u=2596087373,2714370257&fm=21&gp=0.jpg";
    return user;
}

@end
