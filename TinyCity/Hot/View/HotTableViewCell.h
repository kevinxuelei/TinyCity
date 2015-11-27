//
//  HotTableViewCell.h
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotCellFrame.h"
#import "UserInfoModel.h"

@interface HotTableViewCell : UITableViewCell
@property (nonatomic, strong) HotCellFrame * cellFrame;
@property (nonatomic, strong) UILabel * locationLabel;
@property (nonatomic, strong) UIButton * transmitButton;// 转发
@property (nonatomic, strong) UIButton * reportButton;// 举报
@property (nonatomic, strong) UIImageView * profile_image_view;
@property (nonatomic, strong)  UILabel* name_label;
@property (nonatomic, strong)  UILabel* created_at_label;
@property (nonatomic, strong) UIImageView * bigImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *coverView;
@end
