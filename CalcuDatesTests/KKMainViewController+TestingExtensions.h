//
//  KKMainViewController+TestingExtensions.h
//  CalcuDates
//
//  Created by Kerry Knight on 11/20/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKMainViewController.h"

@interface KKMainViewController (TestingExtensions) {
    
}

//method to permit access in unit testing
- (BOOL)timePeriodButtonSelected;
- (BOOL)gnuDateButtonSelected;

@end
