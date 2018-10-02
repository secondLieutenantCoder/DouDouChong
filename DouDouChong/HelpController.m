//
//  HelpController.m
//  DouDouChong
//
//  Created by PC on 2018/6/23.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "HelpController.h"

@interface HelpController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@end

@implementation HelpController{

    NSArray * _titleArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:246/255.0 alpha:1];
    
    _titleArr= @[@"新手上路",@"计费规则",@"充电须知",@"保障服务",@"常见问题"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, kWidth, 220)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 44;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * helpCell = @"buttomHelpCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:helpCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:helpCell];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _titleArr[indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {// 新手上路
        
        }
            break;
        case 1:
        { // 计费规则
        
        }
            break;
        case 2:
        { // 充电须知
        
        }
            break;
        case 3:
        {  // 保障服务
        
        }
            break;
        case 4:
        { // 常见问题
        
            
        }
            break;
            
        default:
            break;
    }
    
}



- (void) setNav{
    
    self.title = @"帮助中心";
    
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
