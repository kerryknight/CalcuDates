//
//  KKDateDifferencesCell.h
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICountingLabel;
@interface KKDateDifferencesCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UICountingLabel *daysDifferenceField;
@property (weak, nonatomic) IBOutlet UICountingLabel *weeksDifferenceField;
@property (weak, nonatomic) IBOutlet UICountingLabel *monthsDifferenceField;
@property (weak, nonatomic) IBOutlet UICountingLabel *yearsDifferenceField;
@property (weak, nonatomic) IBOutlet UIButton *addEventButton;

@property (nonatomic, strong) NSDictionary *calculationsDictionary;

- (void)numbersShouldCalculate:(NSNotification*)notification;

@end
