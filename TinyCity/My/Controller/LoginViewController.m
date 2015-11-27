//
//  LoginViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/13.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "QQLoginViewController.h"
#import "SinaLoginViewController.h"
#import <MBProgressHUD.h>
#import "CDCacheManager.h"

@interface LoginViewController ()<UIAlertViewDelegate,RegisterViewControllerDelegate>
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *findPassword;
@property (nonatomic, strong) UITextField *authCode;
@property (nonatomic, strong) UIButton *authCodeButton;
@property (nonatomic, strong) NSString *authCodeText;
@property (nonatomic, strong) AVUser *currentUsers;
@property (nonatomic, strong) NSTimer *timers; // 计时器
@property (nonatomic, assign) NSInteger currentTime; //
@property (nonatomic, copy) NSString *passWord;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_register_background"]];
    
    
//    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"登陆";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:(UIBarButtonItemStylePlain) target:self action:@selector(regsterBtn:)];
    [self loadLogin];
    self.currentTime = 60;
}

#pragma mark 去注册
- (void)regsterBtn:(UIBarButtonItem *)sender
{
    RegisterViewController *regsterVC = [[RegisterViewController alloc] init];
    regsterVC.delegate = self;
    [self.navigationController pushViewController:regsterVC animated:YES];
}
#pragma mark -- RegisterViewControllerDelegate
- (void)passValue:(NSString *)password selfUser:(AVUser *)selfser
{
    _passWord = password;
    _currentUsers = selfser;
}

#pragma mark 登陆
- (void)loadLogin
{
    UITextField *phoneField = [[UITextField alloc] initWithFrame:CGRectMake(10, 85, ViewWidth - 20, 35)];
    phoneField.placeholder = @"UID/用户名";
    phoneField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:phoneField];
    self.nameField = phoneField;
//    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    
    UITextField *password = [[UITextField alloc] initWithFrame:CGRectMake(10, 130, ViewWidth - 20, 35)];
    password.placeholder = @"6位以上的密码";
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.secureTextEntry = YES;
    [self.view addSubview:password];
    self.password = password;

    
    UIButton *login = [UIButton buttonWithType:(UIButtonTypeCustom)];
    login.x = 10;
    login.y = 175;
    login.width = self.view.width - 20;
    login.height = 35;
    [login setTitle:@"登陆" forState:(UIControlStateNormal)];
    [login setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [login setBackgroundImage:[UIImage imageNamed:@"post-tag-participants-click"] forState:(UIControlStateNormal)];
    [self.view addSubview:login];
    [login addTarget:self action:@selector(loginIn:) forControlEvents:(UIControlEventTouchUpInside)];
    self.loginButton = login;
    
    
    
    UIButton *findPassword = [UIButton buttonWithType:(UIButtonTypeCustom)];
    findPassword.x = 10;
    findPassword.y = CGRectGetMaxY(login.frame)  + 50;
    findPassword.width = CGRectGetWidth(login.frame);
    findPassword.height = 35;
    [findPassword setTitle:@"忘记密码？" forState:(UIControlStateNormal)];
    [findPassword setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [findPassword addTarget:self action:@selector(regsterBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:findPassword];
    self.findPassword = findPassword;
    
    // QQ登陆
    UIButton *qqLogin = [UIButton buttonWithType:(UIButtonTypeCustom)];
    qqLogin.x = (self.view.width - 120)/2;
    qqLogin.y = findPassword.y+ 50;
    qqLogin.width = 50;
    qqLogin.height = 50;
    [qqLogin setImage:[UIImage imageNamed:@"logo_qq"] forState:(UIControlStateNormal)];
    [self.view addSubview:qqLogin];
    [qqLogin addTarget:self action:@selector(qqlogin:) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 新浪登陆
    UIButton *sinaLogin = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sinaLogin.x = CGRectGetMaxX(qqLogin.frame)+ 20;
    sinaLogin.y = qqLogin.y;
    sinaLogin.width = 50;
    sinaLogin.height = 50;
    [sinaLogin setImage:[UIImage imageNamed:@"logo_sinaweibo"] forState:(UIControlStateNormal)];
    [self.view addSubview:sinaLogin];
    [sinaLogin addTarget:self action:@selector(sinaLogin:) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 文本第三方登陆
    UILabel *thirdPart = [[UILabel alloc] initWithFrame:CGRectMake(10, sinaLogin.y + 70, findPassword.width, findPassword.height)];
    thirdPart.text = @"使用第三方授权登陆";
    thirdPart.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:thirdPart];
    
}

#pragma mark --  login点击登陆
- (void)loginIn:(UIButton *)sender
{
    if (self.nameField.text.length == 0 || self.password.text.length < 5){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或者手机号不合格！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        AVQuery *queryUser = [AVUser query];
        [queryUser findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (AVUser *user in objects) {
                if ([user.username isEqualToString:self.nameField.text] || [_password.text isEqualToString:_passWord]) {
                    self.currentUsers = user;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.delegate = self;
                    [alert show];
                    [AVUser logInWithUsernameInBackground:_nameField.text password:_password.text block:^(AVUser *user, NSError *error) {
                        if (user != nil) {
//                            PLLog(@"%@",user);
                            _currentUsers = user;
                        }else{
//                            PLLog(@"%@",error);
                        }
                    }];
                    [[CDCacheManager manager] registerUsers:@[user]];
                    [[CDChatManager manager] openWithClientId:user.objectId callback: ^(BOOL succeeded, NSError *error) {
//                        PLLog(@"%@", error);
                    }];
                    return ;
                }
            }
        }];
    }
}


#pragma mark -- 第三方登陆!!
- (void)qqlogin:(UIButton *)sender
{
    [self.navigationController pushViewController:[[QQLoginViewController alloc] init] animated:YES];
}

- (void)sinaLogin:(UIButton *)sender
{
    [self.navigationController pushViewController:[[SinaLoginViewController alloc]init] animated:YES];
}

#pragma mark --UIAlertViewDelegate
- (void)alertView:(nonnull UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(passValue:)]) {
            [self.delegate passValue:self.currentUsers];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
