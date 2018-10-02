//
//  NoPayController.m
//  DouDouChong
//
//  Created by PC on 2018/7/11.
//  Copyright © 2018年 PC. All rights reserved.
/// > 不计免赔

#import "NoPayController.h"

@interface NoPayController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation NoPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNav];
    self.textView.text = @"    用户预订车辆时，可以选择不计免赔服务费，发生事故后可免除保险上浮费和超出2000元部分的20%折旧费（重大事故除外）;\n    收费标准:分时租车1元/次，日租3元/24小时，不计免赔费用只能用余额支付";
    
}

- (void) setNav{
    
    self.title = @"不计免赔";
    
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
