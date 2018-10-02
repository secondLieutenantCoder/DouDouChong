//
//  AppDelegate.m
//  DouDouChong
//
//  Created by PC on 2018/2/26.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "AppDelegate.h"
#import "REFrostedViewController.h"
//#import "DEMOMenuViewController.h"
#import "DEMONavigationController.h"
#import "DEMOSecondViewController.h"
#import "DemoMenuController.h"
#import "HomeController.h"
// 地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
// 2
#import "MainController.h"
#import "WSUtil.h"
#import <WXApi.h>     // 微信支付
#import <AlipaySDK/AlipaySDK.h>  // 阿里支付

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /**
     微信 key ： wxdb8f7870392258c3
     secret  ： longchuangkeji05363210004LCKJYXJ
     */
    
    // Override point for customization after application launch.
    
    /*
    HomeController * homeVC = [[HomeController alloc] init];
    homeVC.view.backgroundColor = [UIColor redColor];
    
    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:homeVC];
  //  DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    DemoMenuController * menuController = [[DemoMenuController alloc] init];
    
    REFrostedViewController * refVC = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    
    refVC.direction = REFrostedViewControllerDirectionLeft;
    
    self.window.rootViewController = refVC;
    */
    // 请求用户数据
    [self getUserInfo];
     [self initGaoDe];
    MainController * mainVC = [[MainController alloc] init];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    self.window.rootViewController = nav;
   
    [WXApi registerApp:@"wxdb8f7870392258c3"];
    
    return YES;
}

#pragma mark - 查询获取用户信息
- (void) getUserInfo{

    NSUserDefaults * uDefaults = [NSUserDefaults standardUserDefaults];
    NSString * tel = [uDefaults objectForKey:@"userTel"];
   // NSString * tel = @"18363855638";
    if (tel.length > 6) {
        // 已登录用户，自动请求用户数据，实现自动登录
        
        NSDictionary * param = @{@"tel":tel};
        
        [WSUtil wsRequestWithName:@"get_user" andParam:param success:^(NSArray *dataArr) {
            // 用户信息
            NSLog(@"用户信息= %@",dataArr);
            // 用户信息给到user
            User * cU = [User getUser];
            [cU setUserDataWithInfoData:dataArr[0]];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }else{
     // 新用户，尚未登录过，需到登录界面，验证手机登录
    }
    
    
}


- (void) initGaoDe{
    
    ///========================== 高德地图 ==========================\\\
    [AMapServices sharedServices].enableHTTPS = YES;
    // 显示地图
    [AMapServices sharedServices].apiKey =kMapKey;
}
-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url{

    BOOL result = [WXApi handleOpenURL:url delegate:self];
    
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            result = YES;
        }
    }
    
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation{

    BOOL result = [WXApi handleOpenURL:url delegate:self];
    
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            result = YES;
        }
    }
    
    return result;
//    return [WXApi handleOpenURL:url delegate:self];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
