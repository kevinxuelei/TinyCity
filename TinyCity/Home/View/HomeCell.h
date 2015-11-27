//
//  HomeCell.h
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@class CellFrame;


@protocol UICollectionViewCellSaveDelegate<NSObject>

-(void)UICollectionViewCellSaveDelegate:(HomeModel *)saveModel withSaveButton:(UIButton *)button;

@end

@interface HomeCell : UICollectionViewCell


@property (nonatomic, strong) CellFrame * cellF;

@property (nonatomic, strong) UIButton * saveButton;
@property (nonatomic, strong) UIButton * transmitButton;// 转发
@property (nonatomic, strong) UIButton * reportButton;// 举报

@property (nonatomic, assign) id delegate;

@end
