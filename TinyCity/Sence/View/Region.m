//
//  region.m
//  ProvincesAndCity
//
//  Created by lanou3g on 15/9/18.
//  Copyright (c) 2015年 xhf06. All rights reserved.
//

#import "Region.h"

@implementation Region

-(instancetype)initWithString:(NSString *)str{
    if (self = [super init]) {
        self.name = str;
    }
    return self;
}
+(instancetype)regionWithString:(NSString *)str{
    return [[self alloc] initWithString:str];
}



@end
