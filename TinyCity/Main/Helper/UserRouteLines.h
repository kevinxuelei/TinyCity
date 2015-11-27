//
//  UserRouteLines.h
//  TinyCity
//
//  Created by lanou3g on 15/11/23.
//  Copyright © 2015年 DH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRouteLines : NSObject

+(instancetype)shareInstance;

//返回含有不同公交路线的数组，数组中是公交路线的指示信息
-(NSArray *)ByBusWithBusLine:(BMKTransitRouteResult *)transitRouteResult;

//返回含有不同自驾路线的数组，数组中是自驾路线的指示信息
-(NSArray *)ByDrivingRouteLine:(BMKDrivingRouteResult *)drivingRouteResult;

//返回含有不同步行路线的数组，数组中是步行的指示信息
-(NSArray *)ByWalkingRouteLine:(BMKWalkingRouteResult *)walkingRouteResult;

@end
