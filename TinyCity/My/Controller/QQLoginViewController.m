//
//  QQLoginViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "QQLoginViewController.h"
#define QQAppId @"1104890839"
#define QQAppKey @"WZ31hlKOFGFw1zTU"


@interface QQLoginViewController ()<UIWebViewDelegate>

@end

@implementation QQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:web];
    // 加载登陆界面
    web.delegate = self;

    
    NSDictionary *params=@{
                           @"client_id":QQAppId,
                           @"redirect_uri":QQAppKey,
                           @"display":@"mobile",
                           @"scope":@"get_simple_userinfo,list_album,upload_pic,do_like",
                           @"response_type":@"token",
                           @"which":@"Login",
                           @"ucheck":@1,
                           @"fall_to_wv":@1
                           };
    NSURLRequest *req = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:@"http://openmobile.qq.com/oauth2.0/m_show" parameters:params error:nil];
    
    [web loadRequest:req];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    
    // 2.判断url是否为回调地址
    NSString *str = [NSString stringWithFormat:@"%@/?code=", kRedirectURI];
    NSRange range = [url rangeOfString:str];
    if (range.location != NSNotFound) { // 是回调地址
        // 截取授权成功后的请求标记
        NSInteger from = range.location + range.length;
        NSString *code = [url substringFromIndex:from];
        
        // 根据code获得一个accessToken
        [self.navigationController popToRootViewControllerAnimated:YES];
        // 禁止加载回调页面
        return NO;
    }
    
    return YES;
}

@end
