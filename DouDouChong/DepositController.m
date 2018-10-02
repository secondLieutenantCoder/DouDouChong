//
//  DepositController.m
//  DouDouChong
//
//  Created by PC on 2018/6/1.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "DepositController.h"

@interface DepositController ()

@property (weak, nonatomic) IBOutlet UIButton *getDepositBtn;

@end

@implementation DepositController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNav];
    
    self.getDepositBtn.layer.cornerRadius = 5;
   
}

#pragma mark - 申请退回
- (IBAction)tuihuiAction:(id)sender {
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
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void) rightAction{
    
    NSLog(@"报销停车费");
}

@end
