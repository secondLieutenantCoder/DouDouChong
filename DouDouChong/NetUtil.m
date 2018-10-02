//
//  NetUtil.m
//  shanmeng
//
//  Created by fcrj on 2017/6/26.
//  Copyright © 2017年 fancheng. All rights reserved.
//

#import "NetUtil.h"

@implementation NetUtil


/** GET 网络请求 */
#pragma mark - get请求
+ (void) GET:(NSString *)urlStr requestSuccess:(lcSuccess)getSuccess requestFailure:(lcFailure)getFailure{

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *StrToken = [NSString stringWithFormat:@"Bearer %@",[defaults objectForKey:@"access_token"]];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:StrToken forHTTPHeaderField:@"Authorization"];
    
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // 网络请求成功
        NSDictionary * getDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    
        getSuccess (getDic);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 网络请求失败
        getFailure (error);
    }];
}


/** POST 网络请求 */
#pragma mark - post 请求
+ (void) POST:(NSString *)urlStr parameters:(id)parameters success:(lcSuccess)postSuccess failure:(lcFailure)postFailure{

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];

    NSString *StrToken = [NSString stringWithFormat:@"Bearer %@",[defaults objectForKey:@"access_token"]];
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:StrToken forHTTPHeaderField:@"Authorization"];
    
    
    [manager POST:urlStr parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *postDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        postSuccess(postDic);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        postFailure (error);
    }];
}
/** DELETE 网络请求 */
#pragma mark - DELETE 请求
+ (void) DELETE:(NSString *)urlStr paramters:(id)parameters success:(lcSuccess)deleteSuccess failure:(lcFailure)deleteFailure{

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSString *StrToken = [NSString stringWithFormat:@"Bearer %@",[defaults objectForKey:@"access_token"]];
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:StrToken forHTTPHeaderField:@"Authorization"];
    
    [manager DELETE:urlStr parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *postDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        deleteSuccess(postDic);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        deleteFailure(error);
    }];
}
@end
