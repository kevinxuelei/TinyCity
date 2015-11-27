//
//  UserInfoModel.h
//  TinyCity
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "AVObject.h"
#import <AVFile.h>
#import "CommentModel.h"

@interface UserInfoModel : AVObject<AVSubclassing>

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userIcon;
@property (nonatomic, strong) NSString *textInfo;
@property (nonatomic, strong) AVFile *file;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *img_list;
@property (nonatomic, copy) NSString *praise_num;
@property (nonatomic, copy) NSString *relay_num;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, strong) CommentModel *model;
@property (nonatomic, assign) BOOL isDing;
@end
