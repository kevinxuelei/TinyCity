//
//  AreasHeaderView.h
//  TinyCity
//
//  Created by lanou3g on 15/11/14.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Provinces.h"
@class AreasHeaderView;

@protocol AreasHeaderViewDelegate <NSObject>

-(void)reloadData:(AreasHeaderView *)headerView;

@end

@interface AreasHeaderView : UITableViewHeaderFooterView

+(instancetype)AreasHeaderViewWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) Provinces *province;
@property (nonatomic, assign) id delegate;

@end
