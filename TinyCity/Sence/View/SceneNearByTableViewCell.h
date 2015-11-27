//
//  SceneNearByTableViewCell.h
//  TinyCity
//
//  Created by lanou3g on 15/11/24.
//  Copyright © 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneNearByTableViewCell : UITableViewCell

@property (nonatomic, strong) BMKPoiInfo *model;

+(instancetype)SceneNearByTableViewCellWith:(UITableView *)tableView;
@end
