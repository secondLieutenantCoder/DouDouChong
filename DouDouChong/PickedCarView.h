//
//  PickedCarView.h
//  DouDouChong
//
//  Created by PC on 2018/5/20.
//  Copyright © 2018年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CarInfoProtocol <NSObject>


/**
 立即预定
 */
- (void) reserveRightNowWithInfo:(NSDictionary *)carInfo;


/**
 预定车辆的问号按钮

 @param type 问号类型
 */
- (void) questionActionWithType:(NSInteger)type;

@end

@interface PickedCarView : UIView


@property (nonatomic,weak) id<CarInfoProtocol> carInfoDelegate;


/** 展示车辆信息 */
- (instancetype)initPickedCarViewWithInfo:(NSDictionary *)infoDic;




@end
