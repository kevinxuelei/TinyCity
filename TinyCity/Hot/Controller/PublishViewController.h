//
//  PublishViewController.h
//  TinyCity
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@protocol PublishViewControllerDelegate <NSObject>

- (void)passValueInModel:(UserInfoModel *)model;

@end

@interface PublishViewController : UIViewController

@property (nonatomic, assign) id<PublishViewControllerDelegate> delegate;

@end
