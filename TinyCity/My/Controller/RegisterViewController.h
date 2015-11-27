//
//  RegisterViewController.h
//  TinyCity
//
//  Created by lanou3g on 15/11/13.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterViewControllerDelegate <NSObject>

- (void)passValue:(NSString *)password selfUser:(AVUser *)selfser;

@end

@interface RegisterViewController : UIViewController
@property (nonatomic, assign)id<RegisterViewControllerDelegate> delegate;

@end
