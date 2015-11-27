//
//  SceneNearByViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/24.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "SceneNearByViewController.h"
#import "SceneNearByTableViewCell.h"
#import "CheckSceneViewController.h"
#import "UserLocation.h"

@interface SceneNearByViewController ()<BMKMapViewDelegate,BMKPoiSearchDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (nonatomic, assign) CGFloat tableViewY;
@property (nonatomic, strong) BMKPoiSearch *poiSearch;
@property (nonatomic, strong) BMKNearbySearchOption *nearBySearchOption;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UILabel *header;
- (IBAction)searchAction:(UIButton *)sender;

@end

@implementation SceneNearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabg"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadTableView];
    [self addGestureToTableView];
    [self setup_SearchService];
    [self setup_mapView];
    
   
}
-(void)loadTableView{
    
    self.tableViewY = self.tableView.frame.origin.y;
    NSLog(@"%f",self.tableViewY);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    self.tableView.tableHeaderView.height = 0;
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    header.backgroundColor = [UIColor black75PercentColor];
    header.textAlignment = NSTextAlignmentCenter;
    self.header = header;
    
    self.dataArray = [NSArray array];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SceneNearByTableViewCell *cell = [SceneNearByTableViewCell SceneNearByTableViewCellWith:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CheckSceneViewController *checkSceneVC = [[CheckSceneViewController alloc] init];
    //地址是单例获取的地址，但具体搜索的地址是输入框搜索的地址
    BMKPoiInfo *poiInfo = self.dataArray[indexPath.row];
    checkSceneVC.locationCoordinate =poiInfo.pt;
    
    //城市内的搜索
    BMKCitySearchOption  *citySearchOption = [[BMKCitySearchOption alloc] init];
    citySearchOption.city = poiInfo.city;
    citySearchOption.keyword = poiInfo.address;
    checkSceneVC.citySearchOption = citySearchOption;
    
    [self.navigationController pushViewController:checkSceneVC animated:YES];
    
}

#pragma mark ----------------------------------------------- 设置搜索服务
-(void)setup_SearchService{
    
    BMKPoiSearch *poiSearch = [[BMKPoiSearch alloc] init];
    self.poiSearch = poiSearch;

    BMKNearbySearchOption *nearBySearchOption = [[BMKNearbySearchOption alloc]init];
    nearBySearchOption.pageIndex = 0; //第几页
    nearBySearchOption.pageCapacity = 10;  //最多几页
    //CLLocationCoordinate2D location;
    
    //由单例类获取位置信息
    UserLocation *userLocation =  [UserLocation shareInstance];
    [userLocation startLocationService];
    // poi检索点
    userLocation.block = ^(CLLocationCoordinate2D location,NSString *address){
        
        nearBySearchOption.location = location;
    
    };
    
    nearBySearchOption.radius = 1000; //检索范围 m
    self.nearBySearchOption = nearBySearchOption;
    
}
#pragma mark -----------------------------------------------  设置基本地图
-(void)setup_mapView{
    
    _mapView.showsUserLocation = YES; //是否显示定位图层（即我的位置的小圆点）
    _mapView.zoomLevel = 18;//地图显示比例
    _mapView.rotateEnabled = NO; //设置是否可以旋转
    _mapView.isSelectedAnnotationViewFront = YES;
    [_mapView setTrafficEnabled:NO];
}
#pragma mark ----------------------------------------------- mapView添加手势
-(void)addGestureRecognizeraToMapView{
    
    UITapGestureRecognizer *tapMap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMapAction:)];
    [_mapView addGestureRecognizer:tapMap];
}
-(void)tapMapAction:(UITapGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
}

-(void)addGestureToTableView{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.tableView addGestureRecognizer:tapGesture];
}
-(void)tapAction:(UITapGestureRecognizer *)sender{
    
  
    
    if (self.tableView.frame.origin.y ==  self.tableViewY) {
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.tableView.center = CGPointMake(self.view.frame.size.width / 2, self.tableView.centerY - 200);
           
        } completion:^(BOOL finished) {
            self.mapView.zoomLevel = 15;
        }];
        
        PLLog(@"%f",self.tableView.center.x);
        
    }else{
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.tableView.center = CGPointMake(self.view.frame.size.width / 2, self.tableView.centerY + 200);
        } completion:^(BOOL finished) {
            self.mapView.zoomLevel = 18;
        }];
        PLLog(@"%f",self.tableView.center.x);
    }
    
}

- (IBAction)searchAction:(UIButton *)sender {
    
    [self.view bringSubviewToFront:self.tableView];
    self.nearBySearchOption.keyword = self.inputTextField.text;   //检索关键字
    BOOL flag = [_poiSearch poiSearchNearBy:self.nearBySearchOption];

    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    [self.view endEditing:YES];
    
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

#pragma mark implement ------------------------------BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    //tableview数据源
    self.dataArray = result.poiInfoList;
    self.header.text = [NSString stringWithFormat:@"共找到“%@”相关%lu个结果",self.inputTextField.text,(unsigned long)self.dataArray.count];
    self.tableView.tableHeaderView.height = 40;
    self.tableView.tableHeaderView = self.header;
    
    [self.tableView reloadData];
  
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
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

- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    
    
}

#pragma mark ----------------------------------------------百度地图代理操作
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poiSearch.delegate = self;
    [self.view endEditing:YES];
}
-(void)viewWillDisappear:(BOOL)animated {
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _poiSearch.delegate = nil;
}
- (void)dealloc {
    
    if (_poiSearch != nil) {
        _poiSearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}

@end
