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
    
    NSTimeInterval timeDifference = [endDate timeIntervalSinceDate:startDate];
    
    NSString *days = [self convertToDays:timeDifference];
    NSString *weeks = [self convertToWeeks:timeDifference];
    NSString *months = [self convertToMonths:timeDifference];
    NSString *years = [self convertToYears:timeDifference];
    
    return @{@"days" : days,
             @"weeks" : weeks,
             @"months" : months,
             @"years" : years};
}

/**
 * @abstract Calculates an end date given a starting date and combination or days, weeks, months, years to add/subtract
 * @param startDate - the start date to calculate from 
 * @param durations - a dictionary of days, weeks, months years to add to the start date; can be any combination of at least one object
 * @return Returns the calculated end date as a string
 */
+ (NSString*) calculateEndDateBasedOnTotalDurationFromStartDate:(NSString*)startDate forDurations:(NSDictionary*)durations {
    NSParameterAssert([durations count] > 0);
    
    return [NSString stringWithFormat:@""];
}

+ (NSDate*)convertStringToDate:(NSString*)stringDate {
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    return [dateFormat dateFromString:stringDate];
}

+ (NSString*)convertToDays:(NSTimeInterval)timeInterval {
    
    float numerator = [[NSString stringWithFormat:@"%f", timeInterval] floatValue];
    int digits = 0; //this can be set from a variable if we want to allow custom rounding
    double valueToRound = (numerator/SECONDS_IN_A_DAY);
    NSString *floatToString = [NSString stringWithFormat:@"%.*f", digits, valueToRound];
    
    return floatToString;
}

+ (NSString*)convertToWeeks:(NSTimeInterval)timeInterval {
    
    float numerator = [[NSString stringWithFormat:@"%f", timeInterval] floatValue];
    int digits = 1; //this can be set from a variable if we want to allow custom rounding
    float valueToRound = (numerator/SECONDS_IN_A_WEEK);
    NSString *floatToString = [NSString stringWithFormat:@"%.*f", digits, valueToRound];
    
    return floatToString;
}

+ (NSString*)convertToMonths:(NSTimeInterval)timeInterval {
    
    float numerator = [[NSString stringWithFormat:@"%f", timeInterval] floatValue];
    int digits = 2; //this can be set from a variable if we want to allow custom rounding
    float valueToRound = (numerator/SECONDS_IN_A_MONTH);
    NSString *floatToString = [NSString stringWithFormat:@"%.*f", digits, valueToRound];
    
    return floatToString;
}

+ (NSString*)convertToYears:(NSTimeInterval)timeInterval {
    
    float numerator = [[NSString stringWithFormat:@"%f", timeInterval] floatValue];
    int digits = 2; //this can be set from a variable if we want to allow custom rounding
    float valueToRound = (numerator/SECONDS_IN_A_YEAR);
    NSString *floatToString = [NSString stringWithFormat:@"%.*f", digits, valueToRound];
    
    return floatToString;
}


@end
