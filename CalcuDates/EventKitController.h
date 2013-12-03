//
//  EventKitController.h
//  ConferencePlannerForGeeks
//
//  Created by Ray Wenderlich on 7/24/12.
//  Copyright (c) 2012 raywenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

extern NSString *const EventsAccessGranted;

@interface EventKitController : NSObject

@property (strong, readonly) EKEventStore *eventStore;
@property (assign, readonly) BOOL eventAccess;

- (void) deleteEvent:(EKEvent *)event;
@end
