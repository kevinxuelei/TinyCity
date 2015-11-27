//
//  SinaLoginViewController.h
//  TinyCity
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SinaLoginViewControllerDelegate <NSObject>
- (void)passValueByThirdPart:(NSDictionary *)dict;
@end

@interface SinaLoginViewController : UIViewController

@property (nonatomic, assign)id<SinaLoginViewControllerDelegate> delegate;
@end
