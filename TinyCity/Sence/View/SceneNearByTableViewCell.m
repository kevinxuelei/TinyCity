//
//  SceneNearByTableViewCell.m
//  TinyCity
//
//  Created by lanou3g on 15/11/24.
//  Copyright © 2015年 DH. All rights reserved.
//

#define KViewImageUrl @"http://api.map.baidu.com/panorama?width=512&height=256&location="
#import "SceneNearByTableViewCell.h"
@interface SceneNearByTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addressImage;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@end

@implementation SceneNearByTableViewCell

+(instancetype)SceneNearByTableViewCellWith:(UITableView *)tableView{
    
    static NSString *IDs = @"nearByCell";
    SceneNearByTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDs];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SceneNearByTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    return cell;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    [self.addressLabel sizeToFit];
}
-(void)setModel:(BMKPoiInfo *)model{
    
    _model = model;
    self.nameLabel.text = model.name;
    self.addressLabel.text = model.address;
    self.phoneLabel.text = model.phone;
    
    // 街景地图
    NSString *viewUrl = [NSString stringWithFormat:@"%f,%f&fov=180&ak=KorQ39GXFfuwkwjIyMf0dMxF",model.pt.longitude,model.pt.latitude];
    NSString *imageUrl = [KViewImageUrl stringByAppendingString:viewUrl];
    
    [self.addressImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"compose_camerabutton_background_highlighted"]];
}
@end
