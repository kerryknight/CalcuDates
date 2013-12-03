//
//  KKAppDelegate.m
//  CalcuDates
//
//  Created by Kerry Knight on 10/30/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKAppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import <RevMobAds/RevMobAds.h>

@interface KKAppDelegate () {
    NSTimer *_myTimer;
    int _closeAdCount;
    BOOL _spinnerIsShowing;
    BOOL _fullscreenAdIsShowing;
}

- (NSTimer*)createTimerWithInterval:(NSTimeInterval)interval;
- (void)resetTimer;

@end

#define REV_MOB_FULLSCREEN_AD_TIMER_INTERVAL 60 * 5 //60 * 5 -> every 5 minutes
#define REV_MOB_FULLSCREEN_AD_TIMER_RESET_DELAY 60 * 60 * 24 //1 full day

@implementation KKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIColor *drkBlue = DRK_BLUE;
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:drkBlue, NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica-Light" size:20], NSFontAttributeName, nil]];
    
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    
    // Override point for customization after application launch.
    [RevMobAds startSessionWithAppID:REV_MOB_APP_ID];
    [RevMobAds session].userAgeRangeMin = 18;
    [RevMobAds session].connectionTimeout = 5; // 5 seconds
    [RevMobAds session].parallaxMode = RevMobParallaxModeOff;
    [RevMobAds session].testingMode = RevMobAdsTestingModeOff;
    
    //set the close ad count
    _closeAdCount = 0;
    
    //reset our fullscreen banner ad timer
    [self resetTimer];
    
    [Crashlytics startWithAPIKey:@"72614ec4b03fbf638deccdb46a34d1ef0b3a0a62"];
    
    return YES;
}


#pragma mark - Fullscreen Block-based methods
- (void)loadFullScreenAd {
    DLog(@"");
    RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
    @weakify(self)
    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
        [fs showAd];
//        NSLog(@"Ad loaded");
        
        //we invalidate it here because you can't pause/play timers; you have to recreate them which we do at ad close
        if([_myTimer isValid]){
            [_myTimer invalidate];
            _myTimer = nil;
        }
        
    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
//        NSLog(@"Ad error: %@",error);
    } onClickHandler:^{
        @strongify(self)
//        NSLog(@"Ad clicked");
        _closeAdCount = 3;
        //pretend we closed the ad so we don't show the daily ad to the user again until the next day
        [self resetTimer];
    } onCloseHandler:^{
        @strongify(self)
//        NSLog(@"Ad closed");
        [self resetTimer];
    }];
}

#pragma mark - RevMob Timer custom methods
- (void)resetTimer {
    //invalidate first in case we got here prior to anything else running
    if([_myTimer isValid]){
        [_myTimer invalidate];
        _myTimer = nil;
    }
    
    _closeAdCount++;  //we start at 0 so this will give us 2 closes
    
    if (_closeAdCount < 3) {
//        DLog(@"closed ad count < 3");
        //there is no start/stop for a timer so set it up again
        _myTimer = [self createTimerWithInterval:REV_MOB_FULLSCREEN_AD_TIMER_INTERVAL];
        
    } else {
//        NSLog(@"closed ad count => 3 so timer reset tomorrow");
        //wait a day before restarting the timer
        _myTimer = [self createTimerWithInterval:REV_MOB_FULLSCREEN_AD_TIMER_RESET_DELAY];
        //reset the counter
        _closeAdCount = 0;
        
    }
}

- (NSTimer*)createTimerWithInterval:(NSTimeInterval)interval {
//    DLog(@"timer = %0.0f", interval);
    NSTimer *newTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(loadFullScreenAd) userInfo:nil repeats:YES];
    return newTimer;
}

@end
