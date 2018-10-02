//
//  NearByController.h
//  DouDouChong
//
//  Created by PC on 2018/4/27.
//  Copyright © 2018年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol NearProtocol <NSObject>

- (void) chooseNearCarWithInfo:(NSDictionary *)carDic;

@end

@interface NearByController : UIViewController

/** 代理 */
@property (nonatomic,weak) id<NearProtocol> nearDelegate;
/** 我 当前的位置坐标 */
@property (nonatomic,assign) CLLocationCoordinate2D myLocation;
/** 附近的车辆数组 */
@property (nonatomic,strong) NSMutableArray * nearCarArr;

@end
