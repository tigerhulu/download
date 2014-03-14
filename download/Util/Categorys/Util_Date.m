//
//  Util.m
//  CostRecord
//
//  Created by hj on 13-8-1.
//  Copyright (c) 2013年 PHJ. All rights reserved.
//

#import "Util_Date.h"


@implementation Util_Date

+(NSString*)stringWithDate:(NSDate*)pDate{
	return [Util_Date stringWithDate:pDate  withFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+(NSString*)stringWithDate:(NSDate*)pDate withFormat:(NSString*)pFormat{

	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:pFormat];
	
	NSString *newDateString = [outputFormatter stringFromDate:pDate];
	[outputFormatter release];
	return newDateString;
	
}

+(NSDate*)dateWithString:(NSString*)pDateString{
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSDate *formatterDate = [inputFormatter dateFromString:pDateString];
	[inputFormatter release];
	return formatterDate;
}

+(int)getYearWithDate:(NSDate*)pDate{
	
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents =
	[gregorian components:(NSYearCalendarUnit) fromDate:pDate];
	NSInteger year = [weekdayComponents year];
	[gregorian release];
	return year;
	
}

+(int)getMonthWithDate:(NSDate*)pDate{
	
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents =
	[gregorian components:(NSMonthCalendarUnit) fromDate:pDate];
	NSInteger month = [weekdayComponents month];
	[gregorian release];
	return month;	
}


+(int)getDayWithDate:(NSDate*)pDate{
	
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents =
	[gregorian components:(NSDayCalendarUnit) fromDate:pDate];
	NSInteger day = [weekdayComponents day];
	[gregorian release];
	return day;
}
//获取指定日期的时
+(int)getHourWithDate:(NSDate*)pDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents =
	[gregorian components:(NSHourCalendarUnit) fromDate:pDate];
	NSInteger Hour = [weekdayComponents hour];
	[gregorian release];
	return Hour;
    
}
//获取指定日期的分
+(int)getMinuteWithDate:(NSDate*)pDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents =
	[gregorian components:(NSMinuteCalendarUnit) fromDate:pDate];
	NSInteger minute = [weekdayComponents minute];
	[gregorian release];
	return minute;
    
}
//获取指定日期的秒
+(int)getSecondWithDate:(NSDate*)pDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents =
	[gregorian components:(NSSecondCalendarUnit) fromDate:pDate];
	NSInteger second = [weekdayComponents second];
	[gregorian release];
	return second;
    
}

+(NSDate*)getStartDateWithYear:(int)pYear andMonth:(int)pMonth{
	return [Util_Date dateWithString:[NSString stringWithFormat:@"%d/%02d/01 00:00:00",pYear,pMonth]];
}
+(NSDate*)getEndDateWithYear:(int)pYear andMonth:(int)pMonth{
	int tempYear=pYear;
	int tempMonth=pMonth;
	if (pMonth==12) {
		tempYear++;
		//pMonth=1;
	}
	else {
		//pMonth++;
	}
	NSDate *dt=[Util_Date dateWithString:[NSString stringWithFormat:@"%d/%02d/01 00:00:00",tempYear,tempMonth]];
	return [NSDate dateWithTimeInterval:-1 sinceDate:dt];

}

+(NSString*)getIntervalWithDate:(NSDate*)pDate{
    NSTimeInterval distime = [[NSDate date] timeIntervalSinceDate:pDate];
    NSString *pTime = [Util_Date stringWithDate:pDate];
    NSString *result;
    if (distime<0) {
        result = [NSString stringWithFormat:@"0秒前"];
    }else if (distime < 60) {
        result = [NSString stringWithFormat:@"%d秒前",(int)distime];
    }else if (distime < 3600) {
        result = [NSString stringWithFormat:@"%d分钟前",(int)distime/60];
    }else if (distime/3600 <24) {
        result = [NSString stringWithFormat:@"%d小时前",(int)distime/3600];
    }else if (distime/86400 <30) {
        result = [NSString stringWithFormat:@"%d天前",(int)distime/86400];
    }
    else {
        result = [[pTime substringFromIndex:5] substringToIndex:11];
    }
    return result;
}


@end
