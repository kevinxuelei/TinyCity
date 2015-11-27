//
//  AreasView.h
//  TinyCity
//
//  Created by lanou3g on 15/11/14.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BLOCK)(NSString *,NSString*);

@interface AreasView : UIView

@property (nonatomic, copy) BLOCK block;

@end
