//
//  ActivityController.m
//  DouDouChong
//
//  Created by PC on 2018/6/23.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "ActivityController.h"

@interface ActivityController ()

@end

@implementation ActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
}

- (void) setNav{
    
    self.title = @"活动中心";
    
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
