//
//  ChargeView.h
//  DouDouChong
//
//  Created by PC on 2018/7/6.
//  Copyright © 2018年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@protocol ChargeProtocool <NSObject>

- (void) chargeActionWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end

@interface ChargeView : UIView

@property (nonatomic,weak) id<ChargeProtocool> chargeDelegate;

/** 初始化充电桩视图 */
-(instancetype)initChanrgeViewWithInfo:(CLLocationCoordinate2D )coordinate;

// 子视图
@property (nonatomic,strong) UILabel * nameLab;

@property (nonatomic,strong) UILabel * addressLab;

@property (nonatomic,strong) UILabel * distanceLab;

@end
