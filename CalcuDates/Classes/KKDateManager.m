//
//  KKDateManager.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/25/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKDateManager.h"

@implementation KKDateManager

/**
 * @abstract Calculates the duration between a start date and and end date
 * @param startDateString - the start date
 * @param endDateString - the end date
 * @return Returns an NSDictionary or days, weeks, months and years' difference between the two provided dates
 */
+ (NSDictionary*) doDateCalculationsForStartDate:(NSString*)startDateString andEndDate:(NSString*)endDateString {
    NSParameterAssert(startDateString.length > 0);
    NSParameterAssert(endDateString.length > 0);
    
    NSDate *startDate = [self convertStringToDate:startDateString];
    NSDate *endDate = [self convertStringToDate:endDateString];
    
    NSString *days = [self daysWithinEraFromDate:startDate toDate:endDate];
    
    
    return @{@"days"    : days,
             @"weeks"   : [self toWeeks:days],
             @"months"  : [self toMonths:days],
             @"years"   : [self toYears:days]};
}

+ (NSDate*)convertStringToDate:(NSString*)stringDate {
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    return [dateFormat dateFromString:stringDate];
}

+ (NSString*) daysWithinEraFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    float start = (float)[gregorian ordinalityOfUnit:NSCalendarUnitDay inUnit: NSEraCalendarUnit forDate:startDate];
    float end = (float)[gregorian ordinalityOfUnit:NSCalendarUnitDay inUnit: NSEraCalendarUnit forDate:endDate];
    return [NSString stringWithFormat:@"%.0f", (end-start)];
}

+ (NSString*)toWeeks:(NSString*)days {
    float fdays = [days floatValue];
    return [NSString stringWithFormat:@"%.1f", (fdays / (float)DAYS_IN_A_WEEK)];
}

+ (NSString*)toMonths:(NSString*)days {
    float fdays = [days floatValue];
    return [NSString stringWithFormat:@"%.2f", (fdays / (float)DAYS_IN_A_MONTH)];
}

+ (NSString*)toYears:(NSString*)days {
    float fdays = [days floatValue];
    return [NSString stringWithFormat:@"%.2f", (fdays / (float)DAYS_IN_A_YEAR)];
}

/**
 * @abstract Calculates an end date given a starting date and combination or days, weeks, months, years to add/subtract
 * @param startDate - the start date to calculate from
 * @param durations - a dictionary of days, weeks, months years to add to the start date; can be any combination of at least one object
 * @return Returns the calculated end date as a string
 */
+ (NSString*) doEndDateCalculationForStartDate:(NSString*)startDate andTotalDurations:(NSDictionary*)durations {
    NSAssert([durations count] > 0, @"Durations parameter must not be empty for calculation");
    NSAssert(startDate.length > 0, @"Start date parameter must not be empty for calculation");
    
    return [self calculateEndDateForStartDate:startDate andDurations:durations];
}

+ (NSString*) calculateEndDateForStartDate:(NSString*)startDate andDurations:(NSDictionary*)durations {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [offsetComponents setDay:[[NSString stringWithFormat:@"%@", durations[@"days"]] intValue]];
    [offsetComponents setWeek:[[NSString stringWithFormat:@"%@", durations[@"weeks"]] intValue]];
    [offsetComponents setMonth:[[NSString stringWithFormat:@"%@", durations[@"months"]] intValue]];
    [offsetComponents setYear:[[NSString stringWithFormat:@"%@", durations[@"years"]] intValue]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    NSDate *date = [dateFormat dateFromString:startDate];
    
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];

    return [dateFormat stringFromDate:nextDate];
}

@end
