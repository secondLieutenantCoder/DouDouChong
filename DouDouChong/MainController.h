//
//  MainController.h
//  DouDouChong
//
//  Created by PC on 2018/3/5.
//  Copyright © 2018年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 地图状态，
 normal ： 正常的拖动刷新
 selected : 选中状态时，不刷新地图上的车辆
 */
typedef enum : NSUInteger {
    LCMapStateNone,
    LCMapStateNormal,
    LCMapStateSelected,
} LCMapState;

@interface MainController : UIViewController

@property (nonatomic,assign) LCMapState lcMapState;


/** 区分显示车辆位置和充电桩位置 0 1 车辆 2 充电桩  */
@property (nonatomic,assign) NSInteger annoContentFlag;


@end
