//
//  Utility.h
//  ErpApp2.0
//
//  Created by Eric on 14-3-17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "AllClass.h"
@interface Utility : NSObject
//判断字符串是否为空
+(BOOL) isBlankString:(NSString *)string;

+(NSString*)getString:(NSString *)string;
//隐藏uitableview多余的cell
+(void)setExtraCellLineHidden:(UITableView *)tableView;


//处理空字符串
+(NSString *)doEmptyString:(NSString*)str;
//日期格式化
+(NSString*)DateFromater:(NSDate*)current strDateFromater:(NSString *)str;
+ (NSString *)getMonthBeginAndEndWith:(NSDate *)newDate type:(NSInteger)type;

+(NSString *)getCurrentTimestamp;


+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (NSMutableAttributedString*) changeLabelWithText:(NSString*)str1 :(NSString*)str2;

+ (NSInteger) getcurrentMonth;
@end
