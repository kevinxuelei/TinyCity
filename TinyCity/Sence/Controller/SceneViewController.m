//
//  SceneViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/13.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "SceneViewController.h"
#import "CheckSceneViewController.h"
#import "AroundPersonViewController.h"
#import "LocationViewController.h"
#import "SceneNearByViewController.h"
#import "RouteSearchViewController.h"
#import "AreasView.h"
#import "UserLocation.h"
#import "ListTypeView.h"

#define KFrameW self.view.frame.size.width
#define KFrameH self.view.frame.size.height
#define KColor  [UIColor colorWithRed:242/255.0 green:242/255.0 blue:212/255.0 alpha:1]


@interface SceneViewController ()<BMKMapViewDelegate,BMKPoiSearchDelegate,UITableViewDelegate,UITableViewDataSource,ListTypeViewDelegate,BMKRadarManagerDelegate>

- (IBAction)detailSearchAction:(UIButton *)sender;
- (IBAction)viewSceneAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
- (IBAction)pickCityAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)searchAction:(UIButton *)sender;
- (IBAction)plusAction:(UIButton *)sender;
- (IBAction)decreaseAction:(UIButton *)sender;
@property (nonatomic, strong) BMKPoiSearch *poiSearch;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, assign) NSInteger mapLevel;
@property (nonatomic, strong) AreasView *areasView;
@property (nonatomic, strong) BMKCitySearchOption *citySearchOption;
@property (weak, nonatomic) IBOutlet UITextField *detailSearchLabel;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *decreaseButton;
@property (nonatomic, assign) CLLocationCoordinate2D  backLoction;
@property (nonatomic, assign) BOOL checkFlag;
@property (nonatomic, strong) ListTypeView *listActionView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) BMKRadarManager *radarManager;
@property (nonatomic, assign)BMKRadarNearbySearchOption *SearchOption;
@property (nonatomic, strong)UserLocation *userLocation;

- (IBAction)listAction:(UIButton *)sender;

@end

@implementation SceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabg"]];
    
    self.navigationItem.title = @"附近";
    [self.view bringSubviewToFront:self.plusButton];
    [self.view bringSubviewToFront:self.decreaseButton];
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

    [self loadTableView];
    [self loadListData];
    [self addGestureRecognizeraToMapView];
    [self setup_mapView];
    [self setup_SearchService];
    
    [self loadRadarService];
    
}
-(void)loadRadarService{
    
    
    _radarManager = [BMKRadarManager getRadarManagerInstance];
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
        
    };

    
}

#pragma mark ----------------------------------------------- radarService
-(void)onGetRadarNearbySearchResult:(BMKRadarNearbyResult *)result error:(BMKRadarErrorCode)error{
    
    if (error == BMK_RADAR_NO_ERROR) {
        
        for (BMKRadarNearbyInfo *info in result.infoList) {
            
            BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
            pointAnnotation.coordinate = info.pt;
            [_mapView addAnnotation:pointAnnotation];
            
        }
    }else{
    
    }
    
}


#pragma mark ----------------------------------------------- 设置搜索服务
-(void)setup_SearchService{
    
    BMKPoiSearch *poiSearch = [[BMKPoiSearch alloc] init];
    self.poiSearch = poiSearch;

    //城市内检索，请求发送成功返回YES，请求发送失败返回NO
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageCapacity = 1;
    self.citySearchOption = citySearchOption;
    
    //创建城市选择View
    AreasView *areasView = [[AreasView alloc] initWithFrame:CGRectMake(0, 164, self.view.frame.size.width /3, self.view.frame.size.height)];
    areasView.alpha = 0;
    [self.view addSubview:areasView];
    self.areasView = areasView;
    
    __weak SceneViewController *weakSelf = self;
    areasView.block = ^void(NSString *provinceName,NSString *cityName){
        
        weakSelf.citySearchOption.city = provinceName;
        weakSelf.citySearchOption.keyword = cityName;
        weakSelf.searchTextField.text = [provinceName stringByAppendingString:cityName];
        weakSelf.areasView.alpha = 0;
        
    };
    
}
#pragma mark -----------------------------------------------  设置基本地图
-(void)setup_mapView{
    
    _mapView.showsUserLocation = YES; //是否显示定位图层（即我的位置的小圆点）
    _mapLevel = 16;
    _mapView.zoomLevel = _mapLevel;//地图显示比例
    _mapView.rotateEnabled = NO; //设置是否可以旋转
    _mapView.isSelectedAnnotationViewFront = YES;
    [_mapView setTrafficEnabled:YES];
}

#pragma mark ----------------------------------------------- mapView添加手势
-(void)addGestureRecognizeraToMapView{
    
    UITapGestureRecognizer *tapMap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_mapView addGestureRecognizer:tapMap];
}
-(void)tapAction:(UITapGestureRecognizer *)sender{
    
     self.areasView.alpha = 0;
    [self.view endEditing:YES];
}

#pragma mark --------------------------------------------ListTableView数据
-(void)loadTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 64, 0, 0) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mapListCell"];
}
-(void)loadListData{
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"定位",@"附近",@"路线",nil];
    self.listArray = array;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mapListCell" forIndexPath:indexPath];
    cell.backgroundColor = KColor;
    cell.textLabel.text = self.listArray[indexPath.row];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        LocationViewController *locationVC = [[LocationViewController alloc] init];
        [self.navigationController pushViewController:locationVC animated:YES];
    }else if (indexPath.row == 2){
        RouteSearchViewController *routeSearchVC = [[RouteSearchViewController alloc] init];
        [self.navigationController pushViewController:routeSearchVC animated:YES];
    }else if (indexPath.row == 1){
        
        SceneNearByViewController *NBBV = [[SceneNearByViewController alloc] init];
        [self.navigationController pushViewController:NBBV animated:YES];
    }

}

#pragma mark --------------------------------------地图功能选择的tableview
-(void)buttonAction:(UIButton *)sender{
    
    if (!sender.selected) {
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(KFrameW - 100, 64, 100, 130);
            sender.selected = !sender.selected;
        } completion:nil];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(self.view.frame.size.width, 64, 0, 0);
            sender.selected = !sender.selected;
        } completion:nil];
    }
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [UIView animateWithDuration:1 animations:^{
        self.areasView.alpha = 0;
    } completion:nil];
    
    [self.view endEditing:YES];
}
#pragma mark ----------------------------------------------百度地图代理操作
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    
    self.tableView.frame = CGRectMake(self.view.frame.size.width, 64, 0, 0);
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poiSearch.delegate = self;
    [self.view endEditing:YES];
    [_radarManager addRadarManagerDelegate:self];//添加radar delegate
}
-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _poiSearch.delegate = nil;
    [_radarManager removeRadarManagerDelegate:self];//不用需移除，否则影响内存释放
}
- (void)dealloc {
    
    if (_poiSearch != nil) {
        _poiSearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
    _radarManager = nil;
    [BMKRadarManager releaseRadarManagerInstance];
}
#pragma mark-------------------------------- implement BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}


#pragma mark -----------------------------------------------搜索功能
- (IBAction)searchAction:(UIButton *)sender {
    
    BOOL flag = [_poiSearch poiSearchInCity:self.citySearchOption];
    if(flag)
    {
        //_nextPageButton.enabled = true;
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        //_nextPageButton.enabled = false;
        NSLog(@"城市内检索发送失败");
    }
    [self.view endEditing:YES];
}
#pragma mark implement ------------------------------BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            
            //传给街景界面的location数据
            self.backLoction = poi.pt;
            
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [annotations addObject:item];
        }
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}
-(void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    
    PLLog(@"%@",poiDetailResult);
    
}
#pragma mark ----------------------------------MapLevel
- (IBAction)plusAction:(UIButton *)sender {
    
    _mapLevel--;
    [_mapView setZoomLevel:_mapLevel];
   
}

- (IBAction)decreaseAction:(UIButton *)sender {
    _mapLevel++;
    [_mapView setZoomLevel:_mapLevel];
}
#pragma mark --------------------------  城市选择
- (IBAction)pickCityAction:(UIButton *)sender {
    
   [UIView animateWithDuration:1 animations:^{
            self.areasView.alpha = 1;
                   } completion:nil];
  

}
- (IBAction)detailSearchAction:(UIButton *)sender {
    
    self.citySearchOption.keyword = self.detailSearchLabel.text;
    BOOL flag = [_poiSearch poiSearchInCity:self.citySearchOption];
    self.checkFlag = flag;
   
    if(flag)
    {
        //_nextPageButton.enabled = true;
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        //_nextPageButton.enabled = false;
        NSLog(@"城市内检索发送失败");
    }
    [self.view endEditing:YES];
}

- (IBAction)viewSceneAction:(UIButton *)sender {
    
    if (self.checkFlag) {
        CheckSceneViewController *checkSceneVC = [[CheckSceneViewController alloc] init];
        checkSceneVC.citySearchOption = self.citySearchOption;
        checkSceneVC.locationCoordinate = self.backLoction;
        [self.navigationController pushViewController:checkSceneVC animated:YES];
    }else{
        
        UIAlertView *checkView =[[UIAlertView alloc] initWithTitle:@"提示" message:@"目前该处没有相应街景,请看看别处哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [checkView show];
    }
    
   
}
- (IBAction)listAction:(UIButton *)sender {
    
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:coverView];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.3;
    self.coverView = coverView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeViewAction)];
    [self.coverView addGestureRecognizer:tap];
    
    
    ListTypeView *listView = [[ListTypeView alloc] initWithFrame:CGRectMake(10, 164, self.view.frame.size.width - 20, 130)];
    listView.layer.cornerRadius = 5;
    listView.layer.masksToBounds = YES;
    listView.delegate = self;
    self.listActionView = listView;
    [self.view addSubview:listView];
    [self.view bringSubviewToFront:listView];
    
}
-(void)removeViewAction{
    [self.coverView removeFromSuperview];
    [self.listActionView removeFromSuperview];
}
-(void)ListTypeViewWithMapViewType:(int)count{
    
    switch (count) {
        case 1:
            self.mapView.mapType = BMKMapTypeStandard;
            self.mapView.overlooking = 0;
            break;
            
        case 2:
            self.mapView.buildingsEnabled = YES;
            self.mapView.overlooking = -45;
            break;
        case 3:
            self.mapView.mapType = BMKMapTypeSatellite;
            break;
        default:
            break;
    }
    
}
@end
