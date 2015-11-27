//
//  HotTableViewCell.m
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "HotTableViewCell.h"
#import <UIImageView+WebCache.h>


@implementation HotTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化
        self.profile_image_view = [[UIImageView alloc] init];
        [self.contentView addSubview:_profile_image_view];
        
        self.bigImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_bigImageView];
        
        self.locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_locationLabel];
        
        self.transmitButton = [[UIButton alloc] init];
        [_transmitButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [self.contentView addSubview:_transmitButton];
        
        self.reportButton = [[UIButton alloc] init];
        [_reportButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
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

- (void)setCellFrame:(HotCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    [self loadData:cellFrame];
    [self loadFrame:cellFrame];
}

-(void)loadData:(HotCellFrame *)cellFrame{
//    xmas-longshadow-10
//    NSString * num = [self praise_num:cellFrame];
    
    NSString *imageN = [NSString stringWithFormat:@"xmas-longshadow-%d",arc4random_uniform(11) + 1];
    [self.profile_image_view setImage:[UIImage imageNamed:imageN]];
    self.name_label.text = cellFrame.model.userName;
    self.created_at_label.text =  cellFrame.model.create_time;
    if (cellFrame.model.file.url.length != 0) {
        [_bigImageView sd_setImageWithURL:[NSURL URLWithString:cellFrame.model.file.url] placeholderImage:[UIImage imageNamed:@"funicon_poidetail_fav_un"]];
    }
    _bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.locationLabel.text = cellFrame.model.location;
     self.titleLabel.text = cellFrame.model.textInfo;
    [self.transmitButton setTitle:cellFrame.model.praise_num forState:UIControlStateNormal];
    [self.transmitButton setImage:[UIImage imageNamed:@"contributeDing"] forState:(UIControlStateNormal)];
    [self.reportButton setTitle:cellFrame.model.relay_num forState:UIControlStateNormal];
    [_reportButton setImage:[UIImage imageNamed:@"mainCellCommentN"] forState:(UIControlStateNormal)];
}

- (NSString  *)praise_num:(HotCellFrame *)cellf
{
    AVQuery *query = [CommentModel query];
    AVObject *model = [query getObjectWithId:cellf.model.model.objectId];
    NSMutableArray *array = [model objectForKey:@"thumbsUp"];
    NSString *str = [NSString stringWithFormat:@"%ld",array.count];
    return str;
}

-(void)loadFrame:(HotCellFrame *)cellFrame{
    
    self.profile_image_view.frame = cellFrame.profile_imageFrame;
    self.name_label.frame = cellFrame.nameFrame;
    self.created_at_label.frame = cellFrame.created_atFrame;
    self.titleLabel.frame = cellFrame.contentFrame;
    self.bigImageView.frame = cellFrame.pictureFrame;
    self.locationLabel.frame = cellFrame.locationFrame;
    self.transmitButton.frame = cellFrame.applauseFrame;
    self.reportButton.frame = cellFrame.replayFrame;
}

@end
