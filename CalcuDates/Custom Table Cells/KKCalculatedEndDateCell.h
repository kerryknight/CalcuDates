//
//  KKCalculatedEndDateCell.h
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKCalculatedEndDateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *calculatedEndDateField;
@property (weak, nonatomic) IBOutlet UIButton *addEventButton;

@property (nonatomic, strong) NSDictionary *calculationsDictionary;

- (void)endDateShouldCalculate:(NSNotification*)notification;

@end
