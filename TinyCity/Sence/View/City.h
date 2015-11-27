//
//  City.h
//  ProvincesAndCity
//
//  Created by lanou3g on 15/9/18.
//  Copyright (c) 2015年 xhf06. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *regionArr;


-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)cityWithDict:(NSDictionary *)dict;

@end
