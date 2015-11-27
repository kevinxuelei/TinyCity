//
//  CheckSceneViewController.h
//  TinyCity
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckSceneViewController : UIViewController

//根据传入的坐标显示全景图
@property (nonatomic, assign)CLLocationCoordinate2D locationCoordinate;
//根据传入的城市搜索，在mapview中搜索数据
@property (nonatomic, strong) BMKCitySearchOption *citySearchOption;


@end
