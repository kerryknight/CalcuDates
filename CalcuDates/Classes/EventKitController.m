//
//  EventKitController.m
//  ConferencePlannerForGeeks
//
//  Created by Ray Wenderlich on 7/24/12.
//  Copyright (c) 2012 raywenderlich. All rights reserved.
//

#import "EventKitController.h"

@interface EventKitController() {
    dispatch_queue_t _fetchQueue;
}
@end

NSString *const EventsAccessGranted = @"EventsAccessGranted";

@implementation EventKitController

@synthesize eventStore = _eventStore;

- (id) init {
//    NSLog(@"%s", __FUNCTION__);
    
    self = [super init];
    if (self) {
        
        _eventStore = [[EKEventStore alloc] init];
        
        [_eventStore
            requestAccessToEntityType:EKEntityTypeEvent
            completion:^(BOOL granted, NSError *error) {
                
            if (granted) {
                _eventAccess = YES;
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:
                 EventsAccessGranted
                 object:self];
            } else {
                NSLog(@"Event access not granted: %@",
                                            error);
            }
        }];
        _fetchQueue =
            dispatch_queue_create("com.conferencePlannerForGeeks.fetchQueue",
                                  DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void) deleteEvent:(EKEvent *)event {
//    NSLog(@"%s", __FUNCTION__);
    
    if (!_eventAccess) {
        NSLog(@"No event acccess!");
        return;
    }
    
    dispatch_async(_fetchQueue, ^{
        
        //3. Delete the event
        NSError *err;
        [self.eventStore
         removeEvent:event
         span:event.hasRecurrenceRules ?
         EKSpanFutureEvents:EKSpanThisEvent
         commit:YES error:&err];
        
        BOOL success = [self.eventStore commit:&err];
        
        if (!success) {
            NSLog(@"There was an error deleting event");
        }
    });
    
}

@end
