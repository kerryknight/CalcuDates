//
//  MyManager.m
//  Bar Golf Stars
//
//  Created by Kerry Knight on 9/2/10.
//  Copyright (c) 2010 East Franklin Company. All rights reserved.
//

#import "MyManager.h"

@implementation MyManager

@synthesize adBannerIsShowing, shouldServeAds;

#pragma mark Singleton Methods
+ (id)sharedInstance {
	
    static MyManager *sharedInstance;
    if (sharedInstance == nil) {
        sharedInstance = [[MyManager alloc] init];
    }
	return sharedInstance;
}

- (id)init {
	if ((self = [super init])) {
        
        //init all objects here
        self.adBannerIsShowing = NO;
        self.shouldServeAds = YES;
        
    }
    
	return self;
}

@end