//
//  CellFrame.h
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"
#import <UIKit/UIKit.h>
@interface CellFrame : NSObject

@property (nonatomic, assign) CGRect  profile_imageFrame;
@property (nonatomic, assign) CGRect  name_labelFrame;
@property (nonatomic, assign) CGRect  created_at_labelFrame;
@property (nonatomic, assign) CGRect  bigImageViewFrame;
@property (nonatomic, assign) CGRect  saveButtonFrame;
@property (nonatomic, assign) CGRect  transmitButtonFrame;
@property (nonatomic, assign) CGRect  reportButtonFrame;
@property (nonatomic, assign) CGRect  titleLabelFrame;
@property (nonatomic, strong) HomeModel * model;

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;

@end
