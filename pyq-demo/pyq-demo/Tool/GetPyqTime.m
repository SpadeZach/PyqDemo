//
//  GetPyqTime.m
//  pyq-demo
//
//  Created by 赵博 on 2017/9/6.
//  Copyright © 2017年 赵博. All rights reserved.
//

#import "GetPyqTime.h"

@implementation GetPyqTime
#pragma mark - 计算时间
+(NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    
    //结束时间
    NSDate *startDate =[formatter dateFromString:startTime];
    NSString *nowstr = [formatter stringFromDate:now];
    //当前
    NSDate *nowDate = [formatter dateFromString:nowstr];
    
    NSTimeInterval start = [startDate timeIntervalSince1970]*1;
    //当前时间
    NSTimeInterval end = [nowDate timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    
    int minute = (int)value /60%60;
    int hours = (int)value / 3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    
    if (day != 0) {
        str = [NSString stringWithFormat:@"%d天前",day];
    }else if (day==0 && hours != 0) {
        str = [NSString stringWithFormat:@"%d小时前",hours];
    }else if (day== 0 && hours== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"%d分前",minute];
    }else{
        str = @"刚刚";
    }
    return str;
}
@end
