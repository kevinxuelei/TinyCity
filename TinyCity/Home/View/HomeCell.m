//
//  HomeCell.m
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "HomeCell.h"
#import "CellFrame.h"
#import "HomeModel.h"
#import "UIView+Extension.h"
#import <UIImageView+WebCache.h>


@interface HomeCell ()
@property (nonatomic, strong) UIImageView * profile_image_view;
@property (nonatomic, strong)  UILabel* name_label;
@property (nonatomic, strong)  UILabel* created_at_label;
@property (nonatomic, strong) UIImageView * bigImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *coverView;
@end

@implementation HomeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化
        self.profile_image_view = [[UIImageView alloc] init];
        [self.contentView addSubview:_profile_image_view];
        
        self.bigImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_bigImageView];
        
        self.saveButton = [[UIButton alloc] init];
        [self.contentView addSubview:_saveButton];
        
        self.transmitButton = [[UIButton alloc] init];
        [self.contentView addSubview:_transmitButton];
        
        self.reportButton = [[UIButton alloc] init];
        [self.contentView addSubview:_reportButton];
        
        self.name_label = [[UILabel alloc] init];
        _name_label.numberOfLines = 0;
        [_name_label sizeToFit];
        _name_label.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_name_label];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [_titleLabel sizeToFit];
        [self.contentView addSubview:_titleLabel];
        
        self.created_at_label = [[UILabel alloc] init];
        _created_at_label.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_created_at_label];
        
        self.coverView = [[UIView alloc] init];
        [self.contentView insertSubview:_coverView atIndex:0];
        
    }
    return self;
}

- (void)setCellF:(CellFrame *)cellF
{
    _cellF = cellF;
    
    // 1.加载数据
    [self loadData];
    // 2.加载frame
    [self loadFrame];
    
}
/**
 加载data
 */
- (void)loadData
{
    HomeModel *model = self.cellF.model;
    [self.profile_image_view sd_setImageWithURL:[NSURL URLWithString:model.profile_image] placeholderImage:[UIImage imageNamed:@"info@3x"]];
    self.name_label.text = model.name;
    self.created_at_label.text = [model.created_at substringToIndex:10];;
    self.titleLabel.text = model.text;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.image1] placeholderImage:[UIImage imageNamed:@"placeholder-2"]];
   
    
    [self.saveButton setTitle:@"收藏" forState:(UIControlStateNormal)];
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.saveButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [self.transmitButton setTitle:@"分享" forState:(UIControlStateNormal)];
    _transmitButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.transmitButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    
    [self.self.reportButton setTitle:@"举报" forState:(UIControlStateNormal)];
    self.reportButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.reportButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];


}
/**
 加载frame
 */
- (void)loadFrame
{
    self.profile_image_view.frame = self.cellF.profile_imageFrame;
    _profile_image_view.layer.cornerRadius = _profile_image_view.width/2;
    _profile_image_view.layer.masksToBounds = YES;
    self.name_label.frame = self.cellF.name_labelFrame;
    _name_label.numberOfLines = 0;
    [_name_label sizeToFit];
    self.created_at_label.frame = self.cellF.created_at_labelFrame;
    self.titleLabel.frame = self.cellF.titleLabelFrame;
    self.bigImageView.frame = self.cellF.bigImageViewFrame;
    self.saveButton.frame = self.cellF.saveButtonFrame;
    [_saveButton addTarget:self action:@selector(saveVedio:) forControlEvents:(UIControlEventTouchUpInside)];
    self.transmitButton.frame = self.cellF.transmitButtonFrame;
    
    self.reportButton.frame = self.cellF.reportButtonFrame;
}
#pragma mark _saveButton点击收藏方法
- (void)saveVedio:(UIButton *)sender
{

        if (self.delegate && [self.delegate respondsToSelector:@selector(UICollectionViewCellSaveDelegate:withSaveButton:)]) {
            [self.delegate UICollectionViewCellSaveDelegate:self.cellF.model withSaveButton:sender];
        }
   
    
   
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.coverView.x = 0;
    self.coverView.y = 0;
    self.coverView.frame = self.bounds;
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.1;
    _coverView.layer.cornerRadius = 10;
}
@end
