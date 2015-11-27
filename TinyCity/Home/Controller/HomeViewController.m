//
//  HomeViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/11.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "HomeViewController.h"
#import "DataParseTool.h"
#import "VedioPlayController.h"
#import "HomeModel.h"
#import "CellFrame.h"
#import "HomeCell.h"
#import "WaterFlowLayout.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "CDConvReportAbuseVC.h"


@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WaterFlowDelegate,UMSocialUIDelegate,UICollectionViewCellSaveDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, assign) NSInteger currentTime;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MBProgressHUD *hub;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSMutableArray *SaveDataArray;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabg"]];
  
    self.navigationItem.title = @"首页";
    [self loadTableView];
    [self loadData];
    [self loadNewDate];
    [self loadMoreDate];
    MBProgressHUD *hub = [[MBProgressHUD alloc] initWithView:self.view];
    hub.labelText = @"loding...";
    [hub show:YES];
    hub.animationType = MBProgressHUDAnimationFade;
    hub.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:hub];
    self.hub = hub;
}
#pragma mark -- 加载最新数据
- (void)loadNewDate
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(upLoad)];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i<61; i++) {
        NSString *imageName = [NSString stringWithFormat:@"dropdown_anim__000%d",i];
        UIImage *imagess = [UIImage imageNamed:imageName];
        [imageArray addObject:imagess];
    }
    [header setImages:imageArray duration:2.0f forState:(MJRefreshStateRefreshing)];
    self.collection.mj_header = header;
}

#pragma mark -- 加载更多数据
- (void)loadMoreDate
{
    __block int count = 1;
    __weak UICollectionView *collec = self.collection;
    collec.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            count++;
            NSString *str = @"http://api.budejie.com/api/api_open.php?a=list&appname=baisishequ&asid=56280F3D-FFF0-4D6A-ABA9-C52F3D13282B&c=video&client=iphone&device=iPhone%";
            NSString *str1 = [NSString stringWithFormat:@"204S&from=ios&jbk=0&mac=&market=&maxtime=%@&openudid=379ec5e20a2a6ca41a523ed24c985a847b0a580a&page=%d&per=20&sub_flag=1&type=41&udid=&ver=3.6.1",self.number,count];
            NSString *str2 = [str stringByAppendingString:str1];
            [[DataParseTool sharaInstance]get:str2 success:^(NSMutableArray *array) {
                for (CellFrame *cellF in array) {
                    [_dataArray addObject:cellF];
                }
                [_collection reloadData];
                [_collection.mj_footer endRefreshing];
            } failure:^(NSError *error) {
                
            } time:^(NSNumber *time) {
                self.number = time;
            }];
        });
    }];
}

//upLoad
- (void)upLoad
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self loadData];
        [_collection.mj_header endRefreshing];
    });
}

- (void)loadTableView
{
    WaterFlowLayout *layOut = [[WaterFlowLayout alloc] init];
    layOut.delegate = self;
    CGFloat w = ([UIScreen mainScreen].bounds.size.width - 30)/2;
    layOut.itemSize = CGSizeMake(w, w);
    layOut.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    layOut.insertItemSpacing = 10;
    layOut.numberOfColumns = 2;
    
    self.collection = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layOut];
    _collection.dataSource = self;
    _collection.delegate = self;
    _collection.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collection];
    [_collection registerClass:[HomeCell class] forCellWithReuseIdentifier:@"collection"];

}

- (void)loadData
{
    self.dataArray = [NSMutableArray array];
    [[DataParseTool sharaInstance]get:URLs success:^(NSMutableArray *array) {
        if (array.count != 0) {
            _hub.hidden = YES;
            self.dataArray = [NSMutableArray arrayWithArray:array];
            [_collection reloadData];
            [self.collection.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.collection.mj_header endRefreshing];
    } time:^(NSNumber *time) {
        self.number = time;
    }];
    
}
#pragma mark -- UICollectionViewDataSource 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    cell.delegate = self;
    cell.cellF = self.dataArray[indexPath.item];
    cell.transmitButton.tag = indexPath.item;
    [cell.transmitButton addTarget:self action:@selector(transmit:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.reportButton addTarget:self action:@selector(report:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}

#pragma mark _reportButton点击举报方法
- (void)report:(UIButton *)sender
{
    CDConvReportAbuseVC *conv = [[CDConvReportAbuseVC alloc] init];
    [self.navigationController pushViewController:conv animated:YES];
}

#pragma mark _transmitButton点击分享方法
- (void)transmit:(UIButton *)sender
{
    CellFrame *cellf = self.dataArray[sender.tag];
    NSString *title = cellf.model.text;
    NSString *urlMp4 = cellf.model.videouri;
    NSString *shareText = [NSString stringWithFormat:@"%@,%@",title,urlMp4];
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:cellf.model.image1]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:APPKey
                                      shareText:shareText
                                     shareImage:imageV.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQQ,UMShareToEmail,UMShareToQzone,UMShareToDouban,UMShareToFacebook,UMShareToRenren,UMShareToTencent,UMShareToSms,UMShareToWechatFavorite,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWhatsapp,  nil]
                                       delegate:self];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    CellFrame *cell = self.dataArray[indexPath.item];
    VedioPlayController *detail = [[VedioPlayController alloc] init];
    detail.nameUrl = cell.model.videouri;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -- WaterFlowDelegate 代理
- (CGFloat)heightForItemIndexPath:(NSIndexPath *)indexPath
{
    CellFrame *cellF = self.dataArray[indexPath.item];
    return cellF.cellHeight;
}

#pragma mark -- UMSocialUIDelegate 代理
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功!!!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
    }
}

- (BOOL)closeOauthWebViewController:(UINavigationController *)navigationCtroller socialControllerService:(UMSocialControllerService *)socialControllerService
{
    return  YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark -- UICollectionViewCellSaveDelegate 收藏
-(void)UICollectionViewCellSaveDelegate:(HomeModel *)saveModel withSaveButton:(UIButton *)button{
    
    self.SaveDataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:KHomeSavePath];
    if (self.SaveDataArray == nil) {
        
     self.SaveDataArray = [NSMutableArray array];
     [self.SaveDataArray addObject:saveModel];
    [NSKeyedArchiver archiveRootObject:self.SaveDataArray toFile:KHomeSavePath];
        button.selected = YES;
    }else{
        
        if ([self modelIsInSaveModelsArray:saveModel] == YES) {
            [self saveFailAlterView];
        }else{
            [self.SaveDataArray addObject:saveModel];
            [self saveSuccessAlterView];
            [NSKeyedArchiver archiveRootObject:self.SaveDataArray toFile:KHomeSavePath];
            button.selected = YES;
        }
    }
}
#pragma mark------判断是否收藏过
-(BOOL)modelIsInSaveModelsArray:(HomeModel *)sortModel{
    
    NSMutableArray *arrModel = [NSMutableArray array];
    
    for (HomeModel *model in self.SaveDataArray) {
        HomeModel *modelTemp = model;
        NSString *strTitle = modelTemp.user_id;
        [arrModel addObject:strTitle];
    }
    
    NSString *modelTitle = sortModel.user_id;
    if ([arrModel containsObject:modelTitle]) {
        return  YES;
    }else{
        return NO;
    }
    
}

-(void)saveSuccessAlterView{
    UIAlertView *saveSuccess = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [saveSuccess show];
    
}
-(void)saveFailAlterView{
    
    UIAlertView *saveSuccess = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经收藏过!!!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [saveSuccess show];
    
}


@end
