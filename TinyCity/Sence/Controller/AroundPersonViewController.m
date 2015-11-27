//
//  AroundPersonViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "AroundPersonViewController.h"
#import "UserLocation.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import "AroundPersonTableViewCell.h"
#import "UserLocation.h"


@interface AroundPersonViewController ()<BMKMapViewDelegate,BMKRadarManagerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) CLLocationCoordinate2D myCoor;
@property (nonatomic, strong) BMKRadarManager *radarManager;
@property (nonatomic, strong) NSMutableArray *nearbyInfos;
@property (nonatomic) NSInteger curPageIndex;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign)CLLocationCoordinate2D myLocation;
@property (nonatomic, assign)BMKRadarNearbySearchOption *SearchOption;
@property (nonatomic, strong)UserLocation *userLocation;

@end

@implementation AroundPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadTableView];
    
    _radarManager = [BMKRadarManager getRadarManagerInstance];
    _curPageIndex = 0;
    _nearbyInfos = [NSMutableArray array];
    
    BMKRadarNearbySearchOption *option = [[BMKRadarNearbySearchOption alloc] init]
    ;
    option.radius = 8000;//检索半径
    option.sortType = BMK_RADAR_SORT_TYPE_DISTANCE_FROM_NEAR_TO_FAR;//排序方式
    
    //由单例类获取位置信息
    UserLocation *userLocation =  [UserLocation shareInstance];
    [userLocation startLocationService];
    self.userLocation = userLocation;
  
    
    userLocation.block = ^(CLLocationCoordinate2D location,NSString *address){
        
        option.centerPt = location;
        
        BOOL flag = [_radarManager getRadarNearbySearchRequest:option];
        if (flag) {
            NSLog(@"get 成功");
        } else {
            NSLog(@"get 失败");
        }
        [self.tableView reloadData];
        
    };
    
}


-(void)loadTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.rowHeight = 70;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AroundPersonTableViewCell *cell  = [AroundPersonTableViewCell AroundPersonTableViewCellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headerLabel = [[UILabel alloc] init];
    NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count];
    headerLabel.text = [NSString stringWithFormat:@"搜索到您附近有%@人",count];
    
    return headerLabel;
}

-(void)onGetRadarNearbySearchResult:(BMKRadarNearbyResult *)result error:(BMKRadarErrorCode)error{
    
    if (error == BMK_RADAR_NO_ERROR) {
        
        self.dataArray = result.infoList;
        [self.tableView reloadData];
    }else{
        
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"sorry,没有搜查到附近人(原因类型：%u)",error] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [errorView show];
    }
    
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_radarManager addRadarManagerDelegate:self];//添加radar delegate
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_radarManager removeRadarManagerDelegate:self];//不用需移除，否则影响内存释放
}
- (void) dealloc {
    
    _radarManager = nil;
    [BMKRadarManager releaseRadarManagerInstance];
}

@end
