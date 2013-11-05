//
//  AppCalendar.m
//  CalcuDates
//
//  Created by Kerry on 9/24/12.
//  Copyright (c) 2012 Kerry Knight. All rights reserved.
//

#import "AppCalendar.h"

static EKEventStore* eStore = NULL;

@implementation AppCalendar

+(EKEventStore*)eventStore
{
    NSLog(@"%s", __FUNCTION__);
    //keep a static instance of eventStore
    if (!eStore) {
        eStore = [[EKEventStore alloc] init];
    }
    return eStore;
}

+(EKCalendar*)createAppCalendar
{
    NSLog(@"%s", __FUNCTION__);
    EKEventStore *store = [self eventStore];
    
    //1 fetch the local event store source
    EKSource* localSource = nil;
    for (EKSource* src in store.sources) {
        if (src.sourceType == EKSourceTypeCalDAV) {
            localSource = src;
        }
        if (src.sourceType == EKSourceTypeLocal && localSource==nil) {
            localSource = src;
        }
    }
    if (!localSource) return nil;
    
    //2 create a new calendar
//    EKCalendar* newCalendar = [EKCalendar calendarWithEventStore: store];
    EKCalendar *newCalendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore: store];
    newCalendar.title = kAppCalendarTitle;
    newCalendar.source = localSource;
    newCalendar.CGColor = [[UIColor colorWithRed:0.8 green:0.251 blue:0.6 alpha:1] /*#cc4099*/ CGColor];
    
    //3 save the calendar in the event store
    NSError* error = nil;
    [store saveCalendar: newCalendar commit:YES error:&error];
    if (!error) {
        return nil;
    }
    
    //4 store the calendar id
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:newCalendar.calendarIdentifier forKey:@"appCalendar"];
    [prefs synchronize];
    
    return newCalendar;
}

+(EKCalendar*)calendar
{
    NSLog(@"%s", __FUNCTION__);
    //1
    EKCalendar* result = nil;
    EKEventStore *store = [self eventStore];
    
    //2 check for a persisted calendar id
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *calendarId = [prefs stringForKey:@"appCalendar"];
	
    //3
    if (calendarId && (result = [store calendarWithIdentifier: calendarId]) ) {
        return result;
    }
    
    //4 check for a calendar with the same name
    for (EKCalendar* cal in [store calendarsForEntityType:EKEntityTypeEvent]) {
        if ([cal.title compare: kAppCalendarTitle]==NSOrderedSame) {
            if (cal.immutable == NO) {
                [prefs setValue:cal.calendarIdentifier forKey:@"appCalendar"];
                [prefs synchronize];
                return cal;
            }
        }
    }
    
//    //4 if no calendar with that name, check for the default calendar
//    for (EKCalendar* cal in store.calendars) {
//        if (cal.immutable == NO && cal == [store defaultCalendarForNewEvents]) {
//            [prefs setValue:cal.calendarIdentifier forKey:@"appCalendar"];
//            [prefs synchronize];
//            return cal;
//        }
//    }
    
    //5 if no calendar is found whatsoever, create one
    result = [self createAppCalendar];
    
    //6
    return result;
}

- (void)AddEventInToDefaultCalendar
{
    NSLog(@"%s", __FUNCTION__);
    // create eventStore object.
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    // create an instance of event with the help of event-store object.
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    
    // set the title of the event.
    event.title = @"This is http://SugarTin.info Event";
    
    // set the start date of event - based on current time, tomorrow's date
    event.startDate = [[NSDate date] dateByAddingTimeInterval:86400]; // 24 hours * 60 mins * 60 seconds = 86400
    
    // set the end date - meeting duration 1 hour
    event.endDate = [[NSDate date] dateByAddingTimeInterval:90000]; // 25 hours * 60 mins * 60 seconds = 86400
    
    // set the calendar of the event. - here default calendar
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    
    // store the event using EventStore.
    NSError *err;
    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
}

//*** Returns a dictionary containing device's calendars by type (only writable calendars)
- (NSDictionary *)listCalendars {
    NSLog(@"%s", __FUNCTION__);
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    NSArray * calendars = [eventDB calendarsForEntityType:EKEntityTypeEvent];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSString * typeString = @"";
    
    for (EKCalendar *thisCalendar in calendars) {
        EKCalendarType type = thisCalendar.type;
        if (type == EKCalendarTypeLocal) {
            typeString = @"local";
        }
        if (type == EKCalendarTypeCalDAV) {
            typeString = @"calDAV";
        }
        if (type == EKCalendarTypeExchange) {
            typeString = @"exchange";
        }
        if (type == EKCalendarTypeSubscription) {
            typeString = @"subscription";
        }
        if (type == EKCalendarTypeBirthday) {
            typeString = @"birthday";
        }
        if (thisCalendar.allowsContentModifications) {
            NSLog(@"The title is:%@", thisCalendar.title);
            [dict setObject: typeString forKey: thisCalendar.title];
        }
    }
    return dict;
}

@end
