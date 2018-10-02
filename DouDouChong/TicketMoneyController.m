//
//  TicketMoneyController.m
//  DouDouChong
//
//  Created by PC on 2018/6/4.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "TicketMoneyController.h"
#import "MoneyTicketCell.h"

static NSString * ticketCell = @"ticketMoneyCell";

@interface TicketMoneyController ()<UITableViewDataSource,UITableViewDelegate>


/**
 全部金额
 */
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;

/**
 全部日期
 */
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

/**
 移动的view
 */
@property (nonatomic,strong) UIView * mView;

@property (nonatomic,strong) UITableView * tableView;

@end

@implementation TicketMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    self.mView = [[UIView alloc] initWithFrame:CGRectMake(self.moneyBtn.frame.origin.x, CGRectGetMaxY(self.moneyBtn.frame), self.moneyBtn.frame.size.width+20, 2)];
    self.mView.backgroundColor = kGreenColor;
    [self.view addSubview:self.mView];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:246/255.0 alpha:1];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.moneyBtn.frame)+10, kWidth, kHeight-CGRectGetMaxY(self.moneyBtn.frame)-60)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight  = 130;
    [self.tableView registerNib:[UINib nibWithNibName:@"MoneyTicketCell" bundle:nil] forCellReuseIdentifier:ticketCell];
    [self.view addSubview:self.tableView];
    
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MoneyTicketCell * cell = [tableView dequeueReusableCellWithIdentifier:ticketCell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"体验券");

}

#pragma mark - 全部金额
- (IBAction)totalMoneyAction:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mView.frame = CGRectMake((kWidth/2.0-75)/2.0-10, CGRectGetMaxY(self.moneyBtn.frame), self.moneyBtn.frame.size.width+20, 2);
    }];
    
    [self.dateBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.moneyBtn setTitleColor:kGreenColor forState:UIControlStateNormal];
}

#pragma mark - 全部日期
- (IBAction)totalDateAction:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mView.frame = CGRectMake((kWidth/2.0-75)/2.0-10+kWidth/2.0, CGRectGetMaxY(self.moneyBtn.frame), self.moneyBtn.frame.size.width+20, 2);
    }];
    [self.moneyBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.dateBtn setTitleColor:kGreenColor forState:UIControlStateNormal];
    
}

- (void) setNav{
    
    self.title = @"代金券";
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_gray"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
//    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
//
//    [rightBtn setTitle:@"确认还车" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:kGreenColor forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
}

- (void) leftBtn:(UIButton *)btn{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
