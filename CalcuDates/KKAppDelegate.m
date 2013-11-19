//
//  KKAppDelegate.m
//  CalcuDates
//
//  Created by Kerry Knight on 10/30/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKAppDelegate.h"
#import "UINavigationController+MHDismissModalView.h"

@implementation KKAppDelegate

//If you set the log level to LOG_LEVEL_ERROR, then you will only see DDLogError statements.
//If you set the log level to LOG_LEVEL_WARN, then you will only see DDLogError and DDLogWarn statements.
//If you set the log level to LOG_LEVEL_INFO, you'll see Error, Warn and Info statements.
//If you set the log level to LOG_LEVEL_DEBUG, you'll see Error, Warn, Info and Debug statements.
//If you set the log level to LOG_LEVEL_VERBOSE, you'll see all DDLog statements.
//If you set the log level to LOG_LEVEL_OFF, you won't see any DDLog statements.

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //************************ MHDismiss Frosted Modal View ***********************************************************//
    //Global Call to install MHDismiss
    MHDismissIgnore *withoutScroll = [[MHDismissIgnore alloc] initWithViewControllerName:@"KKSettingsViewController"
                                                                        ignoreBlurEffect:NO
                                                                           ignoreGesture:NO];
    
    [[MHDismissSharedManager sharedDismissManager] installWithTheme:MHModalThemeWhite
                                                  withIgnoreObjects:@[withoutScroll]];
    //************************ /MHDismiss Frosted Modal View **********************************************************//
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        DLog(@"Load resources for iOS 6.1 or earlier");
    } else {
        DLog(@"Load resources for iOS 7 or later");
        UIColor *drkBlue = DRK_BLUE;
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:drkBlue, NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica-Light" size:20], NSFontAttributeName, nil]];
        
        [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
