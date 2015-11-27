//
//  MyCell.m
//  TinyCity
//
//  Created by lanou3g on 15/11/13.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "MyCell.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation MyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImage];
        
        self.title_Label = [[UILabel alloc] init];
        [self.contentView addSubview:_title_Label];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.iconImage.frame = CGRectMake(5, 5, self.height - 10, self.height - 10);
    self.title_Label.frame = CGRectMake(self.height + 10, 5, ScreenWidth - self.height -20, self.height - 10);
}

@end
