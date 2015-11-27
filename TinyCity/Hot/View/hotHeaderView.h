//
//  hotHeaderView.h
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotHeaderModel.h"

@protocol hotHeaderViewDelegate <NSObject>

-(void)moveToDetailVC:(HotHeaderModel *)model;

@end

@interface hotHeaderView : UIView

@property (nonatomic, strong) NSArray *hotDataArr;
@property (nonatomic, assign) id delegate;

@end
