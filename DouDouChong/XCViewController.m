//
//  XCViewController.m
//  DouDouChong
//
//  Created by PC on 2018/5/30.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "XCViewController.h"
#import "XCTableViewCell.h"
#import "XCDetailViewController.h"


static NSString * xcCell = @"xcCell";
@interface XCViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *line;
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation XCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.line.frame)+5, kWidth, kHeight-CGRectGetMaxY(self.line.frame)-5-64)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 110;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XCTableViewCell" bundle:nil] forCellReuseIdentifier:xcCell];
    
    [self.view addSubview:self.tableView];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    XCTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:xcCell];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    XCDetailViewController * xcDetailVC = [[XCDetailViewController alloc] init];
    
    [self.navigationController pushViewController:xcDetailVC animated:YES];
    
    
}



- (void) setNav{
    
    self.title = @"我的行程";
    
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
