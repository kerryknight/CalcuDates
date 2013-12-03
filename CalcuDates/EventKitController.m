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

@property (strong, readwrite) EKEventStore *eventStore;
@property (assign, readwrite) BOOL eventAccess;

@end

NSString *const EventsAccessGranted = @"EventsAccessGranted";

@implementation EventKitController

- (id) init {
//    NSLog(@"%s", __FUNCTION__);
    
    self = [super init];
    if (self) {
        
        self.eventStore = [[EKEventStore alloc] init];
        @weakify(self)
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            @strongify(self)
            if (granted) {
                self.eventAccess = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:EventsAccessGranted object:self];
            } else {
                NSLog(@"Event access not granted: %@", error);
            }
        }];
        _fetchQueue = dispatch_queue_create("com.conferencePlannerForGeeks.fetchQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void) deleteEvent:(EKEvent *)event {
//    NSLog(@"%s", __FUNCTION__);
    
    if (!self.eventAccess) {
        NSLog(@"No event acccess!");
        return;
    }
    
    dispatch_async(_fetchQueue, ^{
        
        //3. Delete the event
        NSError *err;
        [self.eventStore removeEvent:event span:event.hasRecurrenceRules ? EKSpanFutureEvents : EKSpanThisEvent commit:YES error:&err];
        
        BOOL success = [self.eventStore commit:&err];
        
        if (!success) {
            NSLog(@"There was an error deleting event");
        }
    });
    
}

@end
