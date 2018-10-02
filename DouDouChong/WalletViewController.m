//
//  WalletViewController.m
//  DouDouChong
//
//  Created by PC on 2018/5/31.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "WalletViewController.h"
#import "ChongZhiController.h"
#import "DepositController.h"
#import "TicketMoneyController.h"
#import "UpDespositController.h"
//#import "MBProgressHUD.h"

@interface WalletViewController ()<UITableViewDelegate,UITableViewDataSource>


/**
 交易明细
 */
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (nonatomic,strong) UITableView * tableView;

@end

@implementation WalletViewController{

    NSArray * _titleArr;
    NSArray * _imgArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
   
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:246/255.0 alpha:1];
    
    self.detailBtn.layer.borderWidth = 1;
    self.detailBtn.layer.borderColor = [UIColor colorWithRed:31/255.0 green:167/255.0 blue:53/255.0 alpha:1].CGColor;
    self.detailBtn.layer.cornerRadius = 12.5;
    
    _titleArr = @[@"充毛毛币",@"代金券",@"违章保证金",@"待缴费用"];
    _imgArr = @[@"qianbao_chongzhi",@"qianbao_daijinquan",@"qianbao_weizhangbaozhengjin",@"qianbao_daijiaofeiyong"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, kWidth, 190)];
    self.tableView.rowHeight = 40;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;;
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:246/255.0 alpha:1];
    [self.view addSubview:self.tableView];
    
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{

    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * walletCell = @"walletCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:walletCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:walletCell];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _titleArr[indexPath.section];
    cell.detailTextLabel.text = @"1";
    cell.imageView.image = [UIImage imageNamed:_imgArr[indexPath.section]];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    CGFloat h = 0;
    switch (section) {
        case 0:
            h= 5;
            break;
        case 1:
            h= 15;
            break;
        case 2:
            h= 5;
            break;
        case 3:
            h=5;
            break;
            
        default:
            break;
    }
    return h;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.section) {
        case 0:
        {
            ChongZhiController * czVC = [[ChongZhiController alloc] init];
            [self.navigationController pushViewController:czVC animated:YES];
        }
            break;
        case 1:
        {
            TicketMoneyController * tmVC = [[TicketMoneyController alloc] init];
            [self.navigationController pushViewController:tmVC animated:YES];
            
            
        }
            break;
        case 2:
        {
            User * cUser =[User getUser];
            if (cUser.login_status.integerValue == 2) {
                UpDespositController * upDes = [[UpDespositController alloc] init];
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:upDes];
                [self presentViewController:nav animated:YES completion:nil];
              //  [self.navigationController pushViewController:upDes animated:YES];
            }else if (cUser.login_status.integerValue == 3){
                DepositController * dVC = [[DepositController alloc] init];
                [self.navigationController pushViewController:dVC animated:YES];
                
            }else{
            
                [MBProgressHUD showError:@"您尚未实名认证" toView:nil];
            }
            
        }
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
}



- (void) setNav{
    
    self.title = @"钱包";
    
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
