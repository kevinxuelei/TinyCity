//
//  RegisterViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/13.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "RegisterViewController.h"
#import <MBProgressHUD.h>

@interface RegisterViewController ()
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UIButton *regsterButton;
@property (nonatomic, strong) UITextField *authCode;
@property (nonatomic, strong) UIButton *authCodeButton;
@property (nonatomic, strong) NSTimer *timers; // 计时器
@property (nonatomic, assign) NSInteger currentTime; //
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong)  AVUser *selfUser;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_register_background"]];
    
//    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"注册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(barClick)];
    [self setUpRegsterView];
     self.currentTime = 60;
}
// 完成
- (void)barClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 注册界面的搭建
- (void)setUpRegsterView
{
    UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 85, self.view.width - 20, 35)];
    nameField.placeholder = @"用户名";
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:nameField];
    self.nameField = nameField;
    
    UITextField *phoneField = [[UITextField alloc] initWithFrame:CGRectMake(10, _nameField.y+35+ 10, self.view.width - 20, 35)];
    phoneField.placeholder = @"UID/手机号";
    phoneField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:phoneField];
    self.phoneField = phoneField;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    
    UITextField *password = [[UITextField alloc] initWithFrame:CGRectMake(10, _phoneField.y+35+10, self.view.width - 20, 35)];
    password.placeholder = @"6位以上的密码";
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.secureTextEntry = YES;
    [self.view addSubview:password];
    self.password = password;
    
    UITextField *authCode = [[UITextField alloc] initWithFrame:CGRectMake(10, _password.y+35+ 10, (self.view.width - 30)/2, 35)];
    authCode.placeholder = @"输入验证码";
    [self.view addSubview:authCode];
    self.authCode = authCode;
    authCode.borderStyle = UITextBorderStyleRoundedRect;
    
    UIButton *authCodeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    authCodeButton.frame = CGRectMake(CGRectGetMaxX(authCode.frame)+ 10, CGRectGetMinY(_authCode.frame), (self.view.width - 30)/2, 35);
    [authCodeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [authCodeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [authCodeButton setBackgroundImage:[UIImage imageNamed:@"post-tag-participants-click"] forState:(UIControlStateNormal)];
    [authCodeButton setBackgroundImage:[UIImage imageNamed:@"loginBtnBg"] forState:(UIControlStateNormal)];
    [self.view addSubview:authCodeButton];
    authCodeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [authCodeButton addTarget:self action:@selector(authCodeButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.authCodeButton = authCodeButton;
    
    UIButton *regsterButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    regsterButton.x = 10;
    regsterButton.y = authCodeButton.y+45;
    regsterButton.width = self.view.width - 20;
    regsterButton.height = 35;
    [regsterButton setBackgroundImage:[UIImage imageNamed:@"post-tag-participants-click"] forState:(UIControlStateNormal)];
    [regsterButton setTitle:@"注册" forState:(UIControlStateNormal)];
    [regsterButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.view addSubview:regsterButton];
    [regsterButton addTarget:self action:@selector(regsterButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.regsterButton = regsterButton;
}
#pragma mark 注册
- (void)regsterButton:(UIButton *)button
{
    NSLog(@"注册");
    if (self.phoneField.text.length == 0 || self.password.text.length < 6 || self.authCode.text.length < 5 || self.nameField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或者手机号不能为空！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,1-9]))\\d{8}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:self.phoneField.text];
        if (isMatch) {
            [AVUser verifyMobilePhone:self.authCode.text withBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [AVUser logInWithUsernameInBackground:self.nameField.text password:self.password.text block:^(AVUser *user, NSError *error) {}];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                    [alert show];
                    if (_delegate && [_delegate respondsToSelector:@selector(passValue:selfUser:)]) {
                        [_delegate passValue:self.password.text selfUser:_selfUser];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"验证码错误!!!" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                    [alert show];
                }
            }];
            
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不符合！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}




#pragma mark 获取验证码
- (void)authCodeButton:(UIButton *)sender
{
    self.timers = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeCountDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timers forMode:NSRunLoopCommonModes];
    NSLog(@"获取验证码");

    AVUser *user = [AVUser user];
    user.username = self.nameField.text;
    user.password = self.password.text;
    user.mobilePhoneNumber = self.phoneField.text;
    _selfUser = user;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"发送成功");
        }else{
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"手机号已经注册!!!" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
            [alert show];
        }
    }];

}
#pragma mark 倒计时
- (void)timeCountDown
{
    //    NSInteger currentTime = 60;
    NSString *str = [NSString stringWithFormat:@"%ld秒之后重发",(long)_currentTime];
    [self.authCodeButton setTitle:str forState:(UIControlStateNormal)];
    _authCodeButton.enabled = NO;
    _currentTime --;
    if (_currentTime == 0) {
        _currentTime = 60;
        _authCodeButton.enabled = YES;
        [self endTimer];
        [self.authCodeButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    }
}

- (void)endTimer
{
    [self.timers invalidate];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
