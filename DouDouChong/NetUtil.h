//
//  NetUtil.h
//  shanmeng
//
//  Created by fcrj on 2017/6/26.
//  Copyright © 2017年 fancheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/** 网络请求成功 */
typedef void(^lcSuccess)(NSDictionary *  dataDic);

/** 网络请求失败 */
typedef void(^lcFailure)(NSError * error);

@interface NetUtil : NSObject


/** GET 网络请求 */
+ (void) GET:(NSString *)urlStr requestSuccess:(lcSuccess)getSuccess requestFailure:(lcFailure)getFailure;


/** POST 网络请求 */
+ (void) POST:(NSString *)urlStr parameters:(id)parameters success:(lcSuccess)postSuccess failure:(lcFailure)postFailure;

/** DELETE 网络请求 */
+ (void) DELETE:(NSString *)urlStr paramters:(id)parameters success:(lcSuccess)deleteSuccess failure:(lcFailure)deleteFailure;
@end
