//
//  KKEventKitController.h
//  CalcuDates
//
//  Created by Kerry Knight on 11/27/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKitUI/EventKitUI.h>
#import "EventKitController.h"

@interface KKEventKitController : EventKitController <EKCalendarChooserDelegate>

@property (nonatomic, strong) EKEventEditViewController *editEvent;
@property (nonatomic, assign) BOOL isPerformingOperations;
@property (nonatomic, weak) NSString *dateString;

- (instancetype) initWithDate:(NSString*)date;
- (void)saveEvent:(EKEvent*)event;

@end
