//
//  City.m
//  ProvincesAndCity
//
//  Created by lanou3g on 15/9/18.
//  Copyright (c) 2015年 xhf06. All rights reserved.
//

#import "City.h"
#import "Region.h"

@implementation City

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.name = [[dict allKeys] lastObject];
        NSArray *regionArr = [[dict allValues] lastObject];
        NSMutableArray *regionArray = [NSMutableArray array];
        for (NSString *str in regionArr) {

            Region *region = [Region regionWithString:str];
            
            [regionArray addObject:region];
        }
        self.regionArr = regionArray;
    }
    return self;
}
+(instancetype)cityWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}



@end
