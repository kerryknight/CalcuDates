//
//  AppCalendar.h
//  CalcuDates
//
//  Created by Kerry on 9/24/12.
//  Copyright (c) 2012 Kerry Knight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

#define kAppCalendarTitle @"CalcuDates"

@interface AppCalendar : NSObject

+(EKEventStore*)eventStore;
+(EKCalendar*)calendar;
+(EKCalendar*)createAppCalendar;

@end
