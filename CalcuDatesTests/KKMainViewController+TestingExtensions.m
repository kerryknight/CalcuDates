//
//  KKMainViewController+TestingExtensions.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/20/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKMainViewController+TestingExtensions.h"

@implementation KKMainViewController (TestingExtensions)

#pragma mark - For Unit Testing Only
- (BOOL)timePeriodButtonSelected {
    return [self.timePeriodButton isSelected];
}

- (BOOL)gnuDateButtonSelected {
    return [self.gnuDateButton isSelected];
}

@end
