//
//  KKTimePeriodTableViewController+TestingExtensions.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/21/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKTimePeriodTableViewController+TestingExtensions.h"

@implementation KKTimePeriodTableViewController (TestingExtensions)

//this method is used in unit testing the date picker view's date selection correctly getting
//picked up by the end date row's text field RAC subscription; this is kind of a hack but i'm
//working around pre-coded Apple code for using inline date pickers here; the code *not* getting
//tested on that page is the - (BOOL)isEndDateRow:(id)viewForRow method b/c I'm not able to set the
//row view with an index path from a unit test very easily
- (void)fakeDateAction:(id)sender isEndDate:(BOOL)endDate {
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker]) {
        // inline date picker: update the cell's date "above" the date picker cell
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    } else {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UIDatePicker *targetedDatePicker = sender;
    
    if (endDate) {
        self.endDateString = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    } else {
        self.startDateString = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    }
}

@end
