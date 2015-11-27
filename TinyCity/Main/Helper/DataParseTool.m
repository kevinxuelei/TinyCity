//
//  DataParseTool.m
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "DataParseTool.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "CellFrame.h"
#import "HomeModel.h"

@interface DataParseTool ()
    
@end

@implementation DataParseTool

+ (instancetype)sharaInstance
{
    static dispatch_once_t onceToken;
    static DataParseTool *tool = nil;
    dispatch_once(&onceToken, ^{
        tool = [[DataParseTool alloc] init];
    });
    return tool;
}

+ (void)get:(NSString *)url success:(BLOCK)success failure:(Error)failure
{
     NSMutableArray *cellModelArray = [NSMutableArray array];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
    [manager GET:url parameters:nil success:^ void(AFHTTPRequestOperation * operation, NSDictionary *responseDict) {
        if (responseDict.count != 0) {
            NSArray *listArray = responseDict[@"list"];
            NSMutableArray *modelArray = [HomeModel mj_objectArrayWithKeyValuesArray:listArray];
            for (HomeModel *models in modelArray) {
                CellFrame *frame = [[CellFrame alloc] init];
                frame.model = models;
                [cellModelArray addObject:frame];
            }
            success(cellModelArray);
        }
    } failure:^ void(AFHTTPRequestOperation *operation , NSError * error) {
        failure(error);
    }];
    
}

- (void)get:(NSString *)url success:(BLOCK)success failure:(Error)failure
{
    self.modelArray = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^ void(AFHTTPRequestOperation * operation, NSDictionary *responseDict) {
        if (responseDict.count != 0) {
            NSArray *listArray = responseDict[@"list"];
            self.maxTime = responseDict[@"info"][@"maxtime"];
            NSMutableArray *modelArray = [HomeModel mj_objectArrayWithKeyValuesArray:listArray];
            for (HomeModel *models in modelArray) {
                CellFrame *frame = [[CellFrame alloc] init];
                frame.model = models;
                [_modelArray addObject:frame];
            }
            success(_modelArray);
        }
    } failure:^ void(AFHTTPRequestOperation *operation , NSError * error) {
        failure(error);
    }];
}

- (void)get:(NSString *)url success:(BLOCK)success failure:(Error)failure time:(Time)time
{
    self.modelArray = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^ void(AFHTTPRequestOperation * operation, NSDictionary *responseDict) {
        if (responseDict.count != 0) {
            NSArray *listArray = responseDict[@"list"];
            self.maxTime = responseDict[@"info"][@"maxtime"];
            NSMutableArray *modelArray = [HomeModel mj_objectArrayWithKeyValuesArray:listArray];
            for (HomeModel *models in modelArray) {
                CellFrame *frame = [[CellFrame alloc] init];
                frame.model = models;
                [_modelArray addObject:frame];
            }
            success(_modelArray);
            time(_maxTime);
        }
    } failure:^ void(AFHTTPRequestOperation *operation , NSError * error) {
        failure(error);
    }];
}


@end
