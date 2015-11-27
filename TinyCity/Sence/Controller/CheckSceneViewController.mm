//
//  CheckSceneViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "CheckSceneViewController.h"
#import "BaiduPanoramaView.h"
#import "BaiduPanoUtils.h"
#import "BaiduPanoDataFetcher.h"
#import "BaiduPoiPanoData.h"
#import "BaiduLocationPanoData.h"
//百度全景图请求服务网址
#define KViewImageUrl @"http://api.map.baidu.com/panorama?width=512&height=256&location="

@interface CheckSceneViewController ()<BaiduPanoramaViewDelegate,BMKMapViewDelegate,BMKPoiSearchDelegate>

@property (nonatomic, strong) BaiduPanoramaView *panoramaView;
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKPoiSearch *poiSearch;
@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UIButton *decreaseButton;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, assign) int mapLevel;

@end

@implementation CheckSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#warning message ----是否分享全景
    self.navigationItem.title = @"街景";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(shareViewImage:)];
    
    [self loadMapView];
    [self loadSceneView];
    [self loadSearchService];
    
    self.plusButton = [self creatButtonWithFrame: CGRectMake(ViewWidth - 30, ViewHeight - 100, 30, 35) image:[UIImage imageNamed:@"navi_view_zoomout_normal"] action:@selector(plusAction:)];
    self.decreaseButton = [self creatButtonWithFrame:CGRectMake(ViewWidth - 30, ViewHeight - 135, 30, 35) image:[UIImage imageNamed:@"navi_view_zoomin_normal"] action:@selector(decreaseAction:)];

}

-(void)shareViewImage:(UIBarButtonItem *)sender{
    
      NSString *latitudeAndLongitude = [NSString stringWithFormat:@"%f,%f&fov=180&ak=KorQ39GXFfuwkwjIyMf0dMxF",self.locationCoordinate.longitude,self.locationCoordinate.latitude];
      NSString *viewImageUrl = [KViewImageUrl stringByAppendingString:latitudeAndLongitude];
    
}

-(void)plusAction:(UIButton *)sender{
    
    _mapLevel--;
    [_mapView setZoomLevel:_mapLevel];
}
-(void)decreaseAction:(UIButton *)sender{
    _mapLevel++;
    [_mapView setZoomLevel:_mapLevel];
}

-(void)loadSearchService{
    
    BMKPoiSearch *poiSearch = [[BMKPoiSearch alloc] init];
    self.poiSearch = poiSearch;

    BOOL flag = [_poiSearch poiSearchInCity:self.citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }

}
-(void)loadSceneView{
    
    // key 为在百度LBS平台上统一申请的接入密钥ak 字符串
    CGRect panaormaViewFrame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height / 3) * 2);
    self.panoramaView = [[BaiduPanoramaView alloc] initWithFrame: panaormaViewFrame key:@"V06QcDCnV5g7BGpQNvDbgvPN"];
    // 为全景设定一个代理
    [self.view addSubview:self.panoramaView];
    // 设定全景的清晰度， 默认为middle
    [self.panoramaView setPanoramaImageLevel:ImageDefinitionMiddle];
    // 设定全景的pid， 这是指定显示某地的全景，也可以通过百度坐标进行显示全景
   // [self.panoramaView setPanoramaWithPid:@"01002200001309101607372275K"];
    [self.panoramaView setPanoramaWithLon:self.locationCoordinate.longitude lat:self.locationCoordinate.latitude];
}
-(void)loadMapView{
    
    CGRect mapViewFrame = CGRectMake(0, (self.view.frame.size.height / 3) * 2, self.view.frame.size.width, (self.view.frame.size.height /3) * 1);
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:mapViewFrame];
    [self.view addSubview:mapView];
    self.mapView = mapView;
    _mapView.showsUserLocation = YES; //是否显示定位图层（即我的位置的小圆点）
    _mapLevel = 18;
    _mapView.zoomLevel = _mapLevel;//地图显示比例
    _mapView.rotateEnabled = NO; //设置是否可以旋转
    _mapView.isSelectedAnnotationViewFront = YES;
    _mapView.mapType = BMKMapTypeSatellite;
    [_mapView setTrafficEnabled:YES];
}

#pragma mark--------------------------------- implement BMKMapViewDelegate

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
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [annotations addObject:item];
        }
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        PLLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
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

#pragma mark ----------------------------------------百度地图代理的操作
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.panoramaView.delegate = nil;
   _mapView.delegate = nil; // 不用时，置nil
    _poiSearch.delegate = nil;
    
}

- (void)dealloc {
    
    [self.panoramaView removeFromSuperview];
    self.panoramaView = nil;
    if (_mapView) {
        _mapView = nil;
    }
    if (_poiSearch != nil) {
        _poiSearch = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _panoramaView.delegate = self;
    _poiSearch.delegate = self;
    
}

//创建button
-(UIButton *)creatButtonWithFrame:(CGRect)frame image:(UIImage *)image action:(SEL)action{
    
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [Button setImage:image forState:UIControlStateNormal];
    [self.view insertSubview:Button aboveSubview:self.mapView];
    Button.frame  = frame;
    [self.view addSubview:Button];
    [Button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return Button;
}


@end
