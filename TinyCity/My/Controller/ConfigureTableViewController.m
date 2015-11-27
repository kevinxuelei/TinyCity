//
//  ConfigureTableViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "ConfigureTableViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "SDImageCache.h"

@interface ConfigureTableViewController ()<UMSocialUIDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataListArray;
@property (nonatomic, strong) UITableView *tableV;

@end

@implementation ConfigureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadT];
    self.navigationItem.title = @"设置";
    self.dataListArray = [NSArray arrayWithObjects:@"分享应用",@"清除图片缓存",@"清除视频缓存", nil];
    self.tableV.tableFooterView = [[UIView alloc] init];
   
}

- (void)loadT
{
    self.tableV = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStylePlain)];
    _tableV.dataSource = self;
    _tableV.delegate = self;
    [self.view addSubview:_tableV];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"configureCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataListArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"iconfont-fenxiang-ren"];
    }
    if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"iconfont-qingchuyuhuancun"];
    }
    if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"iconfont-qingchuyuhuancun"];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        [self shareApp];
    }
    if (indexPath.row == 1) {
        
        DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"清除已经下载的图片缓存,释放SD卡空间(如空间足够,为了节省流量建议不要清除)" leftButtonTitle:@"是" rightButtonTitle:@"否"];
        [alertView show];
        alertView.rightBlock = ^(){
            [self clearImagesCach];
        };
    }
    if (indexPath.row == 2) {
        
        DXAlertView *alertVedioView = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"清除已经下载的视频缓存,释放SD卡空间(如空间足够,为了节省流量建议不要清除)" leftButtonTitle:@"是" rightButtonTitle:@"否"];
        [alertVedioView show];
        
        alertVedioView.rightBlock = ^(){
            [self clearVedioCach];
        };
        
    }
    
}

#pragma mark  ----  视频缓存
-(void)clearVedioCach{
 
    NSMutableArray *dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KHomeSavePath];
    [dataArray removeAllObjects];
    [NSKeyedArchiver archiveRootObject:dataArray toFile:KHomeSavePath];
    [self clearCashAlert];
}
#pragma mark ----  语音缓存
-(void)clearImagesCach{

    
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [self clearCashAlert];
}


-(void)clearCashAlert{
    UILabel *clearLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, self.view.height - 150, 150, 40)];
    clearLabel.layer.masksToBounds = YES;
    clearLabel.layer.cornerRadius = 10;
    clearLabel.textAlignment = NSTextAlignmentCenter;
    clearLabel.textColor = [UIColor whiteColor];
    clearLabel.backgroundColor = [UIColor grayColor];
    [self.view addSubview:clearLabel];
    clearLabel.text = @"清除缓存成功!!!";
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        clearLabel.frame = CGRectMake(100, self.view.height - 250, 150, 40);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 delay:0.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [clearLabel removeFromSuperview];//引用计数-1 自动销毁对象
        } completion:^(BOOL finished) {
            
        }];
    }];
}

//#warning message ------------------------- 点击邮箱crash 如何打开手机内的应用
-(void)shareApp
{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:APPKey shareText:@"微城" shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,UMShareToEmail,UMShareToQzone,UMShareToDouban,UMShareToFacebook,UMShareToRenren,UMShareToWechatTimeline, nil] delegate:self];
    
    
}

@end
