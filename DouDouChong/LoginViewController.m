//
//  LoginViewController.m
//  DouDouChong
//
//  Created by PC on 2018/5/23.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "LoginViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "Utility.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "UUIDUtil.h"
#import "WSUtil.h"
//#import "User.h"
#import "XieYiControllerViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *yzmTF;
@property (weak, nonatomic) IBOutlet UIButton *yzmBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.agreeBtn.selected = YES;
    self.topConstant.constant = kHeight * 0.35;
    
    self.loginBtn.layer.cornerRadius  = 18;
    self.loginBtn.layer.masksToBounds = YES;
    
    [self.view sendSubviewToBack:self.bgImgView];
}

#pragma mark - 开始使用-登录注册
- (IBAction)loginAction:(id)sender {
    
    NSString * phone = self.phoneTF.text;
    NSString * yzm   = self.yzmTF.text;
    
    if (![Utility isMobileNumber:phone]) {
        [MBProgressHUD showError:@"手机号码错误！" toView:nil];
    }else if (yzm.length != 4){
        [MBProgressHUD showError:@"请检查验证码!" toView:nil];
    }else if (!self.agreeBtn.selected){
    
        [MBProgressHUD showError:@"开始用车需遵守租车协议" toView:nil];
    }else{
    
        // 提交验证
        [SMSSDK commitVerificationCode:yzm phoneNumber:phone zone:@"86" result:^(NSError *error) {
            
            if (!error)
            {
                // 验证成功
                // 登录
                NSString * uuid = [UUIDUtil getUUIDString];
                
                NSDictionary * userParam = @{@"tel":phone,@"unique_id":uuid};
                [WSUtil wsBoolRequestWithName:@"insert_user" andParam:userParam success:^(BOOL isSuccess) {
                    
                    if (isSuccess) {
                        // 注册成功
                        [MBProgressHUD showSuccess:@"登录成功！" toView:nil];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                            
                            /// 改变用户状态
                            /// 不能置 1 ，如果是老用户重新登录呢
                            User * user = [User getUser];
                            user.login_status = @"1";
                            // 提交用户状态
                            /**
                              将电话号码本地存储
                             */
                            NSUserDefaults * uDefault = [NSUserDefaults standardUserDefaults];
                            [uDefault  setObject:phone forKey:@"userTel"];
                        });
                        
                        
                    }else{
                        // 注册失败
                        [MBProgressHUD showError:@"注册失败" toView:nil];
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    
                    [MBProgressHUD showError:@"网络请求失败！" toView:nil];
                }];
            }
            else
            {
                // error
                [MBProgressHUD showError:@"验证失败!" toView:nil];
            }
        }];
        
        
        
    }
    
}

#pragma mark - 获取验证码
- (IBAction)getYZMAction:(UIButton *)sender {
    
    //不带自定义模版
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:@"13800138000" zone:@"86"  result:^(NSError *error) {
//        
//        if (!error)
//        {
//            // 请求成功
//        }
//        else
//        {
//            // error
//        }
//    }];
    
    NSString * phone = self.phoneTF.text;
    if ([Utility isMobileNumber:phone]) {
        //带自定义模版
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:@"86" template:nil result:^(NSError *error) {
            
            if (!error)
            {
                // 请求成功
                NSLog(@"success");
                [MBProgressHUD showError:@"验证码已发送" toView:nil];
                // 禁用按钮并倒计时
                sender.userInteractionEnabled = NO;
                __block NSInteger  time = 60;
                [sender setTitle:@"60s" forState:UIControlStateNormal];
                [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    if (time == 0) {
                        [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                        sender.userInteractionEnabled = YES;
                        [timer invalidate];
                        timer = nil;
                    }else{
                        [sender setTitle:[NSString stringWithFormat:@"%lds",(long)--time] forState:UIControlStateNormal];
                    }
                    
                    
                }];
            }
            else
            {
                // error
                NSLog(@"error=%@",error);
            }
        }];
    }else{

        [MBProgressHUD showError:@"手机号码错误！" toView:nil];
//        User * user = [User initUser];
//        user.tel = @"13800000000";
//        NSString * uuid = [UUIDUtil getUUIDString];
//        
//        NSDictionary * userParam = @{@"tel":phone,@"unique_id":uuid};
//        [WSUtil wsBoolRequestWithName:@"insert_user" andParam:userParam success:^(BOOL isSuccess) {
//            
//            if (isSuccess) {
//                // 注册成功
//                [MBProgressHUD showSuccess:@"注册成功！" toView:nil];
//                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                });
//                
//                
//            }else{
//                // 注册失败
//                [MBProgressHUD showError:@"注册失败" toView:nil];
//            }
//            
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            
//            [MBProgressHUD showError:@"网络请求失败！" toView:nil];
//        }];
    }
    
}

#pragma mark - 返回
- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)protocoolAction:(id)sender {
    
    XieYiControllerViewController * xyVC = [[XieYiControllerViewController alloc] init];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:xyVC];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 勾选租车协议
- (IBAction)agreeAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}

@end
