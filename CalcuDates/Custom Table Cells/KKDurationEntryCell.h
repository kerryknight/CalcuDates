//
//  KKDurationEntryCell.h
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKDurationEntryCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UITextField *daysToAdd;
@property (nonatomic, weak) IBOutlet UITextField *weeksToAdd;
@property (nonatomic, weak) IBOutlet UITextField *monthsToAdd;
@property (nonatomic, weak) IBOutlet UITextField *yearsToAdd;

- (void)addOutlineToTextField:(UITextField*)textField;
- (void)removeTextFieldOutlines;
@end
