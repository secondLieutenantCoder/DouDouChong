//
//  ReserveInfoController.m
//  DouDouChong
//
//  Created by PC on 2018/6/1.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "ReserveInfoController.h"
#import "UsingCarController.h"
#import "WSUtil.h"

@interface ReserveInfoController ()


/**
 寻车按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *findCar;

/**
 确认用车按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *userCar;


/**
 租车状态 - 待取车
 */
@property (weak, nonatomic) IBOutlet UILabel *stateLab;

/**
 归属
 */
@property (weak, nonatomic) IBOutlet UILabel *guishu;

/**
 归属地
 */
@property (weak, nonatomic) IBOutlet UILabel *guishudi;

/**
 倒计时lab
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *reserveTime;
@property (weak, nonatomic) IBOutlet UILabel *carNum;

@property (weak, nonatomic) IBOutlet UILabel *electLab;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end

@implementation ReserveInfoController{

    /** 倒计时10分钟 */
    NSInteger _seconds;
    
    NSTimer * _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:246/255.0 alpha:1];
    
    self.findCar.layer.cornerRadius = 8;
    self.userCar.layer.cornerRadius = 8;
    self.stateLab.layer.cornerRadius = 10;
    self.stateLab.layer.masksToBounds = YES;
    
    self.guishu.layer.cornerRadius = 5;
    self.guishu.layer.borderWidth  = 0.6;
    self.guishu.layer.borderColor  = [UIColor grayColor].CGColor;
    
    self.guishudi.layer.cornerRadius = 5;
    self.guishudi.layer.masksToBounds = YES;
    _seconds = 600;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.carNum.text = self.carInfo[@"num"];
    self.guishudi.text = self.carInfo[@"city"];
    self.electLab.text = [NSString stringWithFormat:@"%ld%% 剩余电量",[self.carInfo[@"continue_ele"] integerValue]];
    self.distance.text = [NSString stringWithFormat:@"约%ldkm续航里程",[self.carInfo[@"continue_dis"] integerValue]];
    
}

#pragma mark - 定时器方法
- (void) timeAction:(NSTimer *)timer{

    _seconds--;
    if (_seconds <= 0) {
        
        // 倒计时结束
        [timer invalidate];
        timer = nil;
        [MBProgressHUD showError:@"预留时间结束" toView:nil];
        
    }else{
        
        // 仍在倒计时
        NSInteger m = _seconds/60;
        NSInteger s = _seconds%60;
        
        self.timeLab.text = [NSString stringWithFormat:@"预留时间剩余%ld分钟%ld秒",m,s];
    }
    

}

#pragma mark - 寻车
- (IBAction)xuncheAction:(id)sender {
    
    NSLog(@"寻车");
}

#pragma mark - 确认用车
- (IBAction)confirmUsingCarAction:(id)sender {
    
    
    NSString * tel = [User getUser].tel;
    NSString * carNum = @"";
    // type  1 分时   2 日租
    NSString * type = @"1";
    NSDictionary * param = @{@"tel":tel,@"car_num":carNum,@"type":type};
    [WSUtil wsBoolRequestWithName:@"insert_carorder" andParam:param success:^(BOOL isSuccess) {
        
        if (isSuccess) {
            [MBProgressHUD showSuccess:@"插入一条订单成功!" toView:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    UsingCarController * usingVC = [[UsingCarController alloc] init];
    [self.navigationController pushViewController:usingVC animated:YES];
    
}

- (void) setNav{
    
    self.title = @"租车详情";
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_gray"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    // [rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kGreenColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
}

#pragma mark - 取消订单
- (void) rightAction{
    
    NSLog(@"报销停车费");
}

#pragma mark - 返回
- (void) leftBtn:(UIButton *)btn{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}




@end
