//
//  ChargeView.m
//  DouDouChong
//
//  Created by PC on 2018/7/6.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "ChargeView.h"

@implementation ChargeView{

    CLLocationCoordinate2D _coordinate;
    
}



-(instancetype)initChanrgeViewWithInfo:(CLLocationCoordinate2D)coordinate{

    self = [super init];
    if (self) {
        
        [self setSubViews];
        _coordinate = coordinate;
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//        [self setSubViews];
//        
//    }
//    return self;
//}


- (void) setSubViews{

    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(10, kHeight-240-64, kWidth-20, 240);
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, (kWidth-30)*0.7, 35)];
    _nameLab.text = @"潍坊市临朐金成大酒店充电站";
    _nameLab.textColor = [UIColor darkTextColor];
    
    [self addSubview:_nameLab];
    
    _distanceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLab.frame), 10, (kWidth-30)*0.3, 35)];
    _distanceLab.text = @"2.2km";
    _distanceLab.textColor = [UIColor grayColor];
    _distanceLab.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_distanceLab];
    
    _addressLab = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_nameLab.frame), kWidth-30, 35)];
    _addressLab.text = @"山东省潍坊市临朐县民主路4938号";
    _addressLab.font = [UIFont systemFontOfSize:13];
    _addressLab.textColor = [UIColor grayColor];
    
    [self addSubview:_addressLab];
    
    UIView * horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_addressLab.frame), kWidth-40, 1)];
    horizontalLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:horizontalLine];
    
    
    UIView * verticalLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0, CGRectGetMaxY(horizontalLine.frame)+30, 1, 60)];
    verticalLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:verticalLine];
    
    
    UIButton * chargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.frame.size.height-40, (kWidth-40), 35)];
    [chargeBtn setTitle:@"到这里充电" forState:UIControlStateNormal];
    chargeBtn.backgroundColor = [UIColor blueColor];
    [chargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chargeBtn addTarget:self action:@selector(chargeViewAction) forControlEvents:UIControlEventTouchUpInside];
    chargeBtn.layer.cornerRadius = 6;
    
    [self addSubview:chargeBtn];
    
}

- (void) chargeViewAction{

    [self.chargeDelegate chargeActionWithCoordinate:_coordinate];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
