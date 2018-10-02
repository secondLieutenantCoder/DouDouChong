//
//  SettingViewController.m
//  DouDouChong
//
//  Created by PC on 2018/5/30.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "SettingViewController.h"
#import "XieYiControllerViewController.h"
#import <WebKit/WebKit.h>
#import "AdviceController.h"
#import "AboutUsController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@end

@implementation SettingViewController{

    NSArray * _titleArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    
    _titleArr = @[@[@"常用地址",@"关于我们",@"意见反馈"],@[@"用户协议",@"清理缓存"]];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:246/255.0 alpha:1];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44*5+30)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   // self.tableView.separatorColor = [UIColor grayColor];
    self.tableView.rowHeight = 45;
   // self.tableView.userInteractionEnabled = NO;
    self.tableView.scrollEnabled = YES;
  //  self.tableView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.tableView];
   // self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /// 退出登录
    UIButton * quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame)+30, kWidth, 44)];
    
    quitBtn.backgroundColor = [UIColor  whiteColor];
    [quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitBtn setTitleColor:kGreenColor forState:UIControlStateNormal];
    [quitBtn addTarget:self action:@selector(quitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitBtn];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSInteger s = 0;
    if (section == 0) {
        s= 3;
    }else{
        s = 2;
    }
    return s;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * setIdertifier = @"SettingCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:setIdertifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:setIdertifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 设置 title
    NSArray * tmpArr = _titleArr[indexPath.section];
    cell.textLabel.text = tmpArr[indexPath.row];
    return cell;
    
}

#pragma mark - cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            { // 常用地址
            
            }
                break;
            case 1:{ // 关于我们
                AboutUsController * usVC = [[AboutUsController alloc] init];
                
                [self.navigationController pushViewController:usVC animated:YES];
            }
                
                break;
            case 2:
            { // 意见反馈
                AdviceController * adviceVC = [[AdviceController alloc] init];
                
                [self.navigationController pushViewController:adviceVC animated:YES];
            }
                break;
            default:
                break;
        }
    }else{
    
        if (indexPath.row == 0) {
            // >用户协议
            
            XieYiControllerViewController * xyVC = [[XieYiControllerViewController alloc] init];
            [self.navigationController pushViewController:xyVC animated:YES];
            
        }else{
        // 清理缓存
            [MBProgressHUD showError:@"清理缓存" toView:nil];
        }
    }
    
}

#pragma mark - 退出登录
- (void) quitAction{
    
    NSLog(@"退出登录");
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    CGFloat h = 0;
    if (section == 0) {
        h = 10;
    }else{
        h = 20;
    }
    return h;
}

- (void) setNav{

    self.title = @"设置";

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
