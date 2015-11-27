//
//  AroundPersonTableViewCell.m
//  TinyCity
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "AroundPersonTableViewCell.h"

@interface AroundPersonTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addPersonBtn;

- (IBAction)concernAction:(UIButton *)sender;

@end

@implementation AroundPersonTableViewCell

+(instancetype)AroundPersonTableViewCellWithTableView:(UITableView *)tableView{
    
    static NSString *IDAround = @"aroundCell";
    AroundPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDAround];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AroundPersonTableViewCell" owner:nil options:nil] lastObject];
        
    }
    return cell;

    
}

-(void)setModel:(BMKRadarNearbyInfo *)model{
    
    _model = model;
    
    self.titleLabel.text = model.userId;
    self.distanceLabel.text = [[NSString stringWithFormat:@"%lu",(unsigned long)model.distance] stringByAppendingString:@"km"];
    int value = (arc4random() % 5) + 1;
    self.headerImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"header%d",value]];
    
    PLLog(@"%f%f",model.pt.latitude,model.pt.longitude);
    
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.headerImage.layer.cornerRadius = 25;
    self.headerImage.layer.masksToBounds = YES;
    
}

#warning message ------ 加关注 数据的实现
- (IBAction)concernAction:(UIButton *)sender {
    if (!sender.selected) {
         [sender setImage:[UIImage imageNamed:@"iconfont-yiguanzhu"] forState:UIControlStateNormal];
        sender.selected = !sender.selected;
    }else{
         [sender setImage:[UIImage imageNamed:@"iconfont-jiaguanzhu"] forState:UIControlStateNormal];
         sender.selected = !sender.selected;
    }
}
@end
