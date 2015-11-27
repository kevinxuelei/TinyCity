//
//  HomeSaveModelTableViewCell.m
//  TinyCity
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "HomeSaveModelTableViewCell.h"
#import <UIImageView+WebCache.h>



@implementation HomeSaveModelTableViewCell


+(instancetype)HomeSaveModelTableViewCellWithTableView:(UITableView *)tableView{
    
    static NSString *IDHome = @"homeSaveCell";
    HomeSaveModelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDHome];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeSaveModelTableViewCell" owner:nil options:nil] lastObject];
        
    }
    return cell;
}

-(void)layoutSubviews{
    
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel sizeToFit];
    
}

-(void)setModel:(HomeModel *)model{
    
    _model = model;
    
    self.headerImage.layer.cornerRadius =25;
    self.headerImage.layer.masksToBounds = YES;
    self.titleLabel.text = model.name;
    self.contentLabel.text = model.text;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.image1]];
    
    
}

@end
