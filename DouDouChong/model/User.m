//
//  User.m
//  DouDouChong
//
//  Created by PC on 2018/6/8.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "User.h"

/** 用户单例 */

@implementation User


+ (instancetype) getUser{

    static User * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[User alloc] init];
    });
    return instance;
    
}


#pragma mark - 字典转对象
-(void) setUserDataWithInfoData:(NSDictionary *)infoDic{

    [self setValuesForKeysWithDictionary:infoDic];
    
    
    
}

@end
