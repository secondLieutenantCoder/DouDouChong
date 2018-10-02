//
//  PickedCarView.m
//  DouDouChong
//
//  Created by PC on 2018/5/20.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "PickedCarView.h"

@implementation PickedCarView{

    /** 车辆信息 */
    NSDictionary * _carInfo;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initPickedCarViewWithInfo:(NSDictionary *)infoDic
{
    self = [super init];
    if (self) {
        [self setSubViewsWithInfo:infoDic];
        _carInfo = infoDic;
    }
    return self;
}

- (void) setSubViewsWithInfo:(NSDictionary *)pInfo{

    self.frame = CGRectMake(0, kHeight-260-64, kWidth, 260);
    self.layer.cornerRadius = 10;
    self.backgroundColor = themeColor;
    
    UIView * bView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kWidth, 230)];
    bView.backgroundColor = [UIColor whiteColor];
    bView.layer.cornerRadius = 10;
    [self addSubview:bView];
    
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 80, 20)];
    title.text = @"不计免赔";
    title.textColor = [UIColor whiteColor];
    [self addSubview:title];
    
    UIButton * qBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), 5, 20, 20)];
    [qBtn setImage:[UIImage imageNamed:@"icon_wenhao_white"] forState:UIControlStateNormal];
    [qBtn addTarget:self action:@selector(mianPeiAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:qBtn];
    
    UILabel * ly = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-100, 5, 40, 20)];
    ly.text = @"两元";
    ly.textAlignment = NSTextAlignmentCenter;
    ly.textColor = [UIColor whiteColor];
    [self addSubview:ly];
    
    UIButton * chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ly.frame), 5, 20, 20)];
    [chooseBtn setImage:[UIImage imageNamed:@"login_unchecked"] forState:UIControlStateNormal];
    [chooseBtn setImage:[UIImage imageNamed:@"login_checked"] forState:UIControlStateSelected];
    [chooseBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    chooseBtn.layer.cornerRadius = 10;
    chooseBtn.layer.masksToBounds = YES;
    chooseBtn.selected = YES;
    chooseBtn.backgroundColor   = [UIColor whiteColor];
    [self addSubview:chooseBtn];
    
    // 显示汽车信息
    // 车牌
    UILabel * carNo = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 30)];
    carNo.text = pInfo[@"num"];
    carNo.textAlignment = NSTextAlignmentCenter;
    carNo.layer.cornerRadius = 5;
    carNo.layer.borderWidth  = 0.5;
    carNo.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    [bView addSubview:carNo];
    
    // 归属
    UILabel * gs = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(carNo.frame)+5, 20, 30, 20)];
    gs.text = @"归属";
    gs.textColor = [UIColor lightGrayColor];
    gs.layer.cornerRadius = 3;
    gs.font = [UIFont systemFontOfSize:11];
    gs.layer.cornerRadius = 3;
    gs.layer.borderWidth  = 0.5;
    gs.textAlignment      = NSTextAlignmentCenter;
    gs.layer.borderColor  = [UIColor grayColor].CGColor;
    [bView addSubview:gs];
    
    UILabel * areaLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gs.frame), 20, 45, 20)];
    areaLab.textColor = [UIColor whiteColor];
    areaLab.text      = pInfo[@"city"];
    areaLab.layer.cornerRadius = 3;
    areaLab.font               = [UIFont systemFontOfSize:12];
    areaLab.textAlignment      = NSTextAlignmentCenter;
    areaLab.backgroundColor = [UIColor grayColor];
    [bView addSubview:areaLab];
    
    // 汽车类型
    UILabel * carBrand = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(carNo.frame)+5, 150, 30)];
    carBrand.text = [NSString stringWithFormat:@"%@ |%ld座",pInfo[@"type"],[pInfo[@"seat_num"] integerValue]];
    //@"江淮IEV6E | 5座";
    carBrand.textColor = [UIColor lightGrayColor];
    carBrand.font = [UIFont systemFontOfSize:13];
    [bView addSubview:carBrand];
    
    // 电池
    UIImageView * batteryImg = [[UIImageView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(carBrand.frame)+10, 30, 20)];
    batteryImg.image = [UIImage imageNamed:@"car_battary_img"];
    [bView addSubview:batteryImg];
    
    // 续航
    UILabel * continueLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(batteryImg.frame)+10, CGRectGetMaxY(carBrand.frame)+5, 120, 30)];
    continueLab.font = [UIFont systemFontOfSize:12];
    continueLab.text = [NSString stringWithFormat:@" %ld%@ 续航约%ldkm",[pInfo[@"continue_ele"] integerValue],@"%",[pInfo[@"continue_dis"] integerValue]];
    // @"60%  续航约88km";
    [bView addSubview:continueLab];
    
    // 方式
    UIView * kindView = [[UIView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(continueLab.frame)+5, kWidth-50, 30)];
    kindView.layer.cornerRadius = 15;
    kindView.layer.borderWidth  = 0.6;
    kindView.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    // 价格 ： 0.05元/分钟+0.8元/公里|单笔订单最低消费1元
    UILabel * priceLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kindView.frame.size.width-40, 30)];
    priceLab.adjustsFontSizeToFitWidth = YES;
    priceLab.font = [UIFont systemFontOfSize:11];
   // priceLab.backgroundColor = [UIColor redColor];
    NSMutableAttributedString * priceStr = [[NSMutableAttributedString alloc] initWithString:@"0.05元/分钟+0.8元/公里|单笔订单最低消费1元"];
    NSDictionary * attriDic = @{NSForegroundColorAttributeName:kGreenColor};
    [priceStr addAttributes:attriDic range:NSMakeRange(0, 4)];
    [priceStr addAttributes:attriDic range:NSMakeRange(9, 3)];
    [priceStr addAttributes:attriDic range:NSMakeRange(25, 1)];
    priceLab.attributedText = priceStr;
    [kindView addSubview:priceLab];
    // 问号
    UIButton * priceQ = [[UIButton alloc] initWithFrame:CGRectMake(kindView.frame.size.width-40, 0, 30, 30)];
    [priceQ setImage:[UIImage imageNamed:@"icon_wenhao_gray"] forState:UIControlStateNormal];
    [priceQ addTarget:self action:@selector(priceQuestionAction) forControlEvents:UIControlEventTouchUpInside];
    [kindView addSubview:priceQ];
    
    [bView addSubview:kindView];
    
    // 立即预定
    UIButton * reserveBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(kindView.frame)+10, kWidth-40, 40)];
    reserveBtn.backgroundColor = themeColor;
    reserveBtn.layer.cornerRadius = 20;
    [reserveBtn setTitle:@"立即预定" forState:UIControlStateNormal];
    reserveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [reserveBtn addTarget:self action:@selector(reserveAction) forControlEvents:UIControlEventTouchUpInside];
    [bView addSubview:reserveBtn];
    
    // 汽车图片
    UIImageView * carImg = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth-(bView.frame.size.height-kindView.frame.origin.y+10)/2.0*3.0, 0, (bView.frame.size.height-kindView.frame.origin.y+10)/2.0*3.0, bView.frame.size.height-kindView.frame.origin.y+10)];
    carImg.image = [UIImage imageNamed:@"showCar"];
    [bView addSubview:carImg];
    
}

#pragma mark - 立即预定
- (void) reserveAction{

    
    [self.carInfoDelegate reserveRightNowWithInfo:_carInfo];
    
    
}

#pragma mark - 租车价格说明
- (void) priceQuestionAction{

    NSLog(@"price - price");
    [self.carInfoDelegate questionActionWithType:2];
    
}
#pragma mark - 不计免赔说明
- (void) mianPeiAction{

    NSLog(@"不计免赔");
    [self.carInfoDelegate questionActionWithType:1];
}
#pragma mark - 是否勾选不计免赔
- (void) chooseAction:(UIButton *)btn{

    btn.selected = !btn.selected;
    
    
    NSLog(@"chooseAction");
    
    
    
}

@end
