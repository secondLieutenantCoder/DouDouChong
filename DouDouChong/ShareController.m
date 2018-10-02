//
//  ShareController.m
//  DouDouChong
//
//  Created by PC on 2018/6/23.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "ShareController.h"

@interface ShareController ()

@end

@implementation ShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
}

- (void) setNav{
    
    self.title = @"邀请好友";
    
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
