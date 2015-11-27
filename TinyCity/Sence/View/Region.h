//
//  region.h
//  ProvincesAndCity
//
//  Created by lanou3g on 15/9/18.
//  Copyright (c) 2015年 xhf06. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Region : NSObject

@property (nonatomic, copy) NSString *name;

-(instancetype)initWithString:(NSString *)str;
+(instancetype)regionWithString:(NSString *)str;

@end
