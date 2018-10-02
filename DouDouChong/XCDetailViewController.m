//
//  XCDetailViewController.m
//  DouDouChong
//
//  Created by PC on 2018/5/31.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "XCDetailViewController.h"

@interface XCDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *topBackView;



/**
 查看明细
 */
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@end

@implementation XCDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    //[self.view sendSubviewToBack:self.topBackView];
    self.topBackView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:246/255.0 alpha:1];
    
    self.detailBtn.layer.borderWidth = 2;
    self.detailBtn.layer.borderColor = [UIColor greenColor].CGColor;
    self.detailBtn.layer.cornerRadius = 15;
    
}


- (void) setNav{
    
    self.title = @"查看行程";
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_gray"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
   // [rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightBtn setTitle:@"报销停车费" forState:UIControlStateNormal];
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
