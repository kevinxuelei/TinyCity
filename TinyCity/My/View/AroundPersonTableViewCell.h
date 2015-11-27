//
//  AroundPersonTableViewCell.h
//  TinyCity
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>

@interface AroundPersonTableViewCell : UITableViewCell

@property (nonatomic, strong) BMKRadarNearbyInfo *model;
+(instancetype)AroundPersonTableViewCellWithTableView:(UITableView *)tableView;

@end
