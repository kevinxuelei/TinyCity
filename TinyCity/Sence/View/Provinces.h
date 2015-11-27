//
//  Provinces.h
//  ProvincesAndCity
//
//  Created by lanou3g on 15/9/18.
//  Copyright (c) 2015年 xhf06. All rights reserved.
//

#import <Foundation/Foundation.h>
@class City;

@interface Provinces : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *cityArr;

/**
 *  标识这组是否需要展开,  YES : 展开 ,  NO : 关闭
 */
@property (nonatomic, assign, getter = isOpened) BOOL opened;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)provincesWithDict:(NSDictionary *)dict;
@end
