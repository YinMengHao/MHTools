//
//  MHDataChange.m
//  SuiXingYouShops
//
//  Created by HelloWorld on 2019/5/14.
//  Copyright © 2019 SuiXingYou. All rights reserved.
//

#import "MHDateChange.h"

@implementation MHDateChange

+ (NSInteger)getMinuteWithTimeStr:(NSString *)timeStr
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitMinute startDate:&fromDate interval:NULL forDate:[dateFormatter dateFromString:timeStr]];
    [gregorian rangeOfUnit:NSCalendarUnitMinute startDate:&toDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *components = [gregorian components:NSCalendarUnitMinute fromDate:fromDate toDate:toDate options:0];
    
    return components.minute;
}

@end
