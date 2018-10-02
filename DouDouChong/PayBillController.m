//
//  PayBillController.m
//  DouDouChong
//
//  Created by PC on 2018/6/3.
//  Copyright © 2018年 PC. All rights reserved.
//


/**
  支付页面
 */

#import "PayBillController.h"
#import <WXApi.h>
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"

#import <AlipaySDK/AlipaySDK.h>
//#import "APOrderInfo.h"
//#import "APRSASigner.h"
#import "PayCompleteController.h"

@interface PayBillController ()<WXApiDelegate>

@property (nonatomic,strong) UITableView * tableView;

@end

@implementation PayBillController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:246/255.0 alpha:1];
    
    [self setNav];
    
}

#pragma mark - 支付账单 （微信，支付宝）
- (IBAction)payAction:(id)sender {
    
    
    PayCompleteController * payCompleteVC = [[PayCompleteController alloc] init];
    
//    [self presentViewController:payCompleteVC animated:YES completion:^{
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    }];
    [self.navigationController pushViewController:payCompleteVC animated:YES];
    
    ///> 微信支付
    /*
    NSString *res = [WXApiRequestHandler jumpToBizPay];
    if( ![@"" isEqual:res] ){

        [MBProgressHUD showSuccess:@"支付失败" toView:nil];
    }
     */
    
    ///> 支付宝支付
    /**
     * 调用支付宝支付
     */
    /*
    NSString * appScheme = @"ddcgxqc";
    [[AlipaySDK defaultService] payOrder:nil fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        NSLog(@"reslut = %@",resultDic);
        
       // [self judgeBusinessStatus];
        
    }];
     */
    
//    [self doAPPay];
}


- (void) setNav{
    
    self.title = @"确认支付";
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_gray"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    
}

- (void) leftBtn:(UIButton *)btn{
    
    
//    [self.navigationController popViewControllerAnimated:YES];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


//- (void)doAPPay
//{
//    // 重要说明
//    // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
//    // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
//    // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
//    /*============================================================================*/
//    /*=======================需要填写商户app申请的===================================*/
//    /*============================================================================*/
//    NSString *appID = @"2018070460510307";
//    
//    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
//    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
//    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
//    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
//    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
//    NSString *rsa2PrivateKey = @"MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC/l9KChyuHe44qsMAiUjE2dhjomCPB96eqDs57NZC+1ZKsoWwgx2baxXiu3JZwDgizXORpmdoIBxFD6yV43K1sdLDVouP52wTwbxMIOgwJHPlEjEAjXNNputJARbDqknw5RIpzxgh1/HUVHUSefrFJQye2eEXrjy7WvmaIKAKU9REL59ONCX00TKL/ywO3zUW/VNEwAM4oSruI8Xuklq2F7+ELzPoNivvqj7ESmCrXHXeJMUZQFXpzPiOJtvxWgR1r6DzIZo9H3LYt0OnxcXsY9s1hwY18Z6UAA6D7kDUE1MKe+JlR+z6Wv8ydxdI28DATY1hb/4evJV9Vco/0PvhnAgMBAAECggEAVoTd+DnIK29dPOQCb71EIf7ksqx5gU8v9Lio/7Spv7O8f56JsKe7R9Hi9LwCZ2m+/hhVwWZLslJWtqAKlPC6k/6CGIdtgdgo+9Z89rsX0km2OwFGuXFiux01cvbFtLgfxtCv4SYtjfJKgRVtdlFqB9Z+qYTYtk47bZgfvx6qQ8865+x+n0H19kfkWqvRWHqzk69+DZW9YSdsvUfeSDLCV/mD97KvI3khjdVZSN0voIKl4qzqEpcYMdtKfwj0pMA/9DPHg0gFgvBi3xQjw586qo0DOm3CWpSDZudEX1W4iXUw1hOQIbhpTO90yVUMk6F6v5pV6+AdIeLL9Zz7IAyNMQKBgQDp74l599gGvjbJinV0LrA9RJk99+EbTJbZQ6fsavAu9v2B80K0eLx3zwsVkR8IVpeGZozthdKazySlSmSuzepj4men/9kk+sTeQFZFGHG134sNOBfR5tbmUlvPlSd7DROjdIfdelVRQulv3JfA002EadG1czCsEqQxksJFchlRnwKBgQDRqegmbZ0p0becEoFWuBd86BQB5Y9w61o3vrQkKYa1jKfcI9cWEJrQaRErs4TGCPWB8+GXf79rdAJpXy9BYfeKEe8hzj1TXrtJ93hIqCbo35D7jPL3agNkv4nGFJqsXBA7rJqQWxcskvfMIp/290Qw1rjD0j1WRRiKKoQ0Jci0OQKBgFqnthnq/u9WBTtDCdM1SJzlmZEXH0gJ/SdC/a8zndJFauZSE9aGN1sihAQeke0USXIPCav+QSg2/9eCJdRL/fopQcwr7MVU3LfYLNZn66D0eRltVGXGVB87aVLfVUZtQeAFB6W/g5KTII116eUSvaaDr33mnsUAEFsZqWlqFv+3AoGAf8popit/dILPv8ADt2CDaG1n7HQIBtJcbce9sqDg630svt/VdCxwwACaJ6HGlpHVWfzVDmsduBfAdItAmUBmCXC+6UL0XAFMdFvyo45iEORbUQdq++RQ5zJbfjEGyXFfr4+Xsc7jhBacFH8yMuwpUv89JJXbLt70gxpA9CvndfkCgYBxGEokQQEzB1N9o4tOITUkQqtx7GKDnTtF4mT9kZyBZiTViZJ8qKg/Iy/U54saunxXgaM+0vdmnk/wjeMvujTLrAgoTAFMRgLdog6IAwvrnYt3EfwLohkWaJh/RMxG6yPfhnoRAW8w6XyBMR3rHStDWoiEljBFGyWAhfP5Ohqxvw==";
//    NSString *rsaPrivateKey = @"";
//    /*============================================================================*/
//    /*============================================================================*/
//    /*============================================================================*/
//    
//    //partner和seller获取失败,提示
//    if ([appID length] == 0 ||
//        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
//    {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
//                                                                       message:@"缺少appId或者私钥,请检查参数设置"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了"
//                                                         style:UIAlertActionStyleDefault
//                                                       handler:^(UIAlertAction *action){
//                                                           
//                                                       }];
//        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:^{ }];
//        return;
//    }
//    
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    APOrderInfo* order = [APOrderInfo new];
//    
//    // NOTE: app_id设置
//    order.app_id = appID;
//    
//    // NOTE: 支付接口名称
//    order.method = @"alipay.trade.app.pay";
//    
//    // NOTE: 参数编码格式
//    order.charset = @"utf-8";
//    
//    // NOTE: 当前时间点
//    NSDateFormatter* formatter = [NSDateFormatter new];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    order.timestamp = [formatter stringFromDate:[NSDate date]];
//    
//    // NOTE: 支付版本
//    order.version = @"1.0";
//    
//    // NOTE: sign_type 根据商户设置的私钥来决定
//    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
//    
//    // NOTE: 商品数据
//    order.biz_content = [APBizContent new];
//    order.biz_content.body = @"我是测试数据";
//    order.biz_content.subject = @"1";
//    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
//    order.biz_content.timeout_express = @"30m"; //超时时间设置
//    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
//    
//    //将商品信息拼接成字符串
//    NSString *orderInfo = [order orderInfoEncoded:NO];
//    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
//    NSLog(@"orderSpec = %@",orderInfo);
//    
//    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
//    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
//    NSString *signedString = nil;
//    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
//    if ((rsa2PrivateKey.length > 1)) {
//        signedString = [signer signString:orderInfo withRSA2:YES];
//    } else {
//        signedString = [signer signString:orderInfo withRSA2:NO];
//    }
//    
//    // NOTE: 如果加签成功，则继续执行支付
//    if (signedString != nil) {
//        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
//        NSString *appScheme = @"alisdkdemo";
//        
//        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
//        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
//                                 orderInfoEncoded, signedString];
//        
//        // NOTE: 调用支付结果开始支付
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//        }];
//    }
//}
//
//#pragma mark   ==============产生随机订单号==============
//
//- (NSString *)generateTradeNO
//{
//    static int kNumber = 15;
//    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *resultStr = [[NSMutableString alloc] init];
//    srand((unsigned)time(0));
//    for (int i = 0; i < kNumber; i++)
//    {
//        unsigned index = rand() % [sourceStr length];
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    return resultStr;
//}

@end
