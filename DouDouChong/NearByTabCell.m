//
//  NearByTabCell.m
//  DouDouChong
//
//  Created by PC on 2018/4/27.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "NearByTabCell.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
// 定位 围栏
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>


@interface NearByTabCell ()<AMapSearchDelegate>

@property (nonatomic,strong) AMapReGeocodeSearchRequest * reGEOUtil;

@property (nonatomic,strong) AMapSearchAPI * searchAPI;

@end

@implementation NearByTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.buttomView.layer.cornerRadius = 15;
    self.buttomView.layer.borderWidth  = 0.5;
    self.buttomView.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    
    self.carNum.layer.cornerRadius = 3;
    self.carNum.layer.borderWidth = 0.5f;
    self.carNum.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.carNum.layer.masksToBounds = YES;
    self.carNum.textAlignment = NSTextAlignmentCenter;
    
    self.belongArea.layer.cornerRadius = 5;
    self.belongArea.layer.masksToBounds = YES;
    
    self.guiShu.layer.cornerRadius = 5;
    self.guiShu.layer.borderWidth  = 0.5;
    self.guiShu.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    
    self.position.numberOfLines = 2;
    self.position.adjustsFontSizeToFitWidth = YES;
    
    self.contunuePower.adjustsFontSizeToFitWidth = YES;
   // self.selectionStyle = UITableViewCellSelectionStyleNone;
    _reGEOUtil = [[AMapReGeocodeSearchRequest alloc] init];
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
}


-(void)setCoordinate:(CLLocationCoordinate2D)coordinate{

    _coordinate  = coordinate;
    
    
    self.reGEOUtil.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    self.reGEOUtil.requireExtension = YES;
    //    AMapGeocodeSearchRequest * request = [[AMapGeocodeSearchRequest alloc] init];
    
    [self.searchAPI AMapReGoecodeSearch:self.reGEOUtil];
    // 选中车辆的反地理编码
    // 计算直线距离
    int carDistance = (int)ceil([self distanceBetweenOrderBy:self.myLocation :self.coordinate]);
    
    self.distance.text = [NSString stringWithFormat:@"%.1fkm",carDistance/1000.0];
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
        
//        if (self.annoContentFlag == 0 || self.annoContentFlag == 1) {
//            // > 设置汽车参数
//            _carPositionLab.text = response.regeocode.formattedAddress;
//            
//        }else{
//            // > 设置充电桩参数
//            self.chargeView.addressLab.text = response.regeocode.formattedAddress;
//            
//        }
        
        self.position.text = response.regeocode.formattedAddress;
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
