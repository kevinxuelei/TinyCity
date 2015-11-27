//
//  UserLocation.m
//  TinyCity
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 DH. All rights reserved.
//

#import "UserLocation.h"

static UserLocation *instance = nil;
@implementation UserLocation

+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[UserLocation alloc] init];
         
        }
    });
    return instance;
}

-(void)startLocationService{
    
    _radarManager = [BMKRadarManager getRadarManagerInstance];
    [_radarManager addRadarManagerDelegate:self];
    [_radarManager startAutoUpload:3];
    
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    [_locationService startUserLocationService];
    
    BMKGeoCodeSearch *geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self;
    self.geocodesearch = geocodesearch;
    
    
    UIAlertView  *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否获取当前位置信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
    
}
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [_locationService stopUserLocationService];
    }else{
       
       self.block(_locationCoordinate,self.address);
        //5s后停止定位
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_locationService stopUserLocationService];
            [_radarManager stopAutoUpload];

        });
    }
}

#pragma mark - BMKRadarManagerDelegate
-(BMKRadarUploadInfo *)getRadarAutoUploadInfo{
    
    BMKRadarUploadInfo *info = [[BMKRadarUploadInfo alloc] init];
    info.extInfo = @"您附近的人";
    info.pt = _locationCoordinate;
    
    return info;
}
/**
 *返回雷达 上传结果
 *@param error 错误号，@see BMKRadarErrorCode
 */
- (void)onGetRadarUploadResult:(BMKRadarErrorCode) error {
  
    if (error == BMK_RADAR_NO_ERROR) {
//      PLLog(@"成功上传位置信息");
    }else{

//        UIAlertView  *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"上传当前位置信息失败(原因类型：%u)",error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
    }
}

#pragma mark - BMKLocationServiceDelegate

- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    // 初始化反地址编码选项（数据模型）
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    // 将获得的经纬度的数据传到反地址编码模型
    option.reverseGeoPoint = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    // 调用反地址编码方法，让其在代理方法中输出
    _geocodesearch.delegate = self;
    [_geocodesearch reverseGeoCode:option];
    
    _locationCoordinate.latitude = userLocation.location.coordinate.latitude;
    _locationCoordinate.longitude = userLocation.location.coordinate.longitude;
    
    //mapView 地图截图
    NSString *latitudeAndLongitude = [NSString stringWithFormat:@"%f,%f&zoom=16",_locationCoordinate.longitude,_locationCoordinate.latitude];
    self.locationImage = [kImageUrl stringByAppendingString:latitudeAndLongitude];
    
    // 街景地图
    NSString *viewUrl = [NSString stringWithFormat:@"%f,%f&fov=180&ak=KorQ39GXFfuwkwjIyMf0dMxF",self.locationCoordinate.longitude,self.locationCoordinate.latitude];
    self.viewImage = [KViewImageUrl stringByAppendingString:viewUrl];
    
}

- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

#pragma mark ---------------------------------------代理方法返回反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result) {
        
      NSString *address = [NSString stringWithFormat:@"%@%@", result.address, result.addressDetail.streetNumber];
      self.address = address;
        PLLog(@"%@",address);
       
    }else{
        
    }
}


-(void)dealloc{
    
    _radarManager = nil;
    [BMKRadarManager releaseRadarManagerInstance];
    _locationService.delegate = nil;
    _locationService = nil;
    _geocodesearch.delegate = nil;
    
}

@end
