//
//  HotViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/11.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "HotViewController.h"
#import "HotHeaderViewModel.h"
#import "hotHeaderView.h"
#import "HotCellModel.h"
#import "HotCellFrame.h"
#import "HotTableViewCell.h"
#import "HotHeaderModel.h"
#import <MJExtension.h>
#import <AFNetworking.h>
#import "PublishViewController.h"
#import "HotDetailViewController.h"
#import "UserInfoModel.h"
#import "DetailViewController.h"
#import "CommentModel.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#define KHotHeaderUrl @"http://v1.opencom.cn/sstuc?secret_key=8f39906e81a7f4ef2579d784b20050c2&action=app/app_main_img_post"
#define kHotCellUrl @"http://v1.opencom.cn/sstuc?secret_key=8f39906e81a7f4ef2579d784b20050c2&action=lbbs/get_hots"
#define KArticleListUrl @"http://api.en8848.com/home.php"


@interface HotViewController ()<UITableViewDelegate,UITableViewDataSource,hotHeaderViewDelegate,PublishViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *headerDataArr;
@property (nonatomic, strong) NSMutableArray *cellDataArr;
@property (nonatomic, strong) NSMutableArray *articleHotArr;
@property (nonatomic, assign) BOOL isFlag;
@property (nonatomic, strong) MBProgressHUD *hub;
@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"微圈";
    _isFlag = NO;
    [self loadTableView];
    [self loadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"tag_publish_post"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:(UIBarButtonItemStylePlain) target:self action:@selector(clickToRelease)];
    [self loadNewDate];
    
    
}
#pragma mark -- 刷新
- (void)loadNewDate
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [_tableView.mj_header endRefreshing];
        });
    }];
}



- (void)loadTableViewData
{
    AVQuery *query = [UserInfoModel query];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    NSMutableArray *array = (NSMutableArray *)[query findObjects];
    for (UserInfoModel *model in array) {
        HotCellFrame *frame = [[HotCellFrame alloc] init];
        frame.model = model;
        [_cellDataArr addObject:frame];
    }
}

- (void)clickToRelease
{
    AVUser *user = [AVUser currentUser];
    if (user == nil){
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"用户还未登陆" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [alert show];
    }else{
        PublishViewController *publish = [[PublishViewController alloc] init];
        publish.delegate = self;
        
        [self.navigationController pushViewController:publish animated:YES];
    }
}

- (void)showPress
{
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    hub.labelText = @"loding...";
    [hub show:YES];
    hub.animationType = MBProgressHUDAnimationFade;
    hub.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:hub];
    self.hub = hub;
}

- (void)endProgress
{
    [self.hub hide:YES];
}

-(void)loadTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma  mark -- PublishViewControllerDelegate代理
- (void)passValueInModel:(UserInfoModel *)model
{
    HotCellFrame *frame = [[HotCellFrame alloc] init];
    frame.model = model;
}

-(void)loadData{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:KArticleListUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arrayH = [responseObject objectForKey:@"hot"];
        NSMutableArray *arrayhot = [NSMutableArray array];
        for (NSDictionary *dict in arrayH) {
            HotHeaderModel *model = [[HotHeaderModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [arrayhot addObject:model];
        }
        self.articleHotArr = arrayhot;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cellDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = [NSString stringWithFormat:@"%ld.%ld",(long)indexPath.section,(long)indexPath.row];

    HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HotTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:identifier];
    }
    [cell.transmitButton addTarget:self action:@selector(ding:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.transmitButton.tag = indexPath.row;
    [cell.reportButton addTarget:self action:@selector(clickToComment:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.reportButton.tag = indexPath.row;
    cell.cellFrame = self.cellDataArr[indexPath.row];
    return cell;
}
#pragma mark -- 评论
- (void)clickToComment:(UIButton *)sender
{
    if ([AVUser currentUser].username.length != 0) {
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        [self toNext:indexP];
    }else{
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"还未登陆！！！" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [alert show];
        return;
    }
}

#pragma mark -- 点赞
- (void)ding:(UIButton *)button
{
    if ([AVUser currentUser].username.length != 0) {
        HotCellFrame *cellF = self.cellDataArr[button.tag];
        AVQuery *query = [CommentModel query];
        AVObject *model = [query getObjectWithId:cellF.model.model.objectId];
        NSMutableArray *array = [model objectForKey:@"thumbsUp"];
        NSString *currentU = [AVUser currentUser].username;
        if (![array containsObject:currentU]) {
            [array addObject:currentU];
            NSString *str = [NSString stringWithFormat:@"%ld",(unsigned long)array.count];
            [button setTitle:str forState:(UIControlStateNormal)];
//            [button setBackgroundColor:PLRandomColor];
            [model setObject:array forKey:@"thumbsUp"];
            [model saveInBackground];
            button.enabled = NO;
        }else{
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"已经赞过了！！！" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
            [alert show];
            button.enabled = NO;
            return;
        }
#pragma mark -- 改变
        AVQuery *querys = [UserInfoModel query];
        AVObject *userInfo = [querys getObjectWithId:cellF.model.objectId];
        [userInfo setObject:[NSString stringWithFormat:@"%ld",array.count] forKey:@"praise_num"];
        [userInfo saveInBackground];
    }else{
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"还未登陆！！！" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [alert show];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HotCellFrame *cellFrame = self.cellDataArr[indexPath.row];
    return cellFrame.cellHeight + 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    hotHeaderView *header = [[hotHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    header.delegate = self;
    header.hotDataArr = self.articleHotArr;
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark ---- hotHeaderViewDelegate{
-(void)moveToDetailVC:(HotHeaderModel *)model{
    
//    HotDetailViewController *detailVC = [[HotDetailViewController alloc] init];
//    detailVC.model  = model;
//    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)toNext:(NSIndexPath *)index
{
    [self showPress];

    DetailViewController *detail = [DetailViewController shareIntance];
    detail.cellF = self.cellDataArr[index.row];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [AVUser currentUser].username;
    if (name.length != 0) {
        [self toNext:indexPath];
    }else{
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"还未登陆!!!" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        [alert show];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.cellDataArr = [NSMutableArray array];
    [self endProgress];
    [self loadTableViewData];
    [_tableView reloadData];
}

@end
