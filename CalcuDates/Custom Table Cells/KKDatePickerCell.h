//
//  KKDatePickerCell.h
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKDatePickerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end
