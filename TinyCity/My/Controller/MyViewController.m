//
//  MyViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/11.
//  Copyright (c) 2015年 DH. All rights reserved.


#import "MyViewController.h"
#import "LoginViewController.h"
#import "CDConvsVC.h"
#import "MyCell.h"
#import "HomeModelSaveTableViewController.h"
#import "ConfigureTableViewController.h"
#import "MCPhotographyHelper.h"
#import "CDUtils.h"
#import "CDUserManager.h"
#import "CDProfileNameVC.h"
#import <LCUserFeedbackAgent.h>
#import <UIKit/UIKit.h>
#import "TrendsViewController.h"
#import "CDCacheManager.h"
#import "CDIMService.h"
#import "AroundPersonViewController.h"
#import "AboutUsTableViewController.h"

@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate,LoginViewControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,CDProfileNameVCDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UITableView *loginTableV;
@property (nonatomic, strong) UIButton *logout;
@property (nonatomic, strong) AVUser *users;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) MCPhotographyHelper *photographyHelper;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *imagePath;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabg"]];
    
    
    [self setUpMyView];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imagePath = [path stringByAppendingPathComponent:@"image.plist"];
    self.imagePath = imagePath;
    
}
#pragma mark -- 加载我的界面
- (void)setUpMyView
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    _loginTableV = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    _loginTableV.delegate = self;
    _loginTableV.dataSource = self;
    [self.view addSubview:_loginTableV];
    _loginTableV.showsVerticalScrollIndicator = NO;
    [_loginTableV registerClass:[MyCell class] forCellReuseIdentifier:@"login"];
    self.navigationItem.title = @"我";
    
    UIButton *logout = [UIButton buttonWithType:(UIButtonTypeCustom)];
    logout.x = 0;
    logout.y = 10;
    logout.width = self.view.width - 20;
    logout.height = 35;
//    [logout setTitle:@"注销登陆" forState:(UIControlStateNormal)];
    [logout setBackgroundImage:[UIImage imageNamed:@"jie-favoritePopupButton"] forState:(UIControlStateNormal)];
    [logout setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.logout = logout;
    self.loginTableV.tableFooterView = logout;
    [logout addTarget:self action:@selector(logout:) forControlEvents:(UIControlEventTouchUpInside)];
}
#pragma mark 注销
- (void)logout:(UIButton *)sender
{
    if (_isLogin == NO) {
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定注销吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
#pragma mark -- UIAlertViewDelegate代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            self.users = nil;
            [AVUser logOut];
            [self.loginTableV reloadData];
            _isLogin = NO;
            [self.logout setTitle:@"请登录" forState:(UIControlStateNormal)];
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 2;
            break;
        default:
            return 1;
            break;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"login" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (self.users.username.length == 0) {
            cell.title_Label.text = @"未登录用户";
            cell.iconImage.image = [UIImage imageNamed:@"default_head"];
        }else{
            cell.title_Label.text = self.users.username;
                if (_dataArray.count == 0) {
                    UIImage *image = [NSKeyedUnarchiver unarchiveObjectWithFile:_imagePath];
                    cell.iconImage.image = image;
                }else{
//                    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:_users.sessionToken]];
                    UIImage *images = [_dataArray firstObject];
                    cell.iconImage.image = images;
                }
        }
        cell.iconImage.layer.cornerRadius = cell.iconImage.width/2;
        cell.iconImage.layer.masksToBounds = YES;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.iconImage.image = [UIImage imageNamed:@"me_my_chat_ico"];
        cell.title_Label.text = @"我的聊天";
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.iconImage.image = [UIImage imageNamed:@"me_my_dynamic_ico"];
            cell.title_Label.text = @"我的动态";
//        }else if (indexPath.row == 1){
//            cell.iconImage.image = [UIImage imageNamed:@"me_my_topic_ico"];
//            cell.title_Label.text = @"我的话题";
//        }else if (indexPath.row == 2){
//            cell.iconImage.image = [UIImage imageNamed:@"me_my_follow_ico"];
//            cell.title_Label.text = @"我的关注";
        }else if (indexPath.row == 1){
            cell.iconImage.image = [UIImage imageNamed:@"me_my_visitors_ico"];
            cell.title_Label.text = @"附近的人";
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.iconImage.image = [UIImage imageNamed:@"me_my_collection_ico"];
            cell.title_Label.text = @"我的收藏";
        }
    }
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            cell.iconImage.image = [UIImage imageNamed:@"me_about_app_ico"];
            cell.title_Label.text = @"关于应用";
        }
        if (indexPath.row == 1) {
            cell.iconImage.image = [UIImage imageNamed:@"me_setting_ico"];
            cell.title_Label.text = @"设置";
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 80;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (_isLogin == YES){
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更新资料" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"更改头像", @"更改用户名", nil];
            [actionSheet showInView:self.view];
        }else{
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.delegate = self;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (_isLogin == YES) {
            CDConvsVC *cd = [[CDConvsVC alloc] init];
            [self.navigationController pushViewController:cd animated:YES];
        }
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        if (_isLogin == YES) {
            TrendsViewController *trends = [[TrendsViewController alloc] init];
            [self.navigationController pushViewController:trends animated:YES];
        }
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        AroundPersonViewController  *aroundPersonVC = [[AroundPersonViewController alloc] init];
        [self.navigationController pushViewController:aroundPersonVC animated:YES];
    }
    if (indexPath.section == 3) {
        HomeModelSaveTableViewController *homeModelSaveVC = [[HomeModelSaveTableViewController alloc] init];
        [self.navigationController pushViewController:homeModelSaveVC animated:YES];
    }
    if (indexPath.section == 4&& indexPath.row == 0) {
        AboutUsTableViewController *aboutVC = [[AboutUsTableViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    if (indexPath.section == 4 && indexPath.row == 1) {
        ConfigureTableViewController *configureVC = [[ConfigureTableViewController alloc] init];
        [self.navigationController pushViewController:configureVC animated:YES];
    }
    [_loginTableV selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionTop)];
    [_loginTableV deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -- UIActionSheetDelegate代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    if (buttonIndex == 0) {
        [self pickImage];
    } else {
        CDProfileNameVC *profileNameVC = [[CDProfileNameVC alloc] init];
        profileNameVC.placeholderName = [AVUser currentUser].username;
        profileNameVC.profileNameVCDelegate = self;
        [self.navigationController pushViewController:profileNameVC animated:YES];
    }
}

-(void)pickImage {
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //设置图像选取控制器的类型为静态图像
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    //允许用户进行编辑
    imagePickerController.allowsEditing = YES;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
#pragma mark --UIImagePickerControllerDelegate代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //打印出字典中的内容
    NSLog(@"get the media info: %@", info);
    //获取媒体类型
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断是静态图像还是视频
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //获取用户编辑之后的图像
        UIImage* editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        //将该图像保存到媒体库中
//        UIImageWriteToSavedPhotosAlbum(editedImage, self, nil, NULL);
//        UIImageWriteToSavedPhotosAlbum(editedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        self.dataArray = [NSMutableArray arrayWithObject:editedImage];
        NSLog(@"%@",_imagePath);
        [NSKeyedArchiver archiveRootObject:editedImage toFile:_imagePath];
        [self.loginTableV reloadData];
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark --CDProfileNameVCDelegate代理方法
- (void)didDismissProfileNameVCWithNewName:(NSString *)name
{
    self.users.username = name;
    AVUser *user = [AVUser currentUser];
    user.username = name;
    [self.loginTableV reloadData];
}

#pragma mark --LoginViewControllerDelegate代理方法
- (void)passValue:(AVUser *)user
{
    self.users = user;
    [self.loginTableV reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    AVUser *currentU = [AVUser currentUser];
    if (currentU != nil) {
        [self.logout setTitle:@"注销登录" forState:(UIControlStateNormal)];
        _isLogin = YES;
        
        [self toMain:currentU];
        
        [_loginTableV reloadData];
    }else{
        [self.logout setTitle:@"请登录" forState:(UIControlStateNormal)];
        _isLogin = NO;
    }
    self.users = currentU;
}

- (void)toMain:(AVUser *)currentU
{

    [CDChatManager manager].userDelegate = [CDIMService service];
    [[CDCacheManager manager] registerUsers:@[currentU]];
    [[CDChatManager manager] openWithClientId:currentU.objectId callback: ^(BOOL succeeded, NSError *error) {
        //            PLLog(@"%@", error);
    }];
}

@end
