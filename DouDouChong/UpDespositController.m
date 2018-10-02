//
//  UpDespositController.m
//  DouDouChong
//
//  Created by PC on 2018/6/16.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "UpDespositController.h"
#import "XieYiControllerViewController.h"

@interface UpDespositController ()
@property (weak, nonatomic) IBOutlet UIButton *zfbBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *despositBtn;
@property (weak, nonatomic) IBOutlet UIButton *xieyiBtn;

@end

@implementation UpDespositController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.despositBtn.layer.cornerRadius  = 5;
    self.despositBtn.layer.masksToBounds = YES;
    
    self.zfbBtn.selected = YES;
    
    [self setNav];
    
}
#pragma mark - 立即缴费
- (IBAction)jiaofeiAction:(id)sender {
    // 缴费
    
    
}
#pragma mark - 缴费协议
- (IBAction)xieyiAction:(id)sender {
    
    XieYiControllerViewController * xieyiVC = [[XieYiControllerViewController alloc] init];
    [self.navigationController pushViewController:xieyiVC animated:YES];
    
}
#pragma mark - 选择支付宝支付
- (IBAction)zhifubaoAction:(UIButton *)sender {
    sender.selected = YES;
    self.wxBtn.selected = NO;
    
}
#pragma mark - 选择微信支付
- (IBAction)weixinAction:(UIButton *)sender {
    
    sender.selected = YES;
    self.zfbBtn.selected = NO;
    
}



- (void) setNav{
    
    self.title = @"违章保证金";
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_gray"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [rightBtn setTitle:@"退回历史" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
}

- (void) leftBtn:(UIButton *)btn{
    
    
  //  [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) rightAction{
    
    NSLog(@"报销停车费");
}

@end
