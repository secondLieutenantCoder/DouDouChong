//
//  PayCompleteController.m
//  DouDouChong
//
//  Created by PC on 2018/6/3.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "PayCompleteController.h"

@interface PayCompleteController ()
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation PayCompleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:246/255.0 alpha:1];
    
    
    [self setSubViews];
    [self setNav];
}

- (void) setSubViews{

    self.detailBtn.layer.cornerRadius = 14;
    self.detailBtn.layer.borderColor = kGreenColor.CGColor;
    self.detailBtn.layer.borderWidth = 1;
    self.shareBtn.layer.cornerRadius = 6;
    self.shareBtn.layer.masksToBounds = YES;
    
}
- (void) setNav{
    
    self.title = @"订单完成";
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_gray"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    
}

- (void) leftBtn:(UIButton *)btn{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
