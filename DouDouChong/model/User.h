//
//  User.h
//  DouDouChong
//
//  Created by PC on 2018/6/8.
//  Copyright © 2018年 PC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject


+ (instancetype) getUser;


/** 字典转对象 */
-(void) setUserDataWithInfoData:(NSDictionary *)infoDic;

// ======== - 属性 - ===========
@property (nonatomic,assign) NSInteger id;

/** 姓名 */
@property (nonatomic,copy) NSString * name;
/** 登录状态 0 1 2 3 未注册  未实名 未缴纳押金  已缴纳押金 */
@property(nonatomic,copy) NSString * login_status;
/** 汽车租赁状态 0 1 2 3 未租赁 已预订 已确认 已开锁 */
@property (nonatomic,copy) NSString * car_status;
/** 身份证号 */
@property (nonatomic,copy) NSString * id_card;
/** 驾驶证号码 */
@property (nonatomic,copy) NSString * driver_card;
/** 驾驶证开始日期 */
@property (nonatomic,copy) NSString * driver_begintime;
/** 驾驶证结束日期 */
@property (nonatomic,copy) NSString * driver_endtime;
/** 驾照类型 A1  B1 C1   */
@property (nonatomic,copy) NSString * driver_type;
/** 是否实名 */
@property (nonatomic,copy) NSString * is_shiming;
/** 昵称 */
@property (nonatomic,copy) NSString * nickname;
/** 邮箱 */
@property (nonatomic,copy) NSString * email;
/** 微信名 */
@property (nonatomic,copy) NSString * wx_name;
/** qq名 */
@property (nonatomic,copy) NSString * qq_name;
/** 行业 */
@property (nonatomic,copy) NSString * hangye;
/** 职业 */
@property (nonatomic,copy) NSString * zhiye;
/** 行业 English */
@property (nonatomic,copy) NSString * industry;
/** 职业 */
@property (nonatomic,copy) NSString * profession;
/**
 电话
 */
@property (nonatomic,copy) NSString * tel;
/** 头像 */
@property (nonatomic,copy) NSString * head;
/** 
  唯一码
 */
@property (nonatomic,copy) NSString * unique_id;
/** 城市 */
@property (nonatomic,copy) NSString * city;
/** 押金 */
@property (nonatomic,assign) double deposit;
/** 用户总里程 */
@property (nonatomic,assign) double all_mileage;
/** 用户出行次数 */
@property (nonatomic,assign) NSInteger go_count;
/** 全部毛毛币 */
@property (nonatomic,assign) double all_money;
/** 剩余毛毛币 */
@property (nonatomic,assign) double remain_money;
/** 充值金额 */
@property (nonatomic,assign) double recharge_money;
/** 赠送毛毛币 */
@property (nonatomic,assign) double award_money;
/** 话费毛毛币 */
@property (nonatomic,assign) double pay_money;
/** 注册时间 */
@property (nonatomic,copy) NSString * register_time;
/** 更新时间 */
@property (nonatomic,copy) NSString * update_time;

@end
