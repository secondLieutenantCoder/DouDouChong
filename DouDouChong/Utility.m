//
//  Utility.m
//  ErpApp2.0
//
//  Created by Eric on 14-3-17.
//
//

#import "Utility.h"
//#import "AllClass.h"
@implementation Utility
//判断字符串是否为空
+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
//去除空格
+(NSString *)getString:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}


//处理空字符串
+(NSString *)doEmptyString:(NSString*)str
{
    
    if ([self isBlankString:str] || [str isEqualToString:@"<null>"]) {
        return @"暂无";
    }
    return str;
}
+(NSString*)DateFromater:(NSDate*)current strDateFromater:(NSString *)str
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:str];
    //用[NSDate date]可以获取系统当前时间
    return  [dateFormatter stringFromDate:current];
    
}

/**
 *  get the date of day
 *
 *  @param newDate newdate
 *  @param type    0: today 1:month 2:quert 3 year
 *
 *  @return the string format "2014-01-11|2014-01-11"
 */
+ (NSString *)getMonthBeginAndEndWith:(NSDate *)newDate type:(NSInteger)type
{
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok= true;
    switch (type) {
        case 0:
        {
            ok= [calendar rangeOfUnit:NSCalendarUnitDay startDate:&beginDate interval:&interval forDate:newDate];
            break;
        }
        case 1:
        {
            ok= [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
            break;
        }
        case 2:
        {
            ok= [calendar rangeOfUnit:NSCalendarUnitQuarter startDate:&beginDate interval:&interval forDate:newDate];
            break;
        }
        case 3:
        {
            ok= [calendar rangeOfUnit:NSCalendarUnitYear startDate:&beginDate interval:&interval forDate:newDate];
            break;
        }
        default:
            break;
    }
    
    
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }
    else
    {
        return @"";
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    return [NSString stringWithFormat:@"%@|%@",beginString,endString];
}


//获取当前时间的时间戳
+(NSString*)getCurrentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970] * 1000;
    NSString * timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}
+ (NSMutableAttributedString*) changeLabelWithText:(NSString*)str1 :(NSString*)str2
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[str1 stringByAppendingString:str2]];
    UIFont *font = [UIFont systemFontOfSize:25];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,str1.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(str1.length,str2.length)];
    
    return attrString;
}
+(NSInteger) getcurrentMonth{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    
    return comp.month;
}
@end
