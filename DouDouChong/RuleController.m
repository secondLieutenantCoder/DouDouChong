//
//  RuleController.m
//  DouDouChong
//
//  Created by PC on 2018/6/21.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "RuleController.h"

@interface RuleController ()

@end

@implementation RuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNav];
    self.view.backgroundColor = [UIColor whiteColor];
}



- (void) setNav{
    
    self.title = @"我的违章";
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_gray"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    
    
}

- (void) leftBtn:(UIButton *)btn{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
