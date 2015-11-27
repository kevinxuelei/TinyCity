//
//  LoginViewController.h
//  TinyCity
//
//  Created by lanou3g on 15/11/13.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>
- (void)passValue:(AVUser *)user;
@end

@interface LoginViewController : UIViewController

@property (nonatomic, assign) id<LoginViewControllerDelegate> delegate;
@end
