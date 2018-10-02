//
//  UsingCarController.m
//  DouDouChong
//
//  Created by PC on 2018/6/3.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "UsingCarController.h"
#import "PayBillController.h"

@interface UsingCarController ()

/**
 租车状态 - 租赁中
 */
@property (weak, nonatomic) IBOutlet UILabel *stateLab;

/**
 归属
 */
@property (weak, nonatomic) IBOutlet UILabel *guishu;

/**
 归属地
 */
@property (weak, nonatomic) IBOutlet UILabel *guishudi;


/**
 充电按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn;


/**
 蓝牙钥匙
 */
@property (weak, nonatomic) IBOutlet UIButton *blueKey;

/**
 开锁
 */
@property (weak, nonatomic) IBOutlet UIButton *openBtn;

/**
 寻车
 */
@property (weak, nonatomic) IBOutlet UIButton *findBtn;

/**
 锁车
 */
@property (weak, nonatomic) IBOutlet UIButton *lockBtn;


@end

@implementation UsingCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    
    [self setSubViews];
}


-(void) setSubViews{
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:246/255.0 alpha:1];

    self.stateLab.layer.cornerRadius = 10;
    self.stateLab.layer.masksToBounds = YES;
    
    self.guishudi.layer.cornerRadius = 5;
    self.guishu.layer.cornerRadius = 5;
    self.guishu.layer.borderWidth  = 0.6;
    self.guishu.layer.borderColor  = [UIColor grayColor].CGColor;
    
    self.chargeBtn.layer.cornerRadius = 15;
    self.chargeBtn.layer.borderWidth  = 1;
    self.chargeBtn.layer.borderColor  = kGreenColor.CGColor;
    
    [self.blueKey setImageEdgeInsets:UIEdgeInsetsMake(-10, 185, 0, 0)];
    [self.blueKey setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    self.openBtn.layer.cornerRadius = 20;
    self.openBtn.layer.masksToBounds = YES;
    self.openBtn.layer.borderWidth   = 1;
    self.openBtn.layer.borderColor  = [UIColor grayColor].CGColor;
    
    self.findBtn.layer.cornerRadius = 20;
    self.findBtn.layer.masksToBounds = YES;
    self.findBtn.layer.borderWidth   = 1;
    self.findBtn.layer.borderColor  = [UIColor grayColor].CGColor;
    
    self.lockBtn.layer.cornerRadius = 20;
    self.lockBtn.layer.masksToBounds = YES;
    self.lockBtn.layer.borderWidth   = 1;
    self.lockBtn.layer.borderColor  = [UIColor grayColor].CGColor;
    
}

#pragma mark - 充电
- (IBAction)chargeAtion:(id)sender {
}

#pragma mark - 启用蓝牙钥匙
- (IBAction)useBlueKeyAction:(id)sender {
}

#pragma mark - 开锁
- (IBAction)openAction:(id)sender {
}
#pragma mark - 寻车
- (IBAction)findAction:(id)sender {
}
#pragma mark - 锁车
- (IBAction)lockAction:(id)sender {
}

- (void) setNav{
    
    self.title = @"租车详情";
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_gray"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    // [rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightBtn setTitle:@"确认还车" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kGreenColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
}

- (void) leftBtn:(UIButton *)btn{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark - 确认还车
- (void) rightAction{
    
  //  NSLog(@"报销停车费");
    PayBillController   * payVC = [[PayBillController alloc] init];
    
    [self.navigationController pushViewController:payVC animated:YES];
}

@end
