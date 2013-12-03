//
//  KKDateManager.h
//  CalcuDates
//
//  Created by Kerry Knight on 11/25/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKDateManager : NSObject

+ (NSDictionary*) doDateCalculationsForStartDate:(NSString*)startDate andEndDate:(NSString*)endDate;
+ (NSString*) doEndDateCalculationForStartDate:(NSString*)startDate andTotalDurations:(NSDictionary*)durations;

@end
