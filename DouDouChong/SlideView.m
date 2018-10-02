//
//  SlideView.m
//  DouDouChong
//
//  Created by PC on 2018/3/6.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "SlideView.h"

#define wwBlue [UIColor colorWithRed:38/255.0 green:149/255.0 blue:241/255.0 alpha:1]

@implementation SlideView{

    /** 用户当前的登陆状态 */
    UIButton * _loginBtn;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void) setSubViews{

    // 1 头像
    
    UIImageView * iconView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 60, 60)];
    iconView.layer.cornerRadius = 30;
    iconView.layer.masksToBounds = YES;
//    iconView.backgroundColor    = [UIColor magentaColor];
    iconView.image = [UIImage imageNamed:@"yonghuDefault"];
    iconView.userInteractionEnabled = YES;
    iconView.tag = 7;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconAction:)];
    [iconView addGestureRecognizer:tap];
    [self addSubview:iconView];
    
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame)+10, 50, 70, 30)];
    [_loginBtn setTitle:@"一键登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:wwBlue forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = 15;
    _loginBtn.layer.borderColor  = wwBlue.CGColor;
    _loginBtn.layer.borderWidth  = 1;
    _loginBtn.titleLabel.font    = [UIFont systemFontOfSize:13];
    _loginBtn.tag = 6;
    [_loginBtn addTarget:self action:@selector(slideViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginBtn];
    
    // 2 金额
    UIView *hLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, 120, kWidth*0.6, 0.5)];
    hLine1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:hLine1];
    UIView * hLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hLine1.frame)+65, kWidth*0.6, 0.5)];
    hLine2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:hLine2];
    
    UIView * vLine1 = [[UIView alloc] initWithFrame:CGRectMake(kWidth*0.3, 7+CGRectGetMaxY(hLine1.frame), 0.5, 50)];
    vLine1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:vLine1];
    // 来贝
    UIButton * lbBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, hLine1.frame.origin.y+2, vLine1.frame.origin.x-1, 60)];
    // 点击豆豆币到钱包
    lbBtn.tag = 8;
  [lbBtn addTarget:self action:@selector(slideViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [lbBtn setTitle:@"豆豆币\n10" forState:UIControlStateNormal];
    [lbBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    lbBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    lbBtn.titleLabel.numberOfLines = 2;
    lbBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:lbBtn];
    
    // 保证金
    UIButton * depositBtn = [[UIButton alloc] initWithFrame:CGRectMake(vLine1.frame.origin.x+2, lbBtn.frame.origin.y, lbBtn.frame.size.width, 60)];
    depositBtn.tag = 9;
    [depositBtn addTarget:self action:@selector(slideViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [depositBtn setTitle:@"违章保证金\n 10.0" forState:UIControlStateNormal];
    [depositBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    depositBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    depositBtn.titleLabel.numberOfLines = 2;
    depositBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:depositBtn];
    
    
    // 3 菜单
    UIButton * xcBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(hLine2.frame)+10, kWidth*0.5, 35)];
    [xcBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [xcBtn addTarget:self action:@selector(slideViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [xcBtn setImage:[UIImage imageNamed:@"main_left_xingcheng"] forState:UIControlStateNormal];
    [xcBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
   [xcBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    xcBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [xcBtn setTitle:@"行程" forState:UIControlStateNormal];
    xcBtn.tag = 1;
    [self addSubview:xcBtn];
    
    UIButton * walletBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(xcBtn.frame)+5, kWidth*0.5, 35)];
    [walletBtn setTitle:@"钱包" forState:UIControlStateNormal];
    [walletBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [walletBtn addTarget:self action:@selector(slideViewAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [walletBtn setImage:[UIImage imageNamed:@"main_left_qianbao"] forState:UIControlStateNormal];
    [walletBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [walletBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    walletBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    walletBtn.tag = 2;
    [self addSubview:walletBtn];
    
    UIButton * ruleBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(walletBtn.frame)+5, kWidth*0.5, 35)];
    [ruleBtn setTitle:@"违章" forState:UIControlStateNormal];
    [ruleBtn addTarget:self action:@selector(slideViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [ruleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [ruleBtn setImage:[UIImage imageNamed:@"main_left_weizhang"] forState:UIControlStateNormal];
    [ruleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [ruleBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    ruleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    ruleBtn.tag = 3;
    [self addSubview:ruleBtn];
    
    UIButton * serviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(ruleBtn.frame)+5, kWidth*0.5, 35)];
    [serviceBtn setTitle:@"客服" forState:UIControlStateNormal];
    [serviceBtn addTarget:self action:@selector(slideViewAction:) forControlEvents:UIControlEventTouchUpInside];

    [serviceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [serviceBtn setImage:[UIImage imageNamed:@"main_left_kefu"] forState:UIControlStateNormal];
    [serviceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [serviceBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    serviceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    serviceBtn.tag = 4;
    [self addSubview:serviceBtn];
    
    UIButton * settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(serviceBtn.frame)+5, kWidth*0.5, 35)];
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(slideViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [settingBtn setImage:[UIImage imageNamed:@"main_left_shezhi"] forState:UIControlStateNormal];
    [settingBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [settingBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    settingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    settingBtn.tag= 5;
    [self addSubview:settingBtn];
    
    // 底部
    CGFloat space = (kWidth*0.6-60*3)/4.0;
    UIButton * activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(space, kHeight-70, 60, 60)];
    [activityBtn setTitle:@"活动" forState:UIControlStateNormal];
    [activityBtn setImage:[UIImage imageNamed:@"main_left_huodong"] forState:UIControlStateNormal];
    [activityBtn setImageEdgeInsets:UIEdgeInsetsMake(-15, 10, 0, 0)];
    [activityBtn setTitleEdgeInsets:UIEdgeInsetsMake(40, -40, 0, 0)];
    activityBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [activityBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    activityBtn.tag = 11;
    [activityBtn addTarget:self action:@selector(slideViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:activityBtn];
    
    UIButton * helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(60+2*space, kHeight-70, 60, 60)];
   
    [helpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [helpBtn addTarget:self action:@selector(slideViewAction:) forControlEvents:UIControlEventTouchUpInside];
    helpBtn.tag = 12;
    [helpBtn setImage:[UIImage imageNamed:@"main_left_bangzhu"] forState:UIControlStateNormal];
    [helpBtn setImageEdgeInsets:UIEdgeInsetsMake(-15, 10, 0, 0)];
    [helpBtn setTitleEdgeInsets:UIEdgeInsetsMake(40, -40, 0, 0)];
    helpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [helpBtn setTitle:@"帮助" forState:UIControlStateNormal];
    [self addSubview:helpBtn];
    
    UIButton * shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(60+60+3*space, kHeight-70, 60, 60)];
   [shareBtn addTarget:self action:@selector(slideViewAction:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.tag = 13;
    [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"main_left_fenxiang"] forState:UIControlStateNormal];
    [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(-15, 10, 0, 0)];
    [shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(40, -30, 0, 0)];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [shareBtn setTitle:@"推荐有奖" forState:UIControlStateNormal];
    [self addSubview:shareBtn];
    
    
}

#pragma mark - 页面按钮点击事件
- (void) slideViewAction:(UIButton *) slideBtn{

    /*
     1行程  2 钱包 3 违章 4 客服  5  设置
     6一键登录
     */
    [self.slideDelegate slideAction:slideBtn.tag];
}

#pragma mark - 头像手势，用户资料
- (void) iconAction:(UITapGestureRecognizer *)tap{
// 头像 7
    [self.slideDelegate slideAction:7];
    
    
}

#pragma mark - 显示侧边栏的时候更新信息
- (void) reloadSlideInfo{

    
    User * user = [User getUser];
    switch (user.login_status.integerValue) {
        case 0:
        {
            [_loginBtn setTitle:@"一键登录" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [_loginBtn setTitle:@"未认证" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [_loginBtn setTitle:@"未交押金" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [_loginBtn setTitle:@"已交押金" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

@end
