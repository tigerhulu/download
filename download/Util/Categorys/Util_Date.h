//
//  Util.h
//  CostRecord
//
//  Created by hj on 13-8-1.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
	日期处理类
 */
@interface Util_Date : NSObject
 {

}
+(NSString*)stringWithDate:(NSDate*)pDate;
+(NSString*)stringWithDate:(NSDate*)pDate withFormat:(NSString*)pFormat;
+(NSDate*)dateWithString:(NSString*)pDateString;

//获取指定日期的年
+(int)getYearWithDate:(NSDate*)pDate;
//获取指定日期的月
+(int)getMonthWithDate:(NSDate*)pDate;
//获取指定日期的日
+(int)getDayWithDate:(NSDate*)pDate;
//获取指定日期的时
+(int)getHourWithDate:(NSDate*)pDate;
//获取指定日期的分
+(int)getMinuteWithDate:(NSDate*)pDate;
//获取指定日期的秒
+(int)getSecondWithDate:(NSDate*)pDate;

//获取指定年月的起始日期
+(NSDate*)getStartDateWithYear:(int)pYear andMonth:(int)pMonth;
//获取指定年月的结束日期
+(NSDate*)getEndDateWithYear:(int)pYear andMonth:(int)pMonth;

//获取指定日期与当前时间的时间间隔描述
+(NSString*)getIntervalWithDate:(NSDate*)pDate;

@end
