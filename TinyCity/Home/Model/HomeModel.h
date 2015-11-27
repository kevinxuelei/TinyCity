//
//  HomeModel.h
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject<NSCoding>

@property (nonatomic,copy) NSString * text; // 标题
@property (nonatomic,copy) NSString * profile_image;// 用户头像
@property (nonatomic,copy) NSString * created_at; // 发表时间
@property (nonatomic,copy) NSString * videouri; //视频url
@property (nonatomic,copy) NSString * name;// 用户名
@property (nonatomic,copy) NSString * width; // 图片宽
@property (nonatomic,copy) NSString * height; // 图片高
@property (nonatomic,copy) NSString * user_id;
@property (nonatomic,copy) NSString * image1;
@end
