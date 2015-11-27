//
//  DetailViewController.h
//  TinyCity
//
//  Created by lanou3g on 15/11/23.
//  Copyright © 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotCellFrame.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) HotCellFrame *cellF;

+ (instancetype)shareIntance;

@end
