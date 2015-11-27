//
//  UserRouteLines.m
//  TinyCity
//
//  Created by lanou3g on 15/11/23.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "UserRouteLines.h"
static UserRouteLines *instance = nil;
@implementation UserRouteLines

+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[UserRouteLines alloc] init];
            
        }
    });
    return instance;
}

//返回含有不同公交路线的数组，数组中是公交路线的指示信息
-(NSArray *)ByBusWithBusLine:(BMKTransitRouteResult *)transitRouteResult{
    
    NSMutableArray *allCountArrays = [NSMutableArray array];
    
    NSArray *arrayRouteBusLines = transitRouteResult.routes;
    for (BMKTransitRouteLine *routeline in arrayRouteBusLines) {
        
        NSString *startStr = [NSString stringWithFormat:@"该条线路起点是:%@",routeline.starting.title];
        NSString *endStr = [NSString stringWithFormat:@"终点是:%@",routeline.terminal.title];
        NSString *distanceStr = [NSString stringWithFormat:@"总路程%d米",routeline.distance];
        
        //时间转换
        BMKTime *time = routeline.duration;
        NSString *timeStr = [NSString stringWithFormat:@"预计需要时间%d小时%d分%d秒",time.hours,time.minutes,time.seconds];
        NSString *stepsStr = [NSString stringWithFormat:@"大致可分为%d步:",routeline.steps.count];
        
        NSMutableArray *contentStr = [NSMutableArray arrayWithObjects:startStr,endStr,distanceStr,timeStr,stepsStr, nil];
        
        for (BMKTransitStep *step in routeline.steps) {
            NSString *instructionStr = [NSString stringWithFormat:@"%@",step.instruction];
            [contentStr addObject:instructionStr];
        }
        
        [allCountArrays addObject:contentStr];
    }
    
    return allCountArrays;
}
//返回含有不同自驾路线的数组，数组中是自驾路线的指示信息
-(NSArray *)ByDrivingRouteLine:(BMKDrivingRouteResult *)drivingRouteResult{
    
    
    NSMutableArray *allCountArrays = [NSMutableArray array];
    
    NSArray *arrayRouteDrivingLines = drivingRouteResult.routes;
    for (BMKDrivingRouteLine *routeline in arrayRouteDrivingLines) {
        
        NSString *startStr = [NSString stringWithFormat:@"该条线路起点是:%@",routeline.starting.title];
        NSString *endStr = [NSString stringWithFormat:@"终点是:%@",routeline.terminal.title];
        NSString *distanceStr = [NSString stringWithFormat:@"总路程%d米",routeline.distance];
        
        //时间转换
        BMKTime *time = routeline.duration;
        NSString *timeStr = [NSString stringWithFormat:@"预计需要时间%d小时%d分%d秒",time.hours,time.minutes,time.seconds];
        NSString *stepsStr = [NSString stringWithFormat:@"大致可分为%d步:",routeline.steps.count];
        
        NSMutableArray *contentStr = [NSMutableArray arrayWithObjects:startStr,endStr,distanceStr,timeStr,stepsStr, nil];
        
        for (BMKDrivingStep *step in routeline.steps) {
            NSString *instructionStr = [NSString stringWithFormat:@"%@",step.instruction];
            [contentStr addObject:instructionStr];
        }
        
        [allCountArrays addObject:contentStr];
    }
    
    return allCountArrays;
    
}
//返回含有不同步行路线的数组，数组中是步行的指示信息
-(NSArray *)ByWalkingRouteLine:(BMKWalkingRouteResult *)walkingRouteResult{
    
    NSMutableArray *allCountArrays = [NSMutableArray array];
    
    NSArray *arrayRouteWalkingLines = walkingRouteResult.routes;
    for (BMKWalkingRouteLine *routeline in arrayRouteWalkingLines) {
        
        NSString *startStr = [NSString stringWithFormat:@"该条线路起点是:%@",routeline.starting.title];
        NSString *endStr = [NSString stringWithFormat:@"终点是:%@",routeline.terminal.title];
        NSString *distanceStr = [NSString stringWithFormat:@"总路程%d米",routeline.distance];
        
        //时间转换
        BMKTime *time = routeline.duration;
        NSString *timeStr = [NSString stringWithFormat:@"预计需要时间%d小时%d分%d秒",time.hours,time.minutes,time.seconds];
        NSString *stepsStr = [NSString stringWithFormat:@"大致可分为%d步:",routeline.steps.count];
        
        NSMutableArray *contentStr = [NSMutableArray arrayWithObjects:startStr,endStr,distanceStr,timeStr,stepsStr, nil];
        
        for (BMKWalkingStep *step in routeline.steps) {
            NSString *instructionStr = [NSString stringWithFormat:@"%@",step.instruction];
            [contentStr addObject:instructionStr];
        }
        
        [allCountArrays addObject:contentStr];
    }
    
    return allCountArrays;

    
}

@end
