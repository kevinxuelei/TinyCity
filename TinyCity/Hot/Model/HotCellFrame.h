//
//  HotCellFrame.h
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@interface HotCellFrame : NSObject

/**
 *  用户头像
 */
@property (nonatomic, assign) CGRect profile_imageFrame; //61330451

/**
 *  用户名
 */
@property (nonatomic, assign) CGRect nameFrame; //user_name

/**
 *  发表时间frame
 */
@property (nonatomic, assign) CGRect created_atFrame;//create_time + bbs_kind

/**
 *  内容
 */
@property (nonatomic, assign) CGRect contentFrame; //subject

/**
 *  浏览数
 */
@property (nonatomic, assign) CGRect locationFrame;//read_num

/**
 *  赞
 */
@property (nonatomic, assign) CGRect applauseFrame; //praise_num

/**
 *  图片
 */
@property (nonatomic, assign) CGRect pictureFrame;//img_list

/**
 *  回复
 */
@property (nonatomic, assign) CGRect replayFrame; //reply_num

/**
 *  cell高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

/**
 *  模型数据
 */
@property (nonatomic, strong) UserInfoModel *model;


@end
