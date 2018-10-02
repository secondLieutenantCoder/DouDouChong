//
//  PopCenterView.m
//  DouDouChong
//
//  Created by PC on 2018/6/7.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "PopCenterView.h"

@implementation PopCenterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithType:(NSInteger)type
{
    self = [super initWithFrame:CGRectMake(0, 0, 240, 320)];
    if (self) {
        
        [self setSubViewsWithType:type];
        
    }
    return self;
}

- (void) setSubViewsWithType:(NSInteger)type{

    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView * topBack = [[UIImageView    alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 120)];
    topBack.backgroundColor = [UIColor blueColor];
    [self addSubview:topBack];
    
    UIImageView * carImg = [[UIImageView alloc] initWithFrame:CGRectMake((240-120)/2.0, 5, 120, 80)];
    carImg.image = [UIImage imageNamed:@"showCar"];
    [topBack addSubview:carImg];
    
    UILabel * carLab = [[UILabel alloc] initWithFrame:CGRectMake(carImg.frame.origin.x, CGRectGetMaxY(carImg.frame), 120, 25)];
    carLab.text = @"江淮IEV6E";
    carLab.font = [UIFont systemFontOfSize:15];
    carLab.textAlignment = NSTextAlignmentCenter;
    carLab.textColor = [UIColor whiteColor];
    [topBack addSubview:carLab];
    // >分时租车
    UIButton * fBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(topBack.frame)+5, 20, 20)];
    [fBtn1 setImage:[UIImage imageNamed:@"login_unchecked"] forState:UIControlStateNormal];
    [fBtn1 setImage:[UIImage imageNamed:@"login_checked"] forState:UIControlStateSelected];
    [self addSubview:fBtn1];
    UILabel * tLab1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fBtn1.frame)+5, fBtn1.frame.origin.y, 100, 25)];
    tLab1.text = @"分时租车";
    tLab1.font = [UIFont systemFontOfSize:15];
    [self addSubview:tLab1];
    
    UILabel * contentLab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tLab1.frame)+5, 180, 20)];
    contentLab1.text = @"0.05元/分钟+0.6元/公里";
    contentLab1.font = [UIFont systemFontOfSize:12];
    [self addSubview:contentLab1];
    
    UILabel * contentLab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(contentLab1.frame), 180, 20)];
    contentLab2.text = @"单笔订单最低消费1.0元";
    contentLab2.font = [UIFont systemFontOfSize:12];
    [self addSubview:contentLab2];
    
    UILabel * contentLab3 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(contentLab2.frame), 180, 20)];
    contentLab3.text = @"基础保险费2.0元";
    contentLab3.font = [UIFont systemFontOfSize:12];
    [self addSubview:contentLab3];
   
    
    // >日租租车
    UIButton * fBtn2 = [[UIButton    alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(contentLab3.frame)+10, 20, 20)];
    [fBtn2 setImage:[UIImage imageNamed:@"login_unchecked"] forState:UIControlStateNormal];
    [fBtn2 setImage:[UIImage imageNamed:@"login_checked"] forState:UIControlStateSelected];
    [self addSubview:fBtn2];
    
    UILabel * tLab2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fBtn2.frame)+5, fBtn2.frame.origin.y, 100, 25)];
    tLab2.font = [UIFont systemFontOfSize:15];
    tLab2.text = @"日租租车";
    tLab2.textColor = [UIColor lightGrayColor];
    [self addSubview:tLab2];
    
    UILabel * contentLab4 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tLab2.frame), 180, 60)];
    contentLab4.numberOfLines = 3;
    //contentLab4.adjustsFontSizeToFitWidth = YES;
    contentLab4.font = [UIFont systemFontOfSize:12];
    contentLab4.text = @"125.0元/天(含6元基础保险费),逾期两小时内收取15.0元,超过两小时按整天收取";
    contentLab4.textColor = [UIColor lightGrayColor];
    [self addSubview:contentLab4];
    
    /// > type 1 分时租车    type 2 日租车
    if (type == 1) {
        fBtn1.selected = YES;
        fBtn2.selected = NO;
        
//         contentLab1.font = [UIFont systemFontOfSize:12];
//         contentLab2.font = [UIFont systemFontOfSize:12];
//         contentLab3.font = [UIFont systemFontOfSize:12];
        contentLab1.textColor = [UIColor darkTextColor];
        contentLab2.textColor = [UIColor darkTextColor];
        contentLab3.textColor = [UIColor darkTextColor];
        
//        tLab1.font = [UIFont systemFontOfSize:14];
        tLab1.textColor = [UIColor darkTextColor];
        tLab2.textColor = [UIColor lightGrayColor];
        
        contentLab4.textColor = [UIColor lightGrayColor];
        
    }else{
        fBtn1.selected = NO;
        fBtn2.selected = YES;
        
        contentLab1.textColor = [UIColor lightGrayColor];
        contentLab2.textColor = [UIColor lightGrayColor];
        contentLab3.textColor = [UIColor lightGrayColor];
        
        contentLab4.textColor = [UIColor darkTextColor];
        
        tLab2.textColor = [UIColor darkTextColor];
        tLab1.textColor = [UIColor lightGrayColor];
    
    }
    
}


@end
