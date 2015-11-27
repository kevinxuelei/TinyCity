//
//  Provinces.m
//  ProvincesAndCity
//
//  Created by lanou3g on 15/9/18.
//  Copyright (c) 2015年 xhf06. All rights reserved.
//

#import "Provinces.h"
#import "City.h"

@implementation Provinces

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.name = [[dict allKeys] lastObject];
        
        NSDictionary *cityDict = [[dict allValues] lastObject];
        NSMutableArray *cityArray = [NSMutableArray array];
        for (NSDictionary *dict in [cityDict allValues]) {
            
            City *city = [City cityWithDict:dict];
            
            [cityArray addObject:city];
        }
        self.cityArr = cityArray;
    }
    return self;
}
+(instancetype)provincesWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}


@end
