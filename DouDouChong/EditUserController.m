//
//  EditUserController.m
//  DouDouChong
//
//  Created by PC on 2018/6/22.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "EditUserController.h"


@interface EditUserController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@end

static NSString * infoCell = @"userinfocell";

@implementation EditUserController{

    NSArray * _titleArr;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:246/255.0 alpha:1];
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:246/255.0 alpha:1];
    self.tableView.scrollEnabled = NO;
    _titleArr = @[@[@"昵称",@"邮箱",@"手机"],@[@"行业",@"职业"],@[@"微信",@"QQ"]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 3;
            break;
        case 1:
            rows = 2;
            break;
        case 2:
            rows = 2;
            break;
            
        default:
            break;
    }
    
    return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

  
        return 10;
        
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:infoCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:infoCell];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSArray * sArr = _titleArr[indexPath.section];
    cell.textLabel.text = sArr[indexPath.row];
    cell.detailTextLabel.text = @"11";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
    
}


- (void) setNav{
    
    self.title = @"编辑资料";
    
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
