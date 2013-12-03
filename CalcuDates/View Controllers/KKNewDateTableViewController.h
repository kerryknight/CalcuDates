//
//  KKNewDateTableViewController.h
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKNewDateTableViewController : UITableViewController {
    
}

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (assign) NSInteger pickerCellRowHeight;
@property (nonatomic, weak) NSString *startDateString;
@property (nonatomic, strong) NSString *daysString;
@property (nonatomic, strong) NSString *weeksString;
@property (nonatomic, strong) NSString *monthsString;
@property (nonatomic, strong) NSString *yearsString;
@property (nonatomic, assign) BOOL keyboardIsShowing;

@property (nonatomic, weak) IBOutlet UIDatePicker *pickerView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

- (void)hideAnyInlineDatePicker;
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath;
- (NSString *) determineCellIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (IBAction)dateAction:(id)sender;
- (BOOL)hasInlineDatePicker;
@end
