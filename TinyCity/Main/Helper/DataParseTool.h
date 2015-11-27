//
//  DataParseTool.h
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BLOCK)(NSMutableArray *array);
typedef void(^Error)(NSError *error);
typedef void(^Time)(NSNumber *time);

@interface DataParseTool : NSObject

+ (instancetype)sharaInstance;

+ (void)get:(NSString *)url success:(BLOCK)success failure:(Error)failure;

- (void)get:(NSString *)url success:(BLOCK)success failure:(Error)failure;

@property (nonatomic, strong) NSMutableArray * modelArray;
@property (nonatomic, strong) NSNumber * maxTime;
@property (nonatomic, strong) NSMutableArray * moreArray;

@property (nonatomic, assign) int i;

- (void)get:(NSString *)url success:(BLOCK)success failure:(Error)failure time:(Time)time;
@end
