//
//  HomeController.m
//  DouDouChong
//
//  Created by PC on 2018/3/1.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "HomeController.h"
#import "DEMONavigationController.h"
// 地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
// 定位 围栏
#import <AMapLocationKit/AMapLocationKit.h>



@interface HomeController ()<AMapGeoFenceManagerDelegate,MAMapViewDelegate>

/** 地理围栏管理manager */
@property(nonatomic,strong) AMapGeoFenceManager * geoFenceManager;

/** 地图中心 大头针 */
@property (nonatomic,strong) MAPointAnnotation * pointAnnotation;

/**  */
@property (nonatomic, strong) MAAnimatedAnnotation *animatedCarAnnotation;

@end

@implementation HomeController{

    MAMapView * _mapView;
}

-(MAPointAnnotation *)pointAnnotation{

    if (_pointAnnotation == nil) {
        _pointAnnotation = [[MAPointAnnotation alloc] init];
       // pointAnnotation.coordinate = mapView.centerCoordinate;
        _pointAnnotation.title = @"搜索附近车辆";
        _pointAnnotation.subtitle = @"阜通东大街6号";
        
        _pointAnnotation.lockedToScreen = YES;
        _pointAnnotation.lockedScreenPoint = CGPointMake(0.5, 0.5);
        [_mapView addAnnotation:_pointAnnotation];
    }
    return _pointAnnotation;
}


-(AMapGeoFenceManager *)geoFenceManager{

    if (_geoFenceManager == nil) {
        self.geoFenceManager = [[AMapGeoFenceManager alloc] init];
        self.geoFenceManager.delegate = self;
        self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed; //设置希望侦测的围栏触发行为，默认是侦测用户进入围栏的行为，即AMapGeoFenceActiveActionInside，这边设置为进入，离开，停留（在围栏内10分钟以上），都触发回调
       // self.geoFenceManager.allowsBackgroundLocationUpdates = YES;  //允许后台定位
    }
    return _geoFenceManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home Controller";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(DEMONavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"Balloon"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    ///========================== 高德地图 ==========================\\\
    
    [AMapServices sharedServices].enableHTTPS = YES;
    // 显示地图
    [AMapServices sharedServices].apiKey =@"3957b4b7f09cb3bec702689444d036f2";
    
    
    ///-----初始化地图----
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
   // 地图缩放
    _mapView.zoomEnabled = YES;
    // 地图旋转
    _mapView.rotateEnabled = NO;
    // 地图倾斜
    _mapView.rotateCameraEnabled = NO;
    // 显示比例
    _mapView.zoomLevel = 16;
    
    // 空间 ： logo  指南针  比例
    
    
    // 大头针
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(36.50001, 118.499991018);
    pointAnnotation.title = @"方恒国际1";
    pointAnnotation.subtitle = @"阜通东大街6号";
    pointAnnotation.lockedToScreen = YES;
    pointAnnotation.lockedScreenPoint = CGPointMake(0.8, 0.5);
   // _pointAnnotation = pointAnnotation;
    
    [_mapView addAnnotation:pointAnnotation];
    
   // MAAnimatedAnnotation * animatedA = [[MAAnimatedAnnotation alloc] init];
    
    //===============  围栏
       // [self.geoFenceManager addDistrictRegionForMonitoringWithDistrictName:@"临朐县" customID:nil];
   // [self.geoFenceManager addKeywordPOIRegionForMonitoringWithKeyword:@"北京大学" POIType:@"高等院校" city:@"北京" size:20 customID:@"poi_1"];
  //  CLLocationCoordinate2D  cl = CLLocationCoordinate2DMake(36.50001, 118.499991);
  // MAPolygon * pp = [self showPolygonInMap:&cl count:5];
  //  [_mapView  addOverlay:pp];
  //  [self showCircleInMap:cl radius:1000];
    
    UIButton * wlBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kHeight-60, kWidth, 60)];
    [wlBtn setTitle:@"添加围栏" forState:UIControlStateNormal];
    wlBtn.backgroundColor = [UIColor magentaColor];
    [wlBtn addTarget:self action:@selector(wlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wlBtn];
    
    
    // 围栏
    [self wlAction];
    
    // 显示大头针弹窗
    [_mapView selectAnnotation:self.pointAnnotation animated:YES];
    
    // 动画点
    [self addCarAnnotationWithCoordinate:CLLocationCoordinate2DMake(36.50001, 118.499991018)];
    
}
#pragma mark = 设置动画大头针
- (void) addCarAnnotationWithCoordinate:(CLLocationCoordinate2D) coordinate {

    
    
    
 //   self.animatedCarAnnotation = [[MAAnimatedAnnotation alloc] init];
    
   // CLLocationCoordinate2D coornate = CLLocationCoordinate2DMake(36.50001, 118.499991018);
   // self.animatedCarAnnotation addMoveAnimationWithKeyCoordinates:&coordinate count:10 withDuration:0.5 withName:<#(NSString *)#> completeCallback:<#^(BOOL isFinished)completeCallback#> stepCallback:<#^(MAAnnotationMoveAnimation *currentAni)stepCallback#>
}

- (void) wlAction{

    
    NSInteger count = 4;
    CLLocationCoordinate2D *coorArr = malloc(sizeof(CLLocationCoordinate2D) * count);
    coorArr[0] = CLLocationCoordinate2DMake(36.433921, 118.472927);     //平安里地铁站
    coorArr[1] = CLLocationCoordinate2DMake(36.447261, 118.576532);     //西单地铁站
    coorArr[2] = CLLocationCoordinate2DMake(36.500611, 118.588161);     //崇文门地铁站
    coorArr[3] = CLLocationCoordinate2DMake(36.541949, 118.475497);     //东直门地铁站
    
    //  [self doClear];
    [self.geoFenceManager addPolygonRegionForMonitoringWithCoordinates:coorArr count:count customID:@"polygon_1"];
    
    free(coorArr);
    coorArr = NULL;
    
   // [self.geoFenceManager addDistrictRegionForMonitoringWithDistrictName:@"临朐县" customID:nil];

    
}


//地图上显示多边形
- (MAPolygon *)showPolygonInMap:(CLLocationCoordinate2D *)coordinates count:(NSInteger)count {
    MAPolygon *polygonOverlay = [MAPolygon polygonWithCoordinates:coordinates count:count];
    [_mapView addOverlay:polygonOverlay];
    return polygonOverlay;
}

//添加地理围栏对应的Overlay，方便查看。地图上显示圆
- (MACircle *)showCircleInMap:(CLLocationCoordinate2D )coordinate radius:(NSInteger)radius {
    
    MACircle *circleOverlay = [MACircle circleWithCenterCoordinate:coordinate radius:radius];
   // circleOverlay
    [_mapView addOverlay:circleOverlay];
    return circleOverlay;
}

#pragma mark - 围栏回调
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"创建失败 %@",error);
    } else {
      //  NSLog(@"创建成功");
        
        
        AMapGeoFencePolygonRegion *polygonRegion = (AMapGeoFencePolygonRegion *)regions.firstObject;
        MAPolygon *polygonOverlay = [self showPolygonInMap:polygonRegion.coordinates count:polygonRegion.count];
        [_mapView setVisibleMapRect:polygonOverlay.boundingMapRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
         
        
        /// 行政区划
        /*
        if (error) {
            NSLog(@"======== district1 error %@",error);
        } else {
            
            for (AMapGeoFenceDistrictRegion *region in regions) {
                
                for (NSArray *arealocation in region.polylinePoints) {
                    
                    CLLocationCoordinate2D *coorArr = malloc(sizeof(CLLocationCoordinate2D) * arealocation.count);
                    
                    for (int i = 0; i < arealocation.count; i++) {
                        AMapLocationPoint *point = [arealocation objectAtIndex:i];
                        coorArr[i] = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                    }
                    
                    MAPolygon *polygonOverlay = [self showPolygonInMap:coorArr count:arealocation.count];
                    [_mapView setVisibleMapRect:polygonOverlay.boundingMapRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
                    
                    free(coorArr);
                    coorArr = NULL;
                    
                }
                
            }
        }
*/
        
        
    }
}


#pragma mark - MAMapView的代理方法
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
   // self.userLocation = userLocation.location;
}

-(void)mapViewRegionChanged:(MAMapView *)mapView{

    
   // NSLog(@"地图中心左边:%@",);
   // NSLog(@"地图中心左边:%@",NSStringFromCGPoint(mapView.centerCoordinate));
    NSLog(@"地图中心经度：%f --- 地图中心纬度：%f",mapView.centerCoordinate.longitude,mapView.centerCoordinate.latitude);
    
   // NSLog(@"*********%f --- %f",self.pointAnnotation.coordinate.longitude,self.pointAnnotation.coordinate.latitude);
    
    // 大头针
  //  MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        self.pointAnnotation.coordinate = mapView.centerCoordinate;
  //  pointAnnotation.title = @"方恒国际";
  //  pointAnnotation.subtitle = @"阜通东大街6号";
    
        [_mapView addAnnotation:self.pointAnnotation];

}

#pragma mark = 地图生成覆盖物
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolygon class]]) {
        MAPolygonRenderer *polylineRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        // 围栏的边缘线宽度
        polylineRenderer.lineWidth = 2.0f;
        // 设置围栏区域的透明度
        polylineRenderer.alpha = 0.3f;
        // 围栏的边缘线颜色
        polylineRenderer.strokeColor = [UIColor cyanColor];
        // 围栏的填充颜色
        polylineRenderer.fillColor   = [UIColor greenColor];
        
        return polylineRenderer;
    } else if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth = 3.0f;
        circleRenderer.strokeColor = [UIColor purpleColor];
        
        return circleRenderer;
    }
    return nil;
}
#pragma mark = 地图大头针样式设置
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {

    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        MAPointAnnotation * tmpPoint = (MAPointAnnotation *)annotation;
        if ([tmpPoint.title isEqualToString:@"搜索附近车辆"]) {
            static NSString *pointReuseIndetifier = @"mapCenter";
            MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil) {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
            // 是否显示自带气泡  YES
            annotationView.canShowCallout               = NO;
            // 大头针掉落效果
            annotationView.animatesDrop                 = NO;
            annotationView.draggable                    = NO;
            annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.image = [UIImage imageNamed:@"map_pin_location_img"];
            annotationView.canShowCallout = YES;
            // annotationView.selected       = YES;
            [annotationView setSelected:YES animated:YES];
            /// 自定义大头针的点击弹出视图
            
             UIView * iView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
             iView.backgroundColor = [UIColor redColor];
             // 自定义弹出
             MACustomCalloutView * maView = [[MACustomCalloutView alloc] initWithCustomView:iView];
             annotationView.customCalloutView = maView;
            
            return annotationView;
        }else{
            static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
            MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annotationView == nil) {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            }
            
            // 是否显示自带气泡  YES
            annotationView.canShowCallout               = NO;
            // 大头针掉落效果
            annotationView.animatesDrop                 = NO;
            annotationView.draggable                    = NO;
            annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.image = [UIImage imageNamed:@"main_car_map_img"];
            annotationView.canShowCallout = YES;
            // annotationView.selected       = YES;
            [annotationView setSelected:YES animated:YES];
            return annotationView;
        }
        
        // 自定义大头针的点击弹出视图
        /*
        UIView * iView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        iView.backgroundColor = [UIColor redColor];
        // 自定义弹出
        MACustomCalloutView * maView = [[MACustomCalloutView alloc] initWithCustomView:iView];
        annotationView.customCalloutView = maView;
        */
        
    }
  
    
    return nil;
}


@end
