//
//  LocationViewController.m
//  TinyCity
//
//  Created by lanou3g on 15/11/14.
//  Copyright (c) 2015年 DH. All rights reserved.
//

#import "LocationViewController.h"
#import "CheckSceneViewController.h"


@interface LocationViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

- (IBAction)locationAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *checkSceneButton;
@property (strong, nonatomic) IBOutlet UILabel *showLocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *compassImage;
@property (nonatomic, assign) CLLocationCoordinate2D  backLoction;
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
@property (nonatomic, strong) BMKCitySearchOption *citySO;
- (IBAction)checkSceneAction:(UIButton *)sender;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_background"]];
    [self setup_locationService];
    
}
#pragma mark -----------------------------------------设置定位服务
-(void)setup_locationService{
    
    BMKLocationService *locationService = [[BMKLocationService alloc] init];
    self.locationService = locationService;
    
   /// 设定最小更新角度。默认为1度，设定为kCLHeadingFilterNone会提示任何角度改变。
    self.locationService.headingFilter = 0.1;
    
    BMKGeoCodeSearch *geocodesearch = [[BMKGeoCodeSearch alloc] init];
    self.geocodesearch = geocodesearch;
    
    BMKCitySearchOption *citySearchOP = [[BMKCitySearchOption alloc] init];
    self.citySO = citySearchOP;
    
}


#pragma mark -----------------------------------------开始定位
- (IBAction)locationAction:(UIButton *)sender {
    
    if (!sender.selected) {
        
        [_locationService startUserLocationService];
        sender.selected = !sender.selected;
        
    }else{
        
        [_locationService stopUserLocationService];
        sender.selected = !sender.selected;
    }

}


/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    PLLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    CGFloat heading = -1.0f * M_PI * userLocation.heading.magneticHeading / 180.0f;
    self.compassImage.transform = CGAffineTransformMakeRotation(heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
   
    // 初始化反地址编码选项（数据模型）
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    // 将获得的经纬度的数据传到反地址编码模型
    option.reverseGeoPoint = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    // 调用反地址编码方法，让其在代理方法中输出
    [_geocodesearch reverseGeoCode:option];
    
    self.longitudeLabel.text =  [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    self.latitudeLabel.text =  [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    self.backLoction = userLocation.location.coordinate;
}

#pragma mark ---------------------------------------代理方法返回反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result) {
        
        self.showLocationLabel.text = [NSString stringWithFormat:@"%@%@", result.address, result.addressDetail.streetNumber];
        self.citySO.city = result.addressDetail.city;
        self.citySO.keyword = result.addressDetail.streetName;
        
    }else{
        
    }
}
/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    PLLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    PLLog(@"%@",error);
}

#pragma mark ----------------------------------------百度地图代理的操作
-(void)viewWillAppear:(BOOL)animated {
    
    
    _locationService.delegate = self;
    _geocodesearch.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated {
    _locationService.delegate = nil;
}
- (void)dealloc {
    
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }

   
    if (_locationService) {
        _locationService = nil;
    }
}

//查看街景
- (IBAction)checkSceneAction:(UIButton *)sender {
    
    CheckSceneViewController *checkSceneVC = [[CheckSceneViewController alloc] init];
    checkSceneVC.locationCoordinate = self.backLoction;
    checkSceneVC.citySearchOption = self.citySO;
    [self.navigationController pushViewController:checkSceneVC animated:YES];
    
}
@end
