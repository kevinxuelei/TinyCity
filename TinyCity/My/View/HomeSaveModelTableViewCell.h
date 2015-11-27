//
//  HomeSaveModelTableViewCell.h
//  TinyCity
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface HomeSaveModelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) HomeModel *model;

+(instancetype)HomeSaveModelTableViewCellWithTableView:(UITableView *)tableView;

@end
