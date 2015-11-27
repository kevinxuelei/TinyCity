//
//  SinaLoginViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "SinaLoginViewController.h"
static NSString * const AVOS_SNS_BASE_URL=@"cn.avoscloud.com";
static NSString * const AVOS_SNS_BASE_URL2=@"leancloud.cn";
static NSString * const AVOS_SNS_API_VERSION=@"1";


@interface SinaLoginViewController ()<UIWebViewDelegate>
//+ (NSDictionary *)unserializeURL:(NSString *)url;
@end

@implementation SinaLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:web];
    // 加载登陆界面
    NSDictionary *param=@{
                          @"client_id":KAppKey,
                          @"redirect_uri":kRedirectURI,
                          @"display":@"mobile",
                          };
    
    
    NSURLRequest *req = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:@"https://open.weibo.cn/oauth2/authorize" parameters:param error:nil];
    web.delegate = self;
    [web loadRequest:req];

}


-(void)showWait{
    UIActivityIndicatorView *view=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [view startAnimating];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:view];
}

-(void)hideWait{
    self.navigationItem.rightBarButtonItem=nil;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideWait];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self showWait];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    if ((error.code==101 || error.code == 102) && [error.domain isEqualToString:@"WebKitErrorDomain"]) {
        //ignore
    }else{
        [self hideWait];
        NSLog(@"%@",error);
    }
    
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
        [self accessTokenWithCode:code];
        
        // 禁止加载回调页面
        return NO;
    }
    
    return YES;
}



- (void)accessTokenWithCode:(NSString *)code
{
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2.封装请求参数
    NSString *url=nil;
    NSDictionary *param=nil;
    
    
    param=@{
            @"client_id":KAppKey,
            @"client_secret":KSecret,
            @"redirect_uri":kRedirectURI,
            @"grant_type":@"authorization_code",
            @"code":code
            };
    
    url=@"https://api.weibo.com/oauth2/access_token";

    // 3.发送POST请求
    [mgr POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id accountDict) {
        // 隐藏HUD
        NSDictionary *info=[NSJSONSerialization JSONObjectWithData:accountDict options:NSJSONReadingAllowFragments error:nil];
        
        NSString *token=info[@"access_token"];

        if (token) {
            NSString *uid=info[@"uid"];
            if (uid==nil) {
                uid=info[@"openid"];
            }
            [self onSuccess:token andExpires:info[@"expires_in"] andUid:uid];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 隐藏HUD
        NSLog(@"请求失败--%@", error);
    }];
}

-(void)onSuccess:(NSString*)token andExpires:(NSString*)expires andUid:(NSString*)uid{
    
    NSString *url=nil;
    NSDictionary *params=nil;
    url=@"https://api.weibo.com/2/users/show.json";
    params=@{
             @"access_token":token,
             @"uid":uid
             };
        
        [[AFHTTPRequestOperationManager manager] GET:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
            NSLog(@"%@",responseObject);
            NSString *name = responseObject[@"name"];
            NSString *imageUrl = responseObject[@"profile_image_url"];
            AVUser *user = [AVUser user];
            user.username = name;
            user.password = @"123456";
            user.sessionToken = imageUrl;
            [user signUp:nil];
            
            [[CDChatManager manager] openWithClientId:user.objectId callback: ^(BOOL succeeded, NSError *error) {
                //            PLLog(@"%@", error);
            }];
            [AVUser logInWithUsernameInBackground:name password:@"123456" block:^(AVUser *user, NSError *error) {
                if (!error) {
                    [[CDChatManager manager] openWithClientId:user.objectId callback: ^(BOOL succeeded, NSError *error) {
                        //                        PLLog(@"%@", error);
                    }];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    NSString *str = [NSString stringWithFormat:@"%@",error];
                    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:str leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                    [alert show];
                }
            }];
//            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


@end
