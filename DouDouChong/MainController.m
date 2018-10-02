//
//  MainController.m
//  DouDouChong
//
//  Created by PC on 2018/3/5.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "MainController.h"
// 地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
// 定位 围栏
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "AreaController.h"
#import "SlideView.h"
#import "MANaviAnnotation.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"
#import "NearByController.h" // 附近车辆
#import <MAMapKit/MAMapView.h>
#import "PickedCarView.h"
#import "LoginViewController.h"
#import "WSUtil.h"
#import "SettingViewController.h"
#import "XCViewController.h"
#import "WalletViewController.h"
#import "ReserveInfoController.h"
#import "UsingCarController.h"
#import "PayBillController.h"
#import "PayCompleteController.h"
#import "PopCenterView.h"
#import "SVProgressHUD.h"
#import "User.h"
#import "NetUtil.h"
#import "CertifyController.h"
#import "UpDespositController.h"
#import "SGScanningQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "RuleController.h"
#import "SystemMsgController.h"
#import "UserInfoController.h"
#import "ActivityController.h"
#import "HelpController.h"
#import "ShareController.h"
#import "MapTool.h" // 调用导航
#import "ChargeView.h"
#import "NoPayController.h"


#define plineColor [UIColor colorWithRed:38/255.0 green:126/255.0 blue:239/255.0 alpha:1]

@interface MainController ()<AMapGeoFenceManagerDelegate,MAMapViewDelegate,AMapSearchDelegate,SlideProtocol,CarInfoProtocol,AMapLocationManagerDelegate,ChargeProtocool,NearProtocol>
/** 侧边 */
@property (nonatomic,strong) SlideView * slideView;
/** 盖板 */
@property (nonatomic,strong) UIButton * coverBtn;

/** 地理围栏管理manager */
@property(nonatomic,strong) AMapGeoFenceManager * geoFenceManager;

/** Search API */
@property (nonatomic,strong) AMapSearchAPI * searchApi;
/** 路线 */
@property (nonatomic,strong) AMapRoute * planRoute;
/** 展示路线 */
@property (nonatomic,strong) MANaviRoute * naviRoute;
/** 路线折线 */
@property (nonatomic,strong) MAPolyline * currentLine;

/** 地图中心 大头针 */
@property (nonatomic,strong) MAPointAnnotation * pointAnnotation;

/**  */
@property (nonatomic, strong) MAAnimatedAnnotation *animatedCarAnnotation;

/** mapView */
@property (nonatomic,strong) MAMapView * mapView;

@property (weak, nonatomic) IBOutlet UIView *threeBackView;

@property (nonatomic,strong) UIView * moveView;
@property (weak, nonatomic) IBOutlet UIButton *fenshiBtn;
@property (weak, nonatomic) IBOutlet UIButton *duanzuBtn;
@property (weak, nonatomic) IBOutlet UIButton *chongdianBtn;
/** 提示附近可用车的数量 */
@property (nonatomic,strong) UIButton * aviableCar;
/** 提示登录，认证蓝条 */
@property (nonatomic,strong) UIButton * tipBtn;

@property (nonatomic,assign) CLLocationCoordinate2D startCoordinate;
@property (nonatomic,assign) CLLocationCoordinate2D destinationCoordinate;
// 地图中心标记
@property (nonatomic,strong) MAAnnotationView * centerAnnoView;
// 转圈
@property (nonatomic,strong) UIView * bView;
// 文字
@property (nonatomic,strong) UIView * wView;
// 选中的车辆信息
@property (nonatomic,strong) PickedCarView * pickedCarView;
/** 顶部显示车辆位置和导航按钮 */
@property (nonatomic,strong) UIView * carPositionView;
/** 显示车辆价格 */
@property (nonatomic,strong) PopCenterView * popCenterView;

/** 位置管理 */
@property (nonatomic,strong) AMapLocationManager * locationManager;
/** 逆地理编码 */
@property (nonatomic,strong) AMapReGeocodeSearchRequest * reGEOUtil;
@property (nonatomic,strong) AMapSearchAPI * searchAPI;
/** 预定controller */
@property (nonatomic,strong) ReserveInfoController * reserveVC;
/** 一键用车时的最近的车辆 */
@property (nonatomic,strong) MAPinAnnotationView * nearestCarView;
/** 记录最近距离 */
@property (nonatomic,assign) CGFloat nearestDistance;
/**  */
@property (nonatomic,strong) id<MAAnnotation>   nearestAnnotation;

/** 记录centerAnnoView */
@property (nonatomic,strong) id<MAAnnotation> centerAnnotation;
/** 充电桩视图 */
@property (nonatomic,strong) ChargeView * chargeView;
/** 一键用车按钮 */
@property (nonatomic,strong) UIButton * useCar;
/** 扫码充电按钮 */
@property (nonatomic,strong) UIButton * scanCharge;
@end

#define wwBlue [UIColor colorWithRed:38/255.0 green:149/255.0 blue:241/255.0 alpha:1]

@implementation MainController{

    /** 显示选中车辆的位置信息  */
    UILabel * _carPositionLab;
    
    /** 显示车辆距离和步行时间 */
    UILabel * _disLab;
    
    /** 当前显示的车辆数组 */
    NSArray * _annViewArr;
    /** 上一次移动地图显示的车辆数组 */
    NSArray * _lastArr;
    /** 附近的可用车辆 */
    NearByController  * _nearVC;
    /** 当前显示的车辆完整信息数组 */
    NSMutableArray * _currentCarInfoArr;
}
-(ReserveInfoController *)reserveVC{

    if (_reserveVC == nil) {
        _reserveVC = [[ReserveInfoController alloc] init];
    }
    return _reserveVC;
}
-(UIView *)carPositionView{

    if (_carPositionView == nil) {
        _carPositionView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, kWidth-20, 80)];
        _carPositionView.backgroundColor = [UIColor whiteColor];
        _carPositionView.layer.cornerRadius = 10;
        
        _carPositionLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kWidth-20-10-70, 50)];
        _carPositionLab.numberOfLines = 2;
        _carPositionLab.font = [UIFont systemFontOfSize:12];
        _carPositionLab.textColor = [UIColor darkTextColor];
        _carPositionLab.text  = @"山东省潍坊市临朐县城关街道全福元中央商务区";
        _carPositionLab.adjustsFontSizeToFitWidth   = YES;
      //  _carPositionLab.backgroundColor = [UIColor redColor];
        [_carPositionView addSubview:_carPositionLab];
        
        _disLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_carPositionLab.frame), kWidth-100, 20)];
        _disLab.textColor = [UIColor grayColor];
        _disLab.font = [UIFont systemFontOfSize:11];
        _disLab.textAlignment = NSTextAlignmentCenter;
        _disLab.text  =  @"距离123米步行1分钟";
        _disLab.adjustsFontSizeToFitWidth = YES;
      //  _disLab.backgroundColor = [UIColor cyanColor];
        [_carPositionView addSubview:_disLab];
        
        // 竖线
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_carPositionLab.frame)+5, 10, 1, 50)];
        line.backgroundColor = [UIColor grayColor];
        [_carPositionView addSubview:line];
        
        
        UIButton * navBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)+5, 5, 50, 70)];
        [_carPositionView addSubview:navBtn];
        [navBtn addTarget:self action:@selector(navAction:) forControlEvents:UIControlEventTouchUpInside];
        //导航
        UIImageView * navImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
        navImg.image = [UIImage imageNamed:@"main_navi_img"];
       // navImg.backgroundColor = [UIColor redColor];
        [navBtn addSubview:navImg];
        UILabel * navLab = [[UILabel alloc] initWithFrame:CGRectMake(navImg.frame.origin.x, CGRectGetMaxY(navImg.frame), 30, 20)];
        navLab.text = @"导航";
        navLab.font = [UIFont boldSystemFontOfSize:13];
        navLab.textAlignment = NSTextAlignmentCenter;
         navLab.textColor = [UIColor greenColor];
       // navLab.backgroundColor = [UIColor magentaColor];
        [navBtn addSubview:navLab];
    }
    return _carPositionView;
    
}

-(MAPointAnnotation *)pointAnnotation{
    if (_pointAnnotation == nil) {
        _pointAnnotation = [[MAPointAnnotation alloc] init];
        // pointAnnotation.coordinate = mapView.centerCoordinate;
        _pointAnnotation.title = @"搜索附近车辆";
        _pointAnnotation.subtitle = @"阜通东大街6号";
        
        _pointAnnotation.lockedToScreen = YES;
        _pointAnnotation.lockedScreenPoint = CGPointMake(0.5, 0.5);
      //  [_mapView addAnnotation:_pointAnnotation];
    }
    return _pointAnnotation;
}
// 移动的蓝色滑块
-(UIView *)moveView{

    if (_moveView == nil) {
        _moveView = [[UIView alloc] initWithFrame:CGRectMake(self.fenshiBtn.frame.origin.x+(kWidth*0.2-50)/2.0, 41, 50, 3)];
        _moveView.backgroundColor = [UIColor blueColor];
        _moveView.layer.cornerRadius = 1.5;
    }
    return _moveView;
}

-(UIButton *)coverBtn{

    if (_coverBtn == nil) {
        _coverBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _coverBtn.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
        [_coverBtn addTarget:self action:@selector(coverOver:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
    
}
#pragma mark = searchAPI
-(AMapSearchAPI *)searchApi{

    if (_searchApi == nil) {
        _searchApi  = [[AMapSearchAPI alloc] init];
        _searchApi.delegate = self;
    }
    return _searchApi;
}
#pragma mark 创建围栏管理类
-(AMapGeoFenceManager *)geoFenceManager{
    
    if (_geoFenceManager == nil) {
        self.geoFenceManager = [[AMapGeoFenceManager alloc] init];
        self.geoFenceManager.delegate = self;
        self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed; //设置希望侦测的围栏触发行为，默认是侦测用户进入围栏的行为，即AMapGeoFenceActiveActionInside，这边设置为进入，离开，停留（在围栏内10分钟以上），都触发回调
        // self.geoFenceManager.allowsBackgroundLocationUpdates = YES;  //允许后台定位
    }
    return _geoFenceManager;
}
#pragma mark 创建地图
-(MAMapView *)mapView{

    if (_mapView == nil) {
        
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, (44), kWidth, kHeight-44)];
        _mapView.backgroundColor = [UIColor whiteColor];
        _mapView.delegate = self;
       // [self.view addSubview:_mapView];
        
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
        
        /// 一次添加多个标注
       // [_mapView addAnnotations:nil];
    }
    return _mapView;
}
-(MAAnnotationView *)centerAnnoView{

    if (_centerAnnoView == nil) {
        _centerAnnoView = [[MAAnnotationView alloc] init];
    }
    return _centerAnnoView;
}
// 显示可用车辆数量
-(UIButton *)aviableCar{
    if (_aviableCar == nil) {
        _aviableCar = [[UIButton alloc] initWithFrame:CGRectMake(-15, 50, kWidth/2.0, 30)];
        _aviableCar.backgroundColor = themeColor;
        _aviableCar.layer.cornerRadius = 15;
        
        [_aviableCar setImage:[UIImage imageNamed:@"white_rightrow_img"] forState:UIControlStateNormal];
        _aviableCar.titleLabel.font = [UIFont systemFontOfSize:13];
        
//        UIImage * img = [UIImage imageNamed:@"main_car_num_bg"];
//        _aviableCar.layer.contents = (id)img.CGImage;
        
        [_aviableCar setTitle:@"附近12辆可用车辆" forState:UIControlStateNormal];
        [_aviableCar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_aviableCar setImageEdgeInsets:UIEdgeInsetsMake(0, (kWidth/2.0-15), 0, 0)];
        [_aviableCar setContentEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        [_aviableCar addTarget:self action:@selector(aviliableAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _aviableCar;
}
// 提示用户登录、认证的蓝条
-(UIButton *)tipBtn{
    if (_tipBtn == nil) {
        _tipBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWidth, 36)];
        _tipBtn.backgroundColor = themeColor;
        [_tipBtn setTitle:@"您尚未登录，登录请点击前往" forState:UIControlStateNormal];
        _tipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_tipBtn setImage:[UIImage imageNamed:@"white_rightrow_img"] forState:UIControlStateNormal];
        [_tipBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_tipBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kWidth-60, 0, 0)];
        [_tipBtn addTarget:self action:@selector(showLog:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _tipBtn;
}

#pragma mark - ========== viewDidload =====================
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // > 附近的车辆
    _nearVC = [[NearByController alloc] init];
    _nearVC.nearDelegate = self;
    
    self.annoContentFlag = 0;
    self.nearestDistance = 0;
    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;
    
    self.reGEOUtil = [[AMapReGeocodeSearchRequest alloc] init];
    
  //  NSLog(@"$$$$$$$$%ld",self.lcMapState);
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    
    [self.view addSubview:self.mapView];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.backgroundColor = [UIColor redColor];
    self.slideView = [[SlideView alloc] initWithFrame:CGRectMake(-kWidth, 0, kWidth*0.6, kHeight)];
    self.slideView.slideDelegate = self;
    self.slideView.backgroundColor = [UIColor whiteColor];
    UIWindow * window = [UIApplication  sharedApplication].keyWindow;
    [window addSubview:self.slideView];
    
    // 配置高德
    //  [self initGaoDe];
    [self.threeBackView addSubview:self.moveView];

    [self.mapView addAnnotation:self.pointAnnotation];
    [self.mapView selectAnnotation:self.pointAnnotation animated:YES];
    self.lcMapState = LCMapStateNormal;
    [self.mapView  addSubview:self.aviableCar];
    [self.mapView addSubview:self.tipBtn];
    
    // >一键用车背景
    UIImageView * userBG = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth-90)/2.0, kHeight-180, 80, 80)];
    userBG.image = [UIImage imageNamed:@"main_yijianyongche"];
    [self.view addSubview:userBG];
    userBG.userInteractionEnabled = YES;
    // > 一键用车按钮
    self.useCar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [self.useCar addTarget:self action:@selector(userCarAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.useCar setTitle:@"一键\n用车" forState:UIControlStateNormal];
    self.useCar.titleLabel.font = [UIFont systemFontOfSize:20];
    self.useCar.titleLabel.numberOfLines = 2;

    self.useCar.layer.cornerRadius = 40;

    [userBG addSubview:self.useCar];
    
    // 创建围栏
   // [self wlAction];
  //  [self tmpAddPointViews];
    // 5个 地图按钮
    [self setFiveButton];
    
    [self.view addSubview:self.carPositionView];
    self.carPositionView.hidden = YES;
    
    
}

- (void) tmpAddPointViews{

    
//    coorArr[0] = CLLocationCoordinate2DMake(36.513921, 118.472927);     //平安里地铁站
//    coorArr[1] = CLLocationCoordinate2DMake(36.515261, 118.576532);     //西单地铁站
//    coorArr[2] = CLLocationCoordinate2DMake(36.516611, 118.588161);     //崇文门地铁站
//    coorArr[3] = CLLocationCoordinate2DMake(36.517949, 118.475497);
    NSMutableArray * a = [[NSMutableArray alloc] init];
    MAPointAnnotation * p = [[MAPointAnnotation alloc] init];
    p.title = @"汽车";
//    p.subtitle = d[@"id"];
    p.coordinate = CLLocationCoordinate2DMake(36.522496, 118.543122);
    [a addObject:p];
    
    MAPointAnnotation * p1 = [[MAPointAnnotation alloc] init];
    p1.title = @"汽车";
    p1.coordinate = CLLocationCoordinate2DMake(36.516512, 118.541425);
    [a addObject:p1];
    
    MAPointAnnotation * p2 = [[MAPointAnnotation alloc] init];
    p2.title = @"汽车";
    p2.coordinate = CLLocationCoordinate2DMake(36.514714, 118.548407);
    [a addObject:p2];
    
    MAPointAnnotation * p3 = [[MAPointAnnotation alloc] init];
    p3.title = @"汽车";
    p3.coordinate = CLLocationCoordinate2DMake(36.518961, 118.557589);
    [a addObject:p3];
    [self.mapView addAnnotations:a];
    
    
}

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNav];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 提示条根据状态确定提示内容
    User * cU = [User getUser];
    NSInteger status = cU.login_status.integerValue;
    switch (status) {
        case 0:
            [self.tipBtn setTitle:@"您尚未登录，登录请点击前往" forState:UIControlStateNormal];
            
            break;
        case 1:
            [self.tipBtn setTitle:@"您尚未实名认证，请点击前往" forState:UIControlStateNormal];
            break;
        case 2:
            [self.tipBtn setTitle:@"您尚未交押金，请点击前往" forState:UIControlStateNormal];
            break;
        case 3:
            self.tipBtn.hidden = YES;
            self.aviableCar.transform = CGAffineTransformMakeTranslation(0, -45);
            break;
            
        default:
            break;
    }
    
    
    [self.centerAnnoView setSelected:YES];
    self.centerAnnoView.annotation.coordinate = self.mapView.centerCoordinate;
   
    // 删除围栏
    [self fenceClear];
    
    //> 加载地图 允许区域
    NSDictionary * idParam = @{@"city":@"临朐县"};
    
    [WSUtil wsRequestWithName:@"select_per_cityarea" andParam:idParam success:^(NSArray *dataArr) {
        
        for (NSDictionary * d in dataArr) {
            [self drawWLWithID:d[@"area"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    // >加载车辆
    [WSUtil wsRequestWithName:@"select_city_car" andParam:idParam success:^(NSArray *dataArr) {
        
       
       // > 汽车坐标数组
        NSMutableArray * carArr = [[NSMutableArray alloc] init];
        for (int i = 0; i<dataArr.count; i++) {
            
            NSDictionary * d = dataArr[i];
            
            MAPointAnnotation * p = [[MAPointAnnotation alloc] init];
            p.title = @"汽车";
            p.subtitle = d[@"id"];
            p.coordinate = CLLocationCoordinate2DMake([d[@"lat"] floatValue], [d[@"lon"] floatValue]);
            
            [carArr addObject:p];
        }
        _annViewArr = dataArr;
        // > 车辆信息坐标,在生成返回车辆的时候记录
        _currentCarInfoArr = nil;
        _currentCarInfoArr = [[NSMutableArray alloc] init];
        [self.mapView addAnnotations:carArr];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

    
}

#pragma mark - 围栏
- (void) drawWLWithID:(NSString *)wlID {

    NSDictionary * param = @{@"city":@"临朐县",@"area_id":wlID};
    
    [WSUtil wsRequestWithName:@"select_per_points" andParam:param success:^(NSArray * dataArr) {
        
        NSInteger count = 4;
        CLLocationCoordinate2D *coorArr = malloc(sizeof(CLLocationCoordinate2D) * count);
        for (int i = 0; i<dataArr.count; i++) {
            
            NSDictionary * d = dataArr[i];
            coorArr[i] = CLLocationCoordinate2DMake([d[@"lat"] floatValue], [d[@"lon"] floatValue]);
        }
        [self.geoFenceManager addPolygonRegionForMonitoringWithCoordinates:coorArr count:count customID:wlID];
        
        free(coorArr);
        coorArr = NULL;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark 创建围栏
- (void) wlAction{
    
    NSInteger count = 4;
    CLLocationCoordinate2D *coorArr = malloc(sizeof(CLLocationCoordinate2D) * count);
    coorArr[0] = CLLocationCoordinate2DMake(36.513921, 118.472927);     //平安里地铁站
    coorArr[1] = CLLocationCoordinate2DMake(36.515261, 118.576532);     //西单地铁站
    coorArr[2] = CLLocationCoordinate2DMake(36.516611, 118.588161);     //崇文门地铁站
    coorArr[3] = CLLocationCoordinate2DMake(36.517949, 118.475497);     //东直门地铁站
    //  [self doClear];
    [self.geoFenceManager addPolygonRegionForMonitoringWithCoordinates:coorArr count:count customID:@"polygon_1"];
    
    free(coorArr);
    coorArr = NULL;
    
    // 行政区划围栏
    // [self.geoFenceManager addDistrictRegionForMonitoringWithDistrictName:@"临朐县" customID:nil];
    
}

#pragma mark - 5个按钮：刷新、定位、扫码、客服
- (void) setFiveButton{

    UIButton * refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, kHeight-180, 35, 35)];
    refreshBtn.backgroundColor = [UIColor whiteColor];
    refreshBtn.layer.cornerRadius = 17.5;
    refreshBtn.layer.shadowRadius = 3;
    refreshBtn.layer.shadowOffset = CGSizeMake(1, 1);
    refreshBtn.layer.shadowColor = [UIColor grayColor].CGColor;
    refreshBtn.layer.shadowOpacity = 0.6;
    refreshBtn.tag = 1001;
    [refreshBtn setImage:[UIImage imageNamed:@"main_refresh_btn"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(fiveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    
    UIButton * positionBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(refreshBtn.frame)+10, 35, 35)];
    positionBtn.backgroundColor = [UIColor whiteColor];
    positionBtn.layer.cornerRadius = 17.5;
    positionBtn.layer.shadowOpacity = 0.6;
    positionBtn.layer.shadowColor = [UIColor grayColor].CGColor;
    positionBtn.layer.shadowOffset= CGSizeMake(1, 1);
    positionBtn.tag = 1002;
    [positionBtn setImage:[UIImage imageNamed:@"main_mylocation_btn"] forState:UIControlStateNormal];
    [positionBtn addTarget:self action:@selector(fiveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:positionBtn];
    
    UIButton * lightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-45, kHeight-220, 35, 35)];
    lightBtn.backgroundColor = [UIColor whiteColor];
    lightBtn.layer.cornerRadius = 17.5;
    lightBtn.layer.shadowOffset = CGSizeMake(1, 1);
    lightBtn.layer.shadowColor = [UIColor grayColor].CGColor;
    lightBtn.layer.shadowOpacity = 0.6;
    lightBtn.tag = 1003;
    [lightBtn setImage:[UIImage imageNamed:@"main_remind_noset_img"] forState:UIControlStateNormal];
    [lightBtn addTarget:self action:@selector(fiveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightBtn];
    
    UIButton * scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(lightBtn.frame.origin.x, CGRectGetMaxY(lightBtn.frame)+10, 35, 35)];
    scanBtn.backgroundColor = [UIColor whiteColor];
    scanBtn.layer.cornerRadius = 17.5;
    scanBtn.layer.shadowOffset = CGSizeMake(1, 1);
    scanBtn.layer.shadowColor = [UIColor grayColor].CGColor;
    scanBtn.layer.shadowOpacity = 0.6;
    scanBtn.tag = 1004;
    
    [scanBtn setImage:[UIImage imageNamed:@"main_saoma_btn"] forState:UIControlStateNormal];

     [scanBtn addTarget:self action:@selector(fiveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBtn];
    
    UIButton * phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(lightBtn.frame.origin.x, CGRectGetMaxY(scanBtn.frame)+10, 35, 35)];
    phoneBtn.backgroundColor = [UIColor whiteColor];
    phoneBtn.layer.cornerRadius = 17.5;
    phoneBtn.layer.shadowOffset = CGSizeMake(1, 1);
    phoneBtn.layer.shadowColor = [UIColor grayColor].CGColor;
    phoneBtn.layer.shadowOpacity = 0.6;
    phoneBtn.tag = 1005;
    [phoneBtn setImage:[UIImage imageNamed:@"main_phone_btn"] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(fiveAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:phoneBtn];
    
}

-(void) fiveAction:(UIButton *)btn{

    switch (btn.tag) {
        case 1001:
            NSLog(@"refresh");
            break;
        case 1002:
        {
        NSLog(@"position");
//            self.mapView.centerCoordinate = self.mapView.userLocation.coordinate;
            
            [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
        }
            
            break;
        case 1003:
            NSLog(@"light");
            break;
        case 1004:{
            NSLog(@"scan");
            [self Code];
        }
            break;
        case 1005:{
            NSLog(@"phone");
        // 客服
            [self kefuAction];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark 二维码扫描框
-(void)Code
{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
                        [self.navigationController pushViewController:scanningQRCodeVC animated:YES];
                        NSLog(@"主线程 - - %@", [NSThread currentThread]);
                    });
                    NSLog(@"当前线程 - - %@", [NSThread currentThread]);
                    
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限");
                    
                } else {
                    
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
            [self.navigationController pushViewController:scanningQRCodeVC animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
//            SGAlertView *alertView = [SGAlertView alertViewWithTitle:@"⚠️ 警告" delegate:nil contentTitle: alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
//            [alertView show];
            [MBProgressHUD showMessag:@"请去-> [设置 - 隐私 - 相机 - 益善通] 打开访问开关" toView:nil];
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
//        SGAlertView *alertView = [SGAlertView alertViewWithTitle:@"⚠️ 警告" delegate:nil contentTitle:@"未检测到您的摄像头, 请在真机上测试" alertViewBottomViewType:(SGAlertViewBottomViewTypeOne)];
//        [alertView show];
        [MBProgressHUD showError:@"未检测到您的摄像头，请在真机上测试" toView:nil];
    }
}
- (void) kefuAction{

    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请选择联系方式" preferredStyle:UIAlertControllerStyleActionSheet];
   // alertVC.preferredStyle = UIAlertControllerStyleActionSheet;
    UIAlertAction * mAction = [UIAlertAction actionWithTitle:@"在线客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"在线客服-即时聊天");
        
    }];
    UIAlertAction * pAction = [UIAlertAction actionWithTitle:@"电话客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString * str2 = [NSString stringWithFormat:@"telprompt://%@",@"10086"];
        UIDevice * device = [UIDevice currentDevice];
        NSLog(@"系统%@",device.systemVersion);
        if (device.systemVersion.integerValue > 10  ) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str2] options:[NSDictionary new] completionHandler:^(BOOL success) {
                
            }];
        }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str2]];
        }
      
        
        
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alertVC addAction:mAction];
    [alertVC addAction:pAction];
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark = 移除路线规划
- (void)clear
{
    
     [self.mapView removeOverlay:self.currentLine];
//    [self.naviRoute removeFromMapView];
   // [self.naviRoute removeFromMapView];
}

#pragma mark = 删除围栏
- (void) fenceClear{

    [self.mapView removeOverlays:self.mapView.overlays];  //把之前添加的Overlay都移除掉
    [self.geoFenceManager removeAllGeoFenceRegions];  //移除所有已经添加的围栏，如果有正在请求的围栏也会丢弃
    
}

#pragma mark = 地图上显示多边形
- (MAPolygon *)showPolygonInMap:(CLLocationCoordinate2D *)coordinates count:(NSInteger)count {
    MAPolygon *polygonOverlay = [MAPolygon polygonWithCoordinates:coordinates count:count];
    [_mapView addOverlay:polygonOverlay];
    return polygonOverlay;
}
#pragma mark - ======= 分时-短租-充电 =========
#pragma mark = 分时
- (IBAction)fenshiAction:(UIButton *)sender {
    
    [UIView animateWithDuration:0.15 animations:^{
        self.moveView.frame = CGRectMake(self.fenshiBtn.frame.origin.x+(kWidth*0.2-50)/2.0, 41, 50, 3);
    }];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:self.centerAnnotation];
    [self.mapView selectAnnotation:self.centerAnnotation  animated:YES];
    // >地图显示车辆
    _currentCarInfoArr = nil;
    _currentCarInfoArr = [[NSMutableArray alloc] init];
    self.aviableCar.hidden = NO;
    self.annoContentFlag = 0;
     [self.useCar setTitle:@"一键\n用车" forState:UIControlStateNormal];
    
//    PayBillController   * pbVC = [[PayBillController alloc] init];
//    [self.navigationController pushViewController:pbVC animated:YES];
    
    [self.centerAnnoView setSelected:YES];
    self.centerAnnoView.annotation.coordinate = self.mapView.centerCoordinate;
    
    // 删除围栏
    [self fenceClear];
    
    //> 加载地图 允许区域
    NSDictionary * idParam = @{@"city":@"临朐县"};
    
    [WSUtil wsRequestWithName:@"select_per_cityarea" andParam:idParam success:^(NSArray *dataArr) {
        
        for (NSDictionary * d in dataArr) {
            [self drawWLWithID:d[@"area"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    // >加载车辆
    [WSUtil wsRequestWithName:@"select_city_car" andParam:idParam success:^(NSArray *dataArr) {
        
        // NSLog(@"%@",dataArr);
        NSMutableArray * carArr = [[NSMutableArray alloc] init];
        for (int i = 0; i<dataArr.count; i++) {
            
            NSDictionary * d = dataArr[i];
            
            MAPointAnnotation * p = [[MAPointAnnotation alloc] init];
            p.title = @"汽车";
            p.subtitle = d[@"id"];
            p.coordinate = CLLocationCoordinate2DMake([d[@"lat"] floatValue], [d[@"lon"] floatValue]);
            
            [carArr addObject:p];
        }
        _annViewArr = dataArr;
        [self.mapView addAnnotations:carArr];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
#pragma mark = 短租
- (IBAction)duanzuAction:(UIButton *)sender {
    [UIView animateWithDuration:0.15 animations:^{
        self.moveView.frame = CGRectMake(self.duanzuBtn.frame.origin.x+(kWidth*0.2-50)/2.0, 41, 50, 3);
    }];
    
    // > 地图显示车辆
    _currentCarInfoArr = nil;
    _currentCarInfoArr = [[NSMutableArray alloc] init];

    self.aviableCar.hidden = NO;
    self.annoContentFlag = 1;
    [self.useCar setTitle:@"一键\n用车" forState:UIControlStateNormal];
    // 绘制折线
  //  [self drawAction];
  //    MapTool * mTool = [MapTool  sharedMapTool];
  //   [mTool navigationActionWithCoordinate:CLLocationCoordinate2DMake(36.517949, 118.475497) WithENDName:@"目的车辆" tager:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tipBtn.hidden = YES;
        self.aviableCar.transform = CGAffineTransformMakeTranslation(0, -45);
    }];
    
    
    [self.mapView removeOverlays:self.mapView.overlays];  //把之前添加的Overlay都移除掉
    [self.geoFenceManager removeAllGeoFenceRegions];  //移除所有已经添加的围栏，如果有正在请求的围栏也会丢弃
//    [self.mapView addAnnotation:self.centerAnnotation];
    [self.mapView selectAnnotation:self.centerAnnotation  animated:YES];
}

//地理围栏状态改变时回调，当围栏状态的值发生改变，定位失败都会调用
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didGeoFencesStatusChangedForRegion:(AMapGeoFenceRegion *)region customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"status changed error %@",error);
    }else{
        NSLog(@"status changed %@",[region description]);
    }
}
#pragma mark = 充电
- (IBAction)chongdianAction:(UIButton *)sender {
    //> 滑块动画
    [UIView animateWithDuration:0.15 animations:^{
        self.moveView.frame = CGRectMake(self.chongdianBtn.frame.origin.x+(kWidth*0.2-50)/2.0, 41, 50, 3);
    }];
    
    // > 地图显示充电桩
    self.aviableCar.hidden = YES;
    self.annoContentFlag = 2;
    [self.useCar setTitle:@"扫码\n充电" forState:UIControlStateNormal];
    [self clear];
    // > 删除汽车
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:self.centerAnnotation];
    [self.mapView selectAnnotation:self.centerAnnotation  animated:YES];
    // > 删除围栏
    [self fenceClear];
    
    [self.centerAnnoView setSelected:YES];
    self.centerAnnoView.annotation.coordinate = self.mapView.centerCoordinate;
    /// > 显示充电桩
    NSDictionary * param = @{@"city":@"临朐县"};
    [WSUtil wsRequestWithName:@"select_city_chongdianzhuang" andParam:param success:^(NSArray *dataArr) {
        
        NSLog(@"%@",dataArr);
        
        NSMutableArray * carArr = [[NSMutableArray alloc] init];
        for (int i = 0; i<dataArr.count; i++) {
            
            NSDictionary * d = dataArr[i];
            
            MAPointAnnotation * p = [[MAPointAnnotation alloc] init];
            p.title = @"充电桩";
            p.subtitle = d[@"id"];
            p.coordinate = CLLocationCoordinate2DMake([d[@"lat"] floatValue], [d[@"lon"] floatValue]);
            
            [carArr addObject:p];
        }
       //  _annViewArr = dataArr;
        [self.mapView addAnnotations:carArr];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
    
    //    PayCompleteController * pcVC = [[PayCompleteController alloc] init];
    //    [self.navigationController pushViewController:pcVC animated:YES];
}

#pragma mark - 绘制折线-步行导航
- (void) drawActionWithDestination:(CLLocationCoordinate2D) desCoordinate{
    MAUserLocation * l = (MAUserLocation *)self.mapView.userLocation;
    NSLog(@"userLocation :lat== %f,lon ==%f",l.location.coordinate.latitude,l.location.coordinate.longitude);
    
    // CLLocationCoordinate2DMake(36.500157, 118.545853)
    self.startCoordinate   = l.location.coordinate;
    //CLLocationCoordinate2DMake(36.498852, 118.553309)
    self.destinationCoordinate = desCoordinate;
    
    MAPointAnnotation * startAnnotation = [[MAPointAnnotation  alloc] init ];
    startAnnotation.coordinate = l.location.coordinate;
 
   // MAPointAnnotation * destinationAnnotation = [[MAPointAnnotation alloc] init];
    //destinationAnnotation.coordinate = CLLocationCoordinate2DMake(36.498852, 118.553309);

    AMapWalkingRouteSearchRequest * navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude];
    
    [self.searchApi AMapWalkingRouteSearch:navi];
    
   // [self.mapView addAnnotation:startAnnotation];
   // [self.mapView addAnnotation:destinationAnnotation];
   
}

#pragma mark - 围栏回调
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog (@"创建失败 %@",error);
    } else {
        //  NSLog(@"创建成功");
        /// 注释之后地图比例不受限制
        
        AMapGeoFencePolygonRegion *polygonRegion = (AMapGeoFencePolygonRegion *)regions.firstObject;
        // MAPolygon *polygonOverlay =
         [self showPolygonInMap:polygonRegion.coordinates count:polygonRegion.count];
        /*
        [_mapView setVisibleMapRect:polygonOverlay.boundingMapRect edgePadding:UIEdgeInsetsMake(30, 30, 30, 30) animated:YES];
         */
        
        /// 行政区划
    }
}

#pragma mark - ==== -地图的代理方法- ====
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    // self.userLocation = userLocation.location;
}
#pragma mark = 地图即将移动
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated{

    
    
}
#pragma mark = 移动地图的监听方法
-(void)mapViewRegionChanged:(MAMapView *)mapView{

    NSLog(@"地图中心经度：%f --- 地图中心纬度：%f",mapView.centerCoordinate.longitude,mapView.centerCoordinate.latitude);

    
    self.pointAnnotation.coordinate = mapView.centerCoordinate;
    
   // [_mapView addAnnotation:self.pointAnnotation];
    
    [self.centerAnnoView setSelected:YES];
    self.centerAnnoView.annotation.coordinate = mapView.centerCoordinate;
}
#pragma mark = 地图移动结束
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

    // 遍历地图的 annotation 判断是否显示
    //    mapView.annotations
    
    //  [mapView reloadMap];
    //  [mapView showAnnotations:mapView.annotations animated:YES];
    
   // mapView.annotations = nil;
    
//    mapView removeAnnotations:
    
}

#pragma mark  = 单击地图手势
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    // > 开放模式切换按钮
    self.fenshiBtn.userInteractionEnabled = YES;
    self.duanzuBtn.userInteractionEnabled = YES;
    self.chongdianBtn.userInteractionEnabled = YES;
    
    if (self.annoContentFlag == 0 || self.annoContentFlag == 1) {
        
        //> 当前显示汽车
        self.nearestDistance = 0;
        [self.mapView selectAnnotation:self.pointAnnotation animated:YES];
        [self.centerAnnoView setSelected:YES];
        if (self.lcMapState == LCMapStateSelected) {
            
            self.lcMapState = LCMapStateNormal;
            self.centerAnnoView.hidden = NO;
            [self.centerAnnoView setSelected:YES animated:YES];
            
            [self.mapView selectAnnotation:self.pointAnnotation animated:YES];
            [self.centerAnnoView setSelected:YES];
            
            [self clear];
            //> 删除车辆信息视图
            [UIView animateWithDuration:0.3 animations:^{
                self.pickedCarView.transform = CGAffineTransformMakeTranslation(0, 320);
            } completion:^(BOOL finished) {
                [self.pickedCarView  removeFromSuperview];
                self.pickedCarView.carInfoDelegate = nil;
                self.pickedCarView = nil;
            }];
            
            
            [self.mapView setZoomLevel:16 animated:YES];
            self.mapView.centerCoordinate = self.mapView.userLocation.coordinate;
            
            // 隐藏 两个提示条
            self.tipBtn.hidden = NO;
            self.aviableCar.hidden = NO;
            self.carPositionView.hidden = YES;
        }
        
    }else{
        [self.centerAnnoView setSelected:YES animated:YES];
        [self.mapView selectAnnotation:self.pointAnnotation animated:YES];
    /// > 当前显示充电桩
        [UIView animateWithDuration:0.25 animations:^{
            
            self.chargeView.transform = CGAffineTransformMakeTranslation(0, 300);
        } completion:^(BOOL finished) {
            
            [self.chargeView removeFromSuperview];
            self.chargeView.chargeDelegate = nil;
            self.chargeView = nil;
            
        }];
        
        
        
    }
    
    
}
// 地图将要移动
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction{

    if (self.annoContentFlag == 0 || self.annoContentFlag == 1) {
        // 当前地图显示汽车
        if (self.lcMapState == LCMapStateNormal) {
            
            self.wView.hidden = YES;
            self.bView.hidden = NO;
            
            NSLog(@"33333%@",mapView.annotations);
            NSMutableArray * cMArr = [[NSMutableArray alloc] initWithArray:mapView.annotations];
            for (int i = 0; i<cMArr.count; i++) {
                MAPointAnnotation * a = (MAPointAnnotation *)cMArr[i];
                if ([a.title isEqualToString:@"搜索附近车辆"]) {
                    [cMArr removeObject:a];
                }
            }
            /// 先保存，等新的车辆显示，再隐藏
            _lastArr = cMArr;
            // [mapView removeAnnotations:cMArr];
            NSLog(@"4444%@",mapView.annotations);
        }
    }else{
    // 当前地图显示充电桩
        
        self.wView.hidden = YES;
        self.bView.hidden = NO;
        
    }
    
    
   
    
}
// 地图移动结束
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    
    
    if (self.annoContentFlag == 0 || self.annoContentFlag == 1) {
        //> 当前显示车辆
        
        if (self.lcMapState == LCMapStateNormal) {
            
            self.wView.hidden = NO;
            self.bView.hidden = YES;
            
            NSDictionary * idParam = @{@"city":@"临朐县"};
            [WSUtil wsRequestWithName:@"select_city_car" andParam:idParam success:^(NSArray *dataArr) {
                
                // NSLog(@"%@",dataArr);
                NSMutableArray * carArr = [[NSMutableArray alloc] init];
                for (int i = 0; i<dataArr.count; i++) {
                    
                    NSDictionary * d = dataArr[i];
                    
                    MAPointAnnotation * p = [[MAPointAnnotation alloc] init];
                    p.title = @"汽车";
                    // 图标的subtitle 存放 车辆ID 用于获取车辆信息
                    p.subtitle = d[@"id"];
                    p.coordinate = CLLocationCoordinate2DMake([d[@"lat"] floatValue], [d[@"lon"] floatValue]);
                    
                    [carArr addObject:p];
                }
                // [self.mapView  removeAnnotation:self.centerAnnoView.annotation];
                _annViewArr = dataArr;
                _currentCarInfoArr = nil;
                _currentCarInfoArr = [[NSMutableArray alloc] init];
                [self.mapView addAnnotations:carArr];
                [self.mapView removeAnnotations:_lastArr];
                //  [self.mapView addAnnotation:self.centerAnnoView.annotation];
                _lastArr = nil;
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        }
        
    }else{
    //> 当前显示充电桩
    
        self.wView.hidden = NO;
        self.bView.hidden = YES;
        
        
    }
    
    

   
    
}

- (void)mapView:(MAMapView *)mapView didAnnotationViewCalloutTapped:(MAAnnotationView *)view{

    NSLog(@"callOutTapped");
    
}

/**
 * @brief 标注view被点击时，触发改回调。（since 5.7.0）
 */
#pragma mark - annoView被点击,地图车辆被标记
- (void)mapView:(MAMapView *)mapView didAnnotationViewTapped:(MAAnnotationView *)view{
    // > 禁用模式切换按钮
    self.fenshiBtn.userInteractionEnabled    = NO;
    self.duanzuBtn.userInteractionEnabled    = NO;
    self.chongdianBtn.userInteractionEnabled = NO;
    
    self.reGEOUtil.location = [AMapGeoPoint locationWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
    self.reGEOUtil.requireExtension = YES;
//    AMapGeocodeSearchRequest * request = [[AMapGeocodeSearchRequest alloc] init];
    
    [self.searchAPI AMapReGoecodeSearch:self.reGEOUtil];
    // 选中车辆的反地理编码
    // 计算直线距离
    int carDistance = (int)ceil([self distanceBetweenOrderBy:self.mapView.centerCoordinate :view.annotation.coordinate]);
    int time = (int)ceil(carDistance/80.0);
    
    // 180004856925
    // 9998180001736225
    if ([view.annotation.title isEqualToString:@"汽车"]) {
        // 点击车辆之后，地图成为selected 状态
        self.lcMapState = LCMapStateSelected;
        self.centerAnnoView.hidden = YES;
        //> 距离车辆的距离和步行时间
        _disLab.text = [NSString stringWithFormat:@"距离%d米步行%d分钟",carDistance,time];
        
        NSLog(@"annotationID = %@",view.annotation.subtitle);
        // 先清除上一条
        [self clear];
        [self.pickedCarView  removeFromSuperview];
        self.pickedCarView.carInfoDelegate = nil;
        self.pickedCarView = nil;
//         view.canShowCallout = YES;
        self.centerAnnoView.selected = YES;
        view.selected = NO;
        MAPointAnnotation * pA = view.annotation;
        NSLog(@"annotationTapped==%f",pA.coordinate.latitude);
        
        [self drawActionWithDestination:pA.coordinate];
        
        /// for 循环找车辆信息
        for (int i = 0; i<_annViewArr.count; i++) {
            NSDictionary * a = _annViewArr[i];
            if ([a[@"id"] integerValue]== [view.annotation.subtitle integerValue]) {
                 [self showPickedCarInfo:a];
            }
        }
        // 显示选中车辆信息
        self.tipBtn.hidden = YES;
        self.aviableCar.hidden = YES;
        
        // [self.view addSubview:self.carPositionView];
        self.carPositionView.hidden = NO;
        
    }else if ([view.annotation.title isEqualToString:@"充电桩"]){
    // 当前显示充电桩
        self.centerAnnoView.selected = YES;
        view.selected = NO;
        
        [self.chargeView removeFromSuperview];
        self.chargeView.chargeDelegate = nil;
        self.chargeView = nil;
        
        self.chargeView = [[ChargeView alloc] initChanrgeViewWithInfo:view.annotation.coordinate];
        self.chargeView.chargeDelegate = self;
        [self.view addSubview:self.chargeView];
        self.chargeView.transform = CGAffineTransformMakeTranslation(0, 300);
        [UIView animateWithDuration:0.3 animations:^{
            self.chargeView.transform = CGAffineTransformIdentity;
        }];
        
        self.chargeView.nameLab.text = @"充电桩";
        if (carDistance >= 1000) {
            self.chargeView.distanceLab.text = [NSString stringWithFormat:@"%.1fkm",(CGFloat)(carDistance/1000.0)];
        }else{
            
        self.chargeView.distanceLab.text = [NSString stringWithFormat:@"%ldm",(NSInteger)(carDistance)];
        }
    }
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"你地理编码Error=%@",error);
    
    NSLog(@"33333");
}
#pragma mark = 反地理编码代理方法
-(void) onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{

    if (response.regeocode !=nil )
        
    {
        
        if (self.annoContentFlag == 0 || self.annoContentFlag == 1) {
            // > 设置汽车参数
            _carPositionLab.text = response.regeocode.formattedAddress;
            
        }else{
            // > 设置充电桩参数
            self.chargeView.addressLab.text = response.regeocode.formattedAddress;
            
        }
        
        
        NSLog(@"反向地理编码回调:%@",response.regeocode.addressComponent.neighborhood);
        
        NSLog(@"反向地理编码回调地区编码:%@",response.regeocode.addressComponent.adcode);
        
        NSLog(@"反向地理编码回调-街道:%@",response.regeocode.addressComponent.township);
        
        NSLog(@"反向地理编码回调:%@",response.regeocode.addressComponent.towncode);
        
        NSLog(@"反向地理编码回调-区划:%@",response.regeocode.addressComponent.district);
        
        
        
        NSArray * addressArr = response.regeocode.pois;
        
        if (addressArr && addressArr.count >0) {
            
            AMapPOI *poiTemp = addressArr[0];
            
            NSLog(@"反向地理编码回调-POI:%@",poiTemp.name);
            
            
            
        }
        
    }
}

#pragma mark = 地图生成覆盖物、折线
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolygon class]]) {
        /// 围栏
        MAPolygonRenderer *polylineRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        // 围栏的边缘线宽度
        polylineRenderer.lineWidth = 2.0f;
        // 设置围栏区域的透明度
        polylineRenderer.alpha = 0.3f;
        // 围栏的边缘线颜色
        polylineRenderer.strokeColor = [UIColor whiteColor];
        // 围栏的填充颜色
        polylineRenderer.fillColor   = plineColor;
        
        return polylineRenderer;
    } else if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth = 3.0f;
        circleRenderer.strokeColor = [UIColor purpleColor];
    
        return circleRenderer;
    }
    /*
    if ([overlay isKindOfClass:[MANaviPolyline class]]){
    
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 15;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
     //  MAMapRect newRect = [self.mapView mapRectThatFits:naviPolyline.boundingMapRect];
       // [self.mapView setVisibleMapRect:newRect edgePadding:UIEdgeInsetsMake(50, 50, 10, 10) animated:YES];
       // [self.mapView setVisibleMapRect:newRect animated:YES];
        return polylineRenderer;
    }
    */
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 8;
        polylineRenderer.lineDashType = kMALineDashTypeSquare;
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 5.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.9];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
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
            annotationView.annotation = tmpPoint;
            
            [annotationView setDragState:MAAnnotationViewDragStateDragging animated:YES];
            self.centerAnnoView = annotationView;
            self.centerAnnotation = annotationView.annotation;
            // 是否显示自带气泡  YES
            annotationView.canShowCallout               = NO;
            // 大头针掉落效果
            annotationView.animatesDrop                 = NO;
            annotationView.draggable                    = NO;
            annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.image = [UIImage imageNamed:@"map_pin_location_img"];
            annotationView.canShowCallout = YES;
            // annotationView.selected       = YES;
           // self.centerAnnoView.annotation.coordinate = mapView.centerCoordinate;
            [annotationView setSelected:YES animated:YES];
            /// 自定义大头针的点击弹出视图
            
            UIView * bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            
            bView.backgroundColor = [UIColor colorWithRed:38/255.0 green:149/255.0 blue:250/255.0 alpha:0.8];
            bView.layer.cornerRadius = 12.5;
            
            UIImageView * iView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            self.bView = iView;
            iView.backgroundColor = [UIColor clearColor];
            iView.image =  [UIImage imageNamed:@"bubble_refresh_img1"];
            
            [NSTimer scheduledTimerWithTimeInterval:0.25 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [UIView animateWithDuration:0.5 animations:^{
                    iView.transform = CGAffineTransformRotate(iView.transform, M_PI);
                }];
            }];
            
            [bView addSubview:iView];
            iView.hidden = YES;
            iView.center = bView.center;
            
            UILabel * wView = [[UILabel alloc] initWithFrame:CGRectMake(-40, 0, 100, 25)];
            wView.layer.cornerRadius = 12.5;
            wView.layer.masksToBounds = YES;
            wView.textAlignment = NSTextAlignmentCenter;
            self.wView = wView;
            wView.text = @"搜索附近车辆";
            wView.font = [UIFont boldSystemFontOfSize:12];
            wView.backgroundColor = [UIColor colorWithRed:47/255.0 green:151/255.0 blue:238/255.0 alpha:1];
            wView.textColor = [UIColor whiteColor];
            [bView addSubview:wView];
            
            // 自定义弹出
            MACustomCalloutView * maView = [[MACustomCalloutView alloc] initWithCustomView:bView];
            annotationView.customCalloutView = maView;
            
            return annotationView;
            
        }else if ([tmpPoint.title isEqualToString:@"当前位置"]){
            static NSString *pointReuseIndetifier = @"userLocation";
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
            annotationView.image = [UIImage imageNamed:@"gps_point"];
            annotationView.canShowCallout = YES;
            // annotationView.selected       = YES;
            [annotationView setSelected:YES animated:YES];
            //  annotationView.enabled = NO;
            return annotationView;
        }else{
            
            if ([tmpPoint.title isEqualToString:@"汽车"]) {
                
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
                //  annotationView.enabled = NO;
                
                /** 限制显示 2000m */
                double d = [self distanceBetweenOrderBy:tmpPoint.coordinate :mapView.centerCoordinate];
                
                /// > 车辆动画
                [UIView animateWithDuration:0.25 animations:^{
                    annotationView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                    
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 animations:^{
                       annotationView.transform = CGAffineTransformIdentity;
                    }];
                }];
                
                // > 比较得出2000
                double userD = [self distanceBetweenOrderBy:tmpPoint.coordinate :mapView.userLocation.coordinate];
                if (self.nearestDistance == 0) {
                    self.nearestDistance = userD;
                }else{
                
                    if (self.nearestDistance > userD) {
                        self.nearestDistance = userD;
//                        self.nearestAnnotation = annotation;
                        self.nearestCarView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
                       // self.nearestCarView.annotation = annotation;
                        NSLog(@"aView = %@",self.nearestCarView.annotation);
                    }
                }
                if (d< 2000) {
                    
                    // > 记录显示的车辆的信息，用于附近的车辆
                    for (int i = 0; i<_annViewArr.count; i++) {
                        
                        NSDictionary * d = _annViewArr[i];
                        
                        if ([tmpPoint.subtitle isEqualToString:d[@"id"]]) {
                            
                            [_currentCarInfoArr addObject:d];
                            [self.aviableCar setTitle:[NSString stringWithFormat:@"附近%ld辆可用车辆",_currentCarInfoArr.count] forState:UIControlStateNormal];
                        }

                    }
                    
                    
                        return annotationView;
                    }else{
                        annotationView.hidden = YES;
                      //  self.nearestCarView.hidden =    NO;
                        return annotationView;
                    }
                
               // return annotationView;
                
            }
            
            else if (tmpPoint.title == nil || [tmpPoint.title containsString:@"步行"]){
                
                return nil;
            }else if ([tmpPoint.title isEqualToString:@"充电桩"]){
            
                static NSString *pointReuseIndetifier = @"chongDianZhuang";
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
                annotationView.image = [UIImage imageNamed:@"main_charge_map_img_use"];
                annotationView.canShowCallout = YES;
                // annotationView.selected       = YES;
                [annotationView setSelected:YES animated:YES];
                //  annotationView.enabled = NO;
                
                return annotationView;
            }
            
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

#pragma mark - Search步行路线规划
-(void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response{
    
    if (response.route == nil) {
        return;
    }
    //    AMapSearchObject
    self.planRoute = response.route;
    
    if (response.count > 0) {
        // 路线规划
     //   [self presentRoute];
        
        AMapGeoPoint * des = response.route.destination;
        
        NSArray * steps = response.route.paths[0].steps;
        
       // NSMutableArray * coorArr = [[NSMutableArray alloc] init];
         CLLocationCoordinate2D lineCoords[steps.count+2];
        
        for (int i = 0; i<steps.count+3; i++) {
            if (i== 0) {
                lineCoords[0].latitude = self.mapView.userLocation.coordinate.latitude;
                lineCoords[0].longitude = self.mapView.userLocation.coordinate.longitude;
            }else if (i == steps.count +1){
            
//                lineCoords[steps.count+2].latitude = des.latitude;
//                lineCoords[steps.count+2].longitude= des.longitude;
                NSString * llStr = ((AMapStep *)steps[i-2]).polyline;
                NSArray * llArr1 = [llStr componentsSeparatedByString:@";"];
                NSArray * llArr = [llArr1.lastObject componentsSeparatedByString:@","];
                lineCoords[i].longitude = [llArr[0] doubleValue];
                lineCoords[i].latitude  = [llArr[1] doubleValue];
                
            }else if (i == steps.count + 2){
            
                lineCoords[steps.count+2].latitude = des.latitude;
                lineCoords[steps.count+2].longitude= des.longitude;
            }else{
            
                NSString * llStr = ((AMapStep *)steps[i-1]).polyline;
                NSArray * llArr1 = [llStr componentsSeparatedByString:@";"];
                NSArray * llArr = [llArr1.firstObject componentsSeparatedByString:@","];
                
                lineCoords[i].longitude = [llArr[0] doubleValue];
                lineCoords[i].latitude  = [llArr[1] doubleValue];
                
            }
        }
        self.currentLine = [MAPolyline polylineWithCoordinates:lineCoords count:steps.count+3];
        [self.mapView addOverlay:self.currentLine];
        
        [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:@[self.currentLine]]
                            edgePadding:UIEdgeInsetsMake(110, 20, 270, 20)
                               animated:YES];
        /// 上 左 下 右
    }
    
}

#pragma mark = 路线展示
- (void) presentRoute{
    
    MANaviAnnotationType type = MANaviAnnotationTypeWalking;
    
    self.naviRoute = [MANaviRoute naviRouteForPath:self.planRoute.paths[0] withNaviType:type showTraffic:NO startPoint:[AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude]];
    
    [self.naviRoute addToMapView:self.mapView];
    self.naviRoute.anntationVisible = NO;
    self.naviRoute.naviAnnotations = nil;
    
    /* 缩放地图使其适应polylines的展示. */
//#warning 路线规划适配
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(60, 160, 260, 60)
                           animated:YES];
    //-240
}


#pragma mark = 设置导航栏
- (void) setNav{

  //  [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    // 设置不透明
    self.navigationController.navigationBar.translucent = NO;
    //===========--- 侧边栏按钮  ---===========
    UIButton * slideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [slideBtn setImage:[UIImage imageNamed:@"main_personcenter_img"] forState:UIControlStateNormal];
    [slideBtn addTarget:self action:@selector(slideAction) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem * slideItem = [[UIBarButtonItem alloc] initWithCustomView:slideBtn];
    
    self.navigationItem.leftBarButtonItem = slideItem;
    
    // titleView
    UIButton * titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
      [titleBtn setTitle:@"临朐县" forState:UIControlStateNormal];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"city_selected_dropdown_img"] forState:UIControlStateNormal];
    [titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];
    [titleBtn addTarget:self action:@selector(areaPickAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    //============----- search -----===========
    UIButton * searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [searchBtn setImage:[UIImage imageNamed:@"main_relasearch_img"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(navSearchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    //=============------ msg -----============
    UIButton * msgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [msgBtn setImage:[UIImage imageNamed:@"main_newscenter_img"] forState:UIControlStateNormal];
    UIBarButtonItem * msgItem = [[UIBarButtonItem alloc] initWithCustomView:msgBtn];
    [msgBtn addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[msgItem,searchItem];
    
}
#pragma mark - ===========- 顶部导航栏按钮 -===========
#pragma mark = 导航栏搜索按钮
- (void) navSearchAction{
    
}
#pragma mark = 信息按钮事件
- (void) msgAction{

    SystemMsgController * msgVC = [[SystemMsgController alloc] init];
    [self.navigationController pushViewController:msgVC animated:YES];
   // 0061
    
}
#pragma mark = 地区选择
- (void) areaPickAction{

    AreaController * areaVC = [[AreaController alloc] init];
    
    [self presentViewController:areaVC animated:YES completion:nil];
    
}
#pragma mark = 侧边
- (void) slideAction{

    
    [self.slideView reloadSlideInfo];
    UIWindow * window = [UIApplication  sharedApplication].keyWindow;
    //[window addSubview:self.coverBtn];
    //[window sendSubviewToBack:self.coverBtn];
    [window insertSubview:self.coverBtn belowSubview:self.slideView];
    [UIView animateWithDuration:0.3 animations:^{
    //    [self.view addSubview:self.coverBtn];
        
        self.slideView.transform = CGAffineTransformMakeTranslation(kWidth, 0);
    }];
    
}
-(void) coverOver:(UIButton *)coverBtn {

    [self.coverBtn removeFromSuperview];
    self.coverBtn=nil;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.slideView.transform = CGAffineTransformIdentity;
        
    }];
    
    [self.popCenterView removeFromSuperview];
    self.popCenterView = nil;
}

#pragma mark - 可获得的车辆
- (void) aviliableAction{

    _nearVC.nearCarArr = [[NSMutableArray alloc] initWithArray:_currentCarInfoArr];
    _nearVC.myLocation = self.mapView.userLocation.coordinate;
    [self.navigationController pushViewController:_nearVC animated:YES];
}

#pragma mark = 选中附近的车辆
- (void) chooseNearCarWithInfo:(NSDictionary *)carDic{

    NSLog(@"选中车辆-1111111");
    
    self.reGEOUtil.location = [AMapGeoPoint locationWithLatitude:[carDic[@"lat"] doubleValue] longitude:[carDic[@"lon"] doubleValue]];
    self.reGEOUtil.requireExtension = YES;
    
    [self.searchAPI AMapReGoecodeSearch:self.reGEOUtil];
    // 选中车辆的反地理编码
    // 计算直线距离
    CLLocationCoordinate2D choosedOne = CLLocationCoordinate2DMake([carDic[@"lat"] doubleValue], [carDic[@"lon"] doubleValue]);
    int carDistance = (int)ceil([self distanceBetweenOrderBy:self.mapView.centerCoordinate :choosedOne]);
    int time = (int)ceil(carDistance/70.0);
    _disLab.text = [NSString stringWithFormat:@"距离%d米步行%d分钟",carDistance,time];
    
 //   if ([self.nearestCarView.annotation.title isEqualToString:@"汽车"]) {
        // 点击车辆之后，地图成为selected 状态
        self.lcMapState = LCMapStateSelected;
        self.centerAnnoView.hidden = YES;
        
        NSLog(@"annotationID = %@",self.nearestCarView.annotation.subtitle);
        // 先清除上一条
        [self clear];
        [self.pickedCarView  removeFromSuperview];
        self.pickedCarView.carInfoDelegate = nil;
        self.pickedCarView = nil;
        // view.canShowCallout = YES;
        self.centerAnnoView.selected = YES;
        self.nearestCarView.selected = NO;
//        MAPointAnnotation * pA = self.nearestCarView.annotation;
//        NSLog(@"annotationTapped==%f",pA.coordinate.latitude);
    
        [self drawActionWithDestination:choosedOne];
        
//        /// for 循环找车辆信息
//        for (int i = 0; i<_annViewArr.count; i++) {
//            NSDictionary * a = _annViewArr[i];
//            if ([a[@"id"] integerValue]== [self.nearestCarView.annotation.subtitle integerValue]) {
//                [self showPickedCarInfo:a];
//            }
//        }
    [self showPickedCarInfo:carDic];
        // 显示选中车辆信息
        self.tipBtn.hidden = YES;
        self.aviableCar.hidden = YES;
        self.carPositionView.hidden = NO;
 //   }
    
}
#pragma mark - 未登录
-(void) showLog:(UIButton *)btn{

    User * cU = [User getUser];
    NSInteger status = cU.login_status.integerValue;
    switch (status) {
        case 0:
        {  // 去登录
            NSLog(@"去登录");
            LoginViewController * lVC = [[LoginViewController alloc] init];
            UINavigationController * nav =[[UINavigationController alloc] initWithRootViewController:lVC];
            
            [nav setNavigationBarHidden:YES];
            nav.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 1:
        { // 去实名
            NSLog(@"去实名");
        }
             break;
        case 2:
        { // 去交押金
            NSLog(@"去交押金");
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark ====== 一键用车/扫码充电 -======
- (void) userCarAction:(UIButton *)btn {

    if ([btn.titleLabel.text isEqualToString:@"一键\n用车"]) {
        [MBProgressHUD showSuccess:@"一键用车" toView:nil];
        self.reGEOUtil.location = [AMapGeoPoint locationWithLatitude:self.nearestCarView.annotation.coordinate.latitude longitude:self.nearestCarView.annotation.coordinate.longitude];
        self.reGEOUtil.requireExtension = YES;
        
        [self.searchAPI AMapReGoecodeSearch:self.reGEOUtil];
        // 选中车辆的反地理编码
        // 计算直线距离
        int carDistance = (int)ceil([self distanceBetweenOrderBy:self.mapView.centerCoordinate :self.nearestCarView.annotation.coordinate]);
        int time = (int)ceil(carDistance/70.0);
        _disLab.text = [NSString stringWithFormat:@"距离%d米步行%d分钟",carDistance,time];
        
        if ([self.nearestCarView.annotation.title isEqualToString:@"汽车"]) {
            // 点击车辆之后，地图成为selected 状态
            self.lcMapState = LCMapStateSelected;
            self.centerAnnoView.hidden = YES;
            
            NSLog(@"annotationID = %@",self.nearestCarView.annotation.subtitle);
            // 先清除上一条
            [self clear];
            [self.pickedCarView  removeFromSuperview];
            self.pickedCarView.carInfoDelegate = nil;
            self.pickedCarView = nil;
            // view.canShowCallout = YES;
            self.centerAnnoView.selected = YES;
            self.nearestCarView.selected = NO;
            MAPointAnnotation * pA = self.nearestCarView.annotation;
            NSLog(@"annotationTapped==%f",pA.coordinate.latitude);
            
            [self drawActionWithDestination:pA.coordinate];
            
            /// for 循环找车辆信息
            for (int i = 0; i<_annViewArr.count; i++) {
                NSDictionary * a = _annViewArr[i];
                if ([a[@"id"] integerValue]== [self.nearestCarView.annotation.subtitle integerValue]) {
                    [self showPickedCarInfo:a];
                }
            }
            // 显示选中车辆信息
            self.tipBtn.hidden = YES;
            self.aviableCar.hidden = YES;
            self.carPositionView.hidden = NO;
        }
        
    }else{
        // > 扫码充电
        
        [self Code];
    }
    
    
    
}

#pragma mark = 显示选中车辆的信息
- (void) showPickedCarInfo:(NSDictionary *)pInfo{

    self.pickedCarView = [[PickedCarView alloc] initPickedCarViewWithInfo:pInfo];
    self.pickedCarView.carInfoDelegate = self;
    [self.view addSubview:self.pickedCarView];
    
    self.pickedCarView.transform = CGAffineTransformMakeTranslation(0, 320);
    [UIView animateWithDuration:0.3 animations:^{
        self.pickedCarView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 侧边栏事件 钱包、行程
-(void) slideAction:(NSInteger)actionTag{
    
    
    switch (actionTag) {
        case 0:
            
            break;
        case 1:
        {
            XCViewController * xcVC = [[XCViewController alloc] init];
            [self.navigationController pushViewController:xcVC animated:YES];
        }
            break;
        case 2:
        {
            WalletViewController * wVC = [[WalletViewController alloc] init];
            
//            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:wVC];
//            [nav setNavigationBarHidden:YES];
//            nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            [self presentViewController:nav animated:YES completion:nil];
            
        [self.navigationController pushViewController:wVC animated:YES];
            
        }
            break;
        case 3:
        {// 违章
            RuleController  * ruleVC = [[RuleController alloc] init];
            [self.navigationController pushViewController:ruleVC animated:YES];
        
        }
            break;
        case 4:
        {
            [self kefuAction];
        }
            break;
        case 5:
        {
            SettingViewController * setVC = [[SettingViewController alloc] init];
            
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;
        case 6:
        {// 一键登录
            User * cUser = [User getUser];
            switch (cUser.login_status.integerValue) {
                case 0:
                {// 未注册
                    LoginViewController * lVC = [[LoginViewController alloc] init];
                    UINavigationController * nav =[[UINavigationController alloc] initWithRootViewController:lVC];
                    
                    [nav setNavigationBarHidden:YES];
                  //  nav.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:nav animated:YES completion:nil];
                }
                    break;
                case 1:
                {// 未实名
                    // 认证
                    CertifyController * certifyVC = [[CertifyController  alloc] init];
                    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:certifyVC];
                    //   [self.navigationController pushViewController:nav animated:YES];
                    [self presentViewController:nav animated:YES completion:nil];
                }
                    break;
                case 2:
                {//未押金
                    UpDespositController * upDesposit = [[UpDespositController alloc] init];
                    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:upDesposit];
                    [self presentViewController:nav animated:YES completion:nil];
                }
                    break;
                case 3:
                {// 已交押金
                
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 7:
        { //点击头像 用户信息
            UserInfoController * userInfoVC = [[UserInfoController   alloc] init];
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
            break;
        case 8:
        { //点击余额 到 钱包界面
            WalletViewController * wVC = [[WalletViewController alloc] init];
 
            
            [self.navigationController pushViewController:wVC animated:YES];
        }
            break;
        case 9:
        { //点击保证金 到 保证金界面
            RuleController  * ruleVC = [[RuleController alloc] init];
            [self.navigationController pushViewController:ruleVC animated:YES];
        }
            break;
//===============- 底部三个按钮 -=============
        case 11:
        { //
            ActivityController * activityVC = [[ActivityController   alloc] init];
            [self.navigationController pushViewController:activityVC animated:YES];
        }
            break;case 12:
        { //
            HelpController * helpVC = [[HelpController   alloc] init];
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;case 13:
        { //
            ShareController * shareVC = [[ShareController   alloc] init];
            [self.navigationController pushViewController:shareVC animated:YES];
        }
            break;
        default:
            break;
    }
    
    
    
    [self coverOver:nil];
    
}

#pragma mark - 去充电
- (void) chargeActionWithCoordinate:(CLLocationCoordinate2D)coordinate{

    MapTool * mTool = [MapTool sharedMapTool];
    
    [mTool navigationActionWithCoordinate:coordinate WithENDName:@"目的充电桩" tager:self];
    
}

#pragma mark - 预定车辆的代理方法
#pragma mark * 立即预定
- (void) reserveRightNowWithInfo:(NSDictionary *)carInfo{

    NSLog(@"yuding");
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确认预定后将开始计费，10分钟内可免费取消行程，每天可免费取消一次。" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSLog(@"确认预定！");
//        ReserveInfoController * reserveVC = [[ReserveInfoController alloc] init];
        self.reserveVC.carInfo = carInfo;
        [self.navigationController pushViewController:self.reserveVC animated:YES];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void) questionActionWithType:(NSInteger)type{
    
    if (type == 1) {
        // 不计免赔说明
        NoPayController * noPayVC = [[NoPayController alloc] init];
        [self.navigationController pushViewController:noPayVC animated:YES];
        
    }else if (type == 2){
    // 价格说明
        // > 盖板视图
        [self.view addSubview:self.coverBtn];
        
        if (self.annoContentFlag == 0 ) {
            self.popCenterView = [[PopCenterView alloc] initWithType:1];
            self.popCenterView.center = CGPointMake(self.view.center.x, self.view.center.y-80);
            
            [self.view addSubview:self.popCenterView];
        }else if (self.annoContentFlag == 1){
            
            self.popCenterView = [[PopCenterView alloc] initWithType:2];
            self.popCenterView.center = CGPointMake(self.view.center.x, self.view.center.y-80);
            
            [self.view addSubview:self.popCenterView];
        }
    }else{
    
        
    }
    
    
    
    
   
    
}
#pragma mark * 计算两个坐标之间的距离
-(double)distanceBetweenOrderBy:(CLLocationCoordinate2D) p1 :(CLLocationCoordinate2D) p2{
    
    double lat1 = p1.latitude;
    double lng1 = p1.longitude;
    double lat2 = p2.latitude;
    double lng2 = p2.longitude;
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    
    return  distance;
    
}

#pragma mark * 导航
- (void) navAction:(UIButton *)btn {

    NSLog(@"ccccc");
    MapTool * mTool = [MapTool sharedMapTool];
    
    [mTool navigationActionWithCoordinate:self.destinationCoordinate WithENDName:@"目的车辆" tager:self];
}


@end
