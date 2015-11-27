//
//  UserInfoModel.m
//  TinyCity
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

@dynamic userName,userIcon,textInfo,file,create_time,img_list,praise_num,relay_num,location,model,isDing;

+ (NSString *)parseClassName
{
    return @"UserInfoModel";
}

@end
