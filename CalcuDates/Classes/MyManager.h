//
//  MyManager.h
//  Bar Golf Stars
//
//  Created by Kerry Knight on 9/2/10.
//  Copyright (c) 2010 East Franklin Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyManager : NSObject {
    	 
}

@property (nonatomic, assign) BOOL adBannerIsShowing;
@property (nonatomic, assign) BOOL shouldServeAds;

+ (id)sharedInstance;
	 
@end