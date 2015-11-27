//
//  MainTabBarController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/11.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "HotViewController.h"
#import "MyViewController.h"
#import "SceneViewController.h"


@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tabBar.barTintColor = [UIColor buttermilkColor];
    //self.tabBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ows_display_banner_bg"]];
    [self setUpBarItemTitle:@"首页" currentImage:@"tabBar_essence_iconN" selectImage:@"tabBar_essence_click_iconN" byVC:[[HomeViewController alloc] init]];
    [self setUpBarItemTitle:@"微圈" currentImage:@"tabBar_me_iconN" selectImage:@"tabBar_me_click_iconN" byVC:[[HotViewController alloc] init]];
    [self setUpBarItemTitle:@"附近" currentImage:@"tabBar_new_iconN" selectImage:@"tabBar_new_click_iconN" byVC:[[SceneViewController alloc] init]];
    [self setUpBarItemTitle:@"我" currentImage:@"tabBar_friendTrends_iconN" selectImage:@"tabBar_friendTrends_click_iconN" byVC:[[MyViewController alloc] init]];
 
}

- (void)setUpBarItemTitle:(NSString *)title currentImage:(NSString *)currentImage selectImage:(NSString *)selectImage byVC:(UIViewController *)currentVC
{
    currentVC.tabBarItem.image = [UIImage imageNamed:currentImage];
    currentVC.tabBarItem.title = title;
    UIImage *select = [UIImage imageNamed:selectImage];
    // 不渲染
    select = [select imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    currentVC.tabBarItem.selectedImage = select;

    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:currentVC];
    navi.title = title;
    UINavigationBar *nav = [UINavigationBar appearance];
    nav.backgroundColor = [UIColor blueColor];
    nav.alpha = 0.8;
    [self addChildViewController:navi];
}



@end
