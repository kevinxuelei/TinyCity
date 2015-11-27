//
//  UserLocation.h
//  TinyCity
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 DH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#define kImageUrl @"http://api.map.baidu.com/staticimage?width=400&height=300&center="
#define KViewImageUrl @"http://api.map.baidu.com/panorama?width=512&height=256&location="


typedef void(^LocatonBlock)(CLLocationCoordinate2D,NSString *);

@interface UserLocation : NSObject<CLLocationManagerDelegate,BMKLocationServiceDelegate, BMKRadarManagerDelegate,UIAlertViewDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong)BMKLocationService *locationService;
@property (nonatomic, strong)BMKRadarManager *radarManager;
@property (nonatomic, assign)CLLocationCoordinate2D locationCoordinate;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, copy) LocatonBlock block;
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
//mapView
@property (nonatomic, strong) NSString *locationImage;
//街景图片
@property (nonatomic, strong) NSString *viewImage;

+(instancetype)shareInstance;
-(void)startLocationService;

@end
