//
//  WSUtil.h
//  DouDouChong
//
//  Created by PC on 2018/2/26.
//  Copyright © 2018年 PC. All rights reserved.
//

#import <Foundation/Foundation.h>

// =============-    数组 - ================
/** 网络请求成功 */
typedef void(^wwSuccess)(NSArray *  dataArr);

/** 网络请求失败 */
typedef void(^wwFailure)(NSURLSessionDataTask * task,NSError * error);

// ===============- BOOL -======================
/** 网络请求成功 */
typedef void(^boolSuccess)(BOOL isSuccess);

/** 网络请求失败 */
typedef void(^boolFailure)(NSURLSessionDataTask * task,NSError * error);

@interface WSUtil : NSObject<NSXMLParserDelegate>


/**
 webService网络请求

 @param mName ws方法名
 @param param 请求参数
 */
+ (void) wsRequestWithName:(NSString *) mName  andParam:(NSDictionary *)param success:(wwSuccess)success failure:(wwFailure)faulure;


+ (void) wsBoolRequestWithName:(NSString *) mName  andParam:(NSDictionary *)param success:(boolSuccess)success failure:(boolFailure)faulure;


+ (void )afnSoap;

@end
