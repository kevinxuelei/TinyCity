//
//  VedioPlayController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/12.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "VedioPlayController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "KrVideoPlayerController.h"
#import "KrVideoPlayerControlView.h"

@interface VedioPlayController ()
@property (nonatomic, strong) KrVideoPlayerController  *videoController;
@end

@implementation VedioPlayController

- (void)viewDidLoad {
    [super viewDidLoad];

     [self playVideo];
    
    
}

- (void)playVideo{
    NSURL *url = [NSURL URLWithString:self.nameUrl];
    [self addVideoPlayerWithURL:url];
}

- (void)addVideoPlayerWithURL:(NSURL *)url{
    if (!self.videoController) {
        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)];
//        KrVideoPlayerControlView *playView = [[KrVideoPlayerControlView alloc] initWithFrame:CGRectMake(0, 66,self.view.width, self.view.height - 66)];
//        [self.videoController.view addSubview:playView];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController setWillBackOrientationPortrait:^{
            [weakSelf toolbarHidden:NO];
        }];
        [self.videoController setWillChangeToFullscreenMode:^{
            [weakSelf toolbarHidden:YES];
        }];
        [self.view addSubview:self.videoController.view];
    }
    self.videoController.contentURL = url;
}
//隐藏navigation tabbar 电池栏
- (void)toolbarHidden:(BOOL)Bool{
    self.navigationController.navigationBar.hidden = Bool;
    self.tabBarController.tabBar.hidden = Bool;
    [[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.videoController stop];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
@end
