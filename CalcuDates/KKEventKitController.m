//
//  KKEventKitController.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/27/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKEventKitController.h"

@interface KKEventKitController () {
    
}

@end


@implementation KKEventKitController

#pragma mark - Action Methods

- (instancetype) initWithDate:(NSString*)date {
    self = [super init];
    if (!self || !date) {
        return nil;
    }
    
    NSString *tempDate = [NSString stringWithString:date];
    self.dateString = tempDate;
    
    [self addEvent];
    
    return self;
}

- (void)addEvent {
    
    if (self.editEvent == nil) {
        self.editEvent = [[EKEventEditViewController alloc] init];
        self.editEvent.eventStore = [self eventStore];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performEventOperations) name:EventsAccessGranted object:self];
    
    if (!self.isPerformingOperations) [self performEventOperations];
}

#pragma mark - Calendar methods

- (void)saveEvent:(EKEvent*)event {
    NSError* error = nil;
    [[self eventStore] saveEvent:event span:EKSpanFutureEvents commit:YES error:&error];
    
    if (error != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"There was an error creating a new event entry. Please try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        
        [alert show];
        return;
    } else {
        
        [self performSelector:@selector(successAlert) withObject:nil afterDelay:0.4f];
        
    }
}

- (void)successAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"New calendar event successfully created." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    [alert show];
}

- (void) performEventOperations {
    self.isPerformingOperations = YES;
    
    //add the event
    EKEvent* event = nil;
    event = [EKEvent eventWithEventStore: [self eventStore]];
    event.calendar = self.eventStore.defaultCalendarForNewEvents;
    
    NSDateFormatter* frm = [[NSDateFormatter alloc] init];
    [frm setDateFormat:@"dd-MMM-yyyy"];
    [frm setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSTimeInterval noon = 12 * 60 * 60; //our dates are stored as midnight so set it to noon
    event.startDate = [[frm dateFromString: self.dateString] dateByAddingTimeInterval:noon];
    NSTimeInterval halfHour = 30 * 60; //seconds in half and hour
    event.endDate   = [event.startDate dateByAddingTimeInterval:halfHour]; //add 30 minutes
    
    event.title = @"";
    event.URL = [NSURL URLWithString:@""];
    event.notes = @"Event created via CalcuDates";
    
    //2 show the edit event dialogue
    self.editEvent.event = event;
    self.editEvent.event.title = @"";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAdBannerView" object:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


@end
