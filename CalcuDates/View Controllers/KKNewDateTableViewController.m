//
//  KKNewDateTableViewController.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKNewDateTableViewController.h"
#import "KKDateCell.h"
#import "KKButtonBarCell.h"
#import "KKDurationEntryCell.h"
#import "KKCalculatedEndDateCell.h"
#import "KKDatePickerCell.h"
#import "KKSlightIndentTextField.h"
#import "KKDateManager.h"
#import "DAKeyboardControl.h"

static NSString *kDateCellID = @"KKDateCell";     // the cells with the start or end date
static NSString *kDatePickerCellID = @"KKDatePickerCell"; // the cell containing the date picker
static NSString *kDurationEntryCellID = @"KKDurationEntryCell"; // the cell containing numerical entry for durations
static NSString *kButtonCellID = @"KKButtonCell";     // the cell containing calculate/clear buttons
static NSString *kCalculatedEndDateCellID = @"KKCalculatedEndDateCell"; // the cell containing all the calculations

#pragma mark -

@interface KKNewDateTableViewController () <UIGestureRecognizerDelegate>{
    CGFloat calculatedDateDifferencesRowHeight;
}
@property (nonatomic, strong) NSString *calculatedEndDateString;
@end

#pragma mark -

@implementation KKNewDateTableViewController

/*! Primary view has been loaded for this view controller
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup our data source
    NSMutableDictionary *itemOne = [@{ kTitleKey : @"Select Start Date*:", kDateKey : [NSDate date] } mutableCopy];
    NSMutableDictionary *itemTwo = [@{ kTitleKey : @"Duration entry row"} mutableCopy];
    NSMutableDictionary *itemThree = [@{ kTitleKey : @"Button row" } mutableCopy];
    NSMutableDictionary *itemFour = [@{ kTitleKey : @"Calculations row" } mutableCopy];
    self.dataArray = @[itemOne, itemTwo, itemThree, itemFour];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd-MMM-yyyy"];//allow customization of this later
    self.pickerCellRowHeight = kDATE_PICKER_CELL_HEIGHT;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // knightka - this is from Apple example code; unused for now but could potentially be utilized later
    // if the locale changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissKeyboardAndResetTableViewToTopPosition) name:@"dismissAnyKeyboard" object:nil];
    
    [self configureDraggableKeyboard];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Locale
/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif {
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}


#pragma mark - Miscellaneous Methods
- (void)configureDraggableKeyboard {
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                     self.view.bounds.size.height,
                                                                     self.view.bounds.size.width,
                                                                     40.0f)];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:toolBar];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.frame = CGRectMake(toolBar.bounds.size.width - 68.0f,
                                  6.0f,
                                  58.0f,
                                  20.0f);
    [toolBar addSubview:doneButton];
    
    //never actually display the toolbar, it's used as a phantom responder in the area
    //just above the keyboard when it's displayed to react to our drag down gesture to
    //hide the keyboard;
    self.view.keyboardTriggerOffset = toolBar.bounds.size.height;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {}];
    
    self.keyboardIsShowing = NO;
}

/*! This is called when a notification to UIKeyboardWillHideNotification is posted
 */
- (void)keyboardWillHide {
    [self dismissKeyboardAndResetTableViewToTopPosition];
    self.keyboardIsShowing = NO;
}

/*! This is called when a notification to UIKeyboardWillShowNotification is posted
    KKButtonBarCell is a listener for this in order to disable buttons if partially obscured by keyboard
 */
- (void)keyboardWillShow {
    self.keyboardIsShowing = YES;
}

/*! Posts a notification to dismiss any keyboards (KKDurationEntryCell is a listener) that may be present
    and then scrolls our table view back up to the top so we can see everything
 */
- (void)dismissKeyboardAndResetTableViewToTopPosition {
    //remove outline on whatever textfield was active
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unhighlightDurationFields" object:nil];
    //dismiss any keyboard
    [self.view hideKeyboard];
    //then scroll our table view back up to the top so our header view is visible
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath {
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker {
    if (self.datePickerIndexPath != nil) {
        KKDatePickerCell *associatedDatePickerCell = (KKDatePickerCell*)[self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
   
        if (targetedDatePicker != nil) {
            // we found a UIDatePicker in this cell, so update it's date value
            
            //get the cell above the date picker
            NSIndexPath *dateCellIdx = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row-1 inSection:0];
            KKDateCell *cell = (KKDateCell *)[self.tableView cellForRowAtIndexPath:dateCellIdx];
            
            //ensure our cell actually has a date field
            if (![cell respondsToSelector:@selector(date)]) return;
            
            //create the NSDate from our cell's date text field
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd-MMM-yyyy"];
            NSDate *date = [dateFormat dateFromString:cell.date.text];
            
            if (date) {
                targetedDatePicker.date = date;
                return;
            }
            
            NSDate *now = [NSDate date];
            targetedDatePicker.date = now; //set the date picker to today's date initially
            
            //set our date field to what the date picker shows initially
            self.startDateString = [self.dateFormatter stringFromDate:targetedDatePicker.date];
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker {
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath {
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start date.
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath {
    BOOL hasDate = NO;
    
    if (indexPath.row == kNewDateViewDateStartRow) {
        hasDate = YES;
    }
    
    return hasDate;
}

/*! Determines if the given indexPath points to a cell that contains the date duration text fields.
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDateDurations:(NSIndexPath *)indexPath {
    BOOL hasDurations = NO;
    
    if ((![self hasInlineDatePicker] && indexPath.row == kNewDateViewDurationEntryRow) || ([self hasInlineDatePicker] && indexPath.row == kNewDateViewDurationEntryRow + 1)) {
        hasDurations = YES;
    }
    
    return hasDurations;
}

- (CGFloat)determineDateRowHeight:(NSIndexPath*) indexPath {
    return self.tableView.rowHeight;
}

/*! Determines if the given indexPath points to a cell that contains calculate/clear all buttons
 @param indexPath The indexPath to check if it represents button bar cell.
 */
- (BOOL)indexPathHasButtons:(NSIndexPath *)indexPath {
    BOOL hasButtons = NO;
    
    if (self.datePickerIndexPath != nil && (indexPath.row == kNewDateViewButtonRow + 1)) {
        //we're showing a date picker so add 1 to each row
        hasButtons = YES;
    }
    
    if (self.datePickerIndexPath == nil && (indexPath.row == kNewDateViewButtonRow)) {
        hasButtons = YES;
    }
    
    return hasButtons;
}

- (void)toggleDateDifferencesRowForSelectedIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath]) {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } else {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

//check each string property to ensure we have a value, otherwise set as empty string
- (NSDictionary*)createDurationsDictionary {
    return @{@"days"    : !self.daysString ? @"" : self.daysString,
             @"weeks"   : !self.weeksString ? @"" : self.weeksString,
             @"months"  : !self.monthsString ? @"" : self.monthsString,
             @"years"   : !self.yearsString ? @"" : self.yearsString};
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self indexPathHasPicker:indexPath]) {
        // the indexPath is the one containing the inline date picker
        return self.pickerCellRowHeight;
    } else if ([self indexPathHasDate:indexPath]) {
        // the indexPath is one that contains the date information or the duration entry text fields
        return [self determineDateRowHeight:indexPath];
    } else if ([self indexPathHasDateDurations:indexPath]) {
        // the indexPath is one that contains the duration entry text fields
        return kDURATION_ENTRY_ROW_HEIGHT;
    } else if ([self indexPathHasButtons:indexPath]) {
        // the indexPath is one that contains the buttons
        return kCALCULATE_BUTTONS_ROW_HEIGHT;
    } else {
        return [self determineEndDateCalculationRowHeightForTableView:tableView forIndexPath:indexPath];
    }
}

//dynamically generate the height for our date differences row based on the device's window screen size
- (CGFloat)determineEndDateCalculationRowHeightForTableView:(UITableView *)tableView forIndexPath:(NSIndexPath*)indexPath {
    //first, go through the app window to get at the main view controller's container view; for some reason,
    //accessing the iboutlet property in a .h file wasn't working for this so had to use viewWithTag:
    id appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    UIViewController *mainAppViewController = window.rootViewController;
    UIView *containerView = [mainAppViewController.view viewWithTag:kCONTAINER_VIEW_TAG];
    CGFloat containerViewHeight = containerView.frame.size.height;
    
    //since the rows in our table above us should be constants, calculate how far down the table our row starts
    CGFloat rowStartPoint = kCALCULATE_BUTTONS_ROW_HEIGHT + self.tableView.rowHeight + kDURATION_ENTRY_ROW_HEIGHT - 5; //1 date row + duration entry row + buttons row
    
    //make our row at least as large as our nib file has it
    return MAX(kEND_DATE_CALCULATION_ROW_HEIGHT, containerViewHeight - rowStartPoint - kHEADER_INSTRUCTION_WHITE_LABEL_HEIGHT);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self hasInlineDatePicker]) {
        // we have a date picker, so allow for it in the number of rows in this section
        NSInteger numRows = self.dataArray.count;
        
        return ++numRows;
    }
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
	if ([cell.reuseIdentifier isEqualToString:kDateCellID]) {
        [self dismissKeyboardAndResetTableViewToTopPosition];
		[self displayInlineDatePickerForRowAtIndexPath:indexPath];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [self determineCellIdentifierForIndexPath:indexPath];
    
    UITableViewCell *cell = nil;

    // proceed to configure our cell
    if ([cellID isEqualToString:kDateCellID]) {
        KKDateCell *sell = (KKDateCell *) [tableView dequeueReusableCellWithIdentifier:kDateCellID];
        
        if (sell == nil) {
            sell = [[KKDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDateCellID];
        }
        
        [self configureDateCell:sell atIndexPath:indexPath];
        
        cell = (UITableViewCell*)sell;//cast back to regular table cell so we can disable selection style
    } else if ([cellID isEqualToString:kButtonCellID]) {
        KKButtonBarCell *sell = (KKButtonBarCell *)[tableView dequeueReusableCellWithIdentifier:kButtonCellID];
        
        if (sell == nil) {
            sell = [[KKButtonBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kButtonCellID];
        }
        
        [self configureButtonBarCell:sell atIndexPath:indexPath];
        
        cell = (UITableViewCell*)sell;//cast back to regular table cell so we can disable selection style
    } else if ([cellID isEqualToString:kDurationEntryCellID]) {
        KKDurationEntryCell *sell = (KKDurationEntryCell *) [tableView dequeueReusableCellWithIdentifier:kDurationEntryCellID];
        
        if (sell == nil) {
            sell = [[KKDurationEntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDurationEntryCellID];
        }
        
        [self configureDurationEntryCell:sell atIndexPath:indexPath];
        cell = (UITableViewCell*)sell;//cast back to regular table cell so we can disable selection style
        
    } else if ([cellID isEqualToString:kCalculatedEndDateCellID]) {
        KKCalculatedEndDateCell *sell = (KKCalculatedEndDateCell *) [tableView dequeueReusableCellWithIdentifier:kCalculatedEndDateCellID];
        
        if (sell == nil) {
            sell = [[KKCalculatedEndDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCalculatedEndDateCellID];
        }
        
        [self configureEndDateCalculationCell:sell atIndexPath:indexPath];
        cell = (UITableViewCell*)sell;//cast back to regular table cell so we can disable selection style
        
    } else {
        KKDatePickerCell *sell = (KKDatePickerCell *) [tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
        
        if (sell == nil) {
            sell = [[KKDatePickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDatePickerCellID];
        }
        
        [self configureDatePickerCell:sell];
        
        cell = (UITableViewCell*)sell;//cast back to regular table cell so we can disable selection style
    }
    
    // we decide here that any cell in the table not a date cell is not selectable (it's just an indicator)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table Cell Helper Methods

- (NSString *) determineCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID;
    
    if ([self indexPathHasPicker:indexPath]) {
        // the indexPath is the one containing the inline date picker
        cellID = kDatePickerCellID;     // the current/opened date picker cell
    } else if ([self indexPathHasDate:indexPath]) {
        // the indexPath is one that contains the date information
        cellID = kDateCellID;       // the start/end date cells
    } else if ([self indexPathHasButtons:indexPath]) {
        // the indexPath is one that contains the buttons
        cellID = kButtonCellID;
    } else if ([self indexPathHasDateDurations:indexPath]) {
        // the indexPath is one that contains the buttons
        cellID = kDurationEntryCellID;
    } else {
        cellID = kCalculatedEndDateCellID;
    }
    
    return cellID;
}

- (NSDictionary*)getDataForRowAtIndexPath:(NSIndexPath *)indexPath {
    // if we have a date picker open whose cell is above the cell we want to update,
    // then we have one more cell than the model allows
    //
    NSInteger modelRow = indexPath.row;
    if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row < indexPath.row) {
        modelRow--;
    }
    
    NSDictionary *rowData = self.dataArray[modelRow];
    
    return rowData;
}

#pragma mark Table Date Cell Methods
- (void)configureDateCell:(KKDateCell*)cell atIndexPath:(NSIndexPath *)indexPath {
    //generate itemdata for row; this only applies to start/end date rows
    NSDictionary *itemData = [self getDataForRowAtIndexPath:indexPath];
    
    cell.title.text = [itemData valueForKey:kTitleKey];
    
    // we decide here that any cell in the table not a date cell is not selectable (it's just an indicator)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //pass our cell in to create our text field RAC subscribers
    [self subscribeRACTextFieldsForDateCell:cell forIndexPath:indexPath];
    
    //we'll monitor our border width to determine when our text field has been selected since there's not an 'isFirstResponder' key value
    @weakify(self)
    [RACObserve(cell.date, layer.borderWidth) subscribeNext:^(id width) {
        @strongify(self)
        if (width > 0)
            [self dismissKeyboardAndResetTableViewToTopPosition];
    }];
}

- (void)subscribeRACTextFieldsForDateCell:(KKDateCell*)cell forIndexPath:(NSIndexPath*)indexPath {
    //subscribe our cell value to the instance variable signals
    //start date cell row
    @weakify(self)
    [[RACObserve(self, startDateString) distinctUntilChanged] subscribeNext:^(NSString *string) {
        //update a date text
        cell.date.text = self.startDateString;
        
        @strongify(self)
        [self calculateAction];
    }];
}

#pragma mark Table Duration Entry Cell Methods
- (void)configureDurationEntryCell:(KKDurationEntryCell*)cell atIndexPath:(NSIndexPath *)indexPath {
    [self addSwipeGesturesToCell:cell];
    
    //subscribe our local duration string properties to values of text fields
    @weakify(self)
    [[RACSignal
      combineLatest:@[[cell.daysToAdd.rac_textSignal startWith:nil],
                      [cell.weeksToAdd.rac_textSignal startWith:nil],
                      [cell.monthsToAdd.rac_textSignal startWith:nil],
                      [cell.yearsToAdd.rac_textSignal startWith:nil]]
      reduce:^(NSString *days, NSString *weeks, NSString *months, NSString *years) {
          if (days.length > 0) self.daysString = days;
          if (weeks.length > 0) self.weeksString = weeks;
          if (months.length > 0) self.monthsString = months;
          if (years.length > 0) self.yearsString = years;
          return [RACSignal empty];
      }]
     subscribeNext:^(id value){
         //next, automatically recalculate
         @strongify(self)
        [self calculateAction];
     }];
    
    //subscribe to all our duration textfields and hide any date picker if one of them is highlighted
    [[RACSignal
     combineLatest:@[RACObserve(cell.daysToAdd, layer.borderWidth),
                     RACObserve(cell.weeksToAdd, layer.borderWidth),
                     RACObserve(cell.monthsToAdd, layer.borderWidth),
                     RACObserve(cell.yearsToAdd, layer.borderWidth)]
     reduce:^(id dayWidth, id weekWidth, id monthWidth, id yearWidth) {
         //if any of the duration fields are highlighted, hide any date picker that might be showing
         if (dayWidth > 0 || weekWidth > 0 || monthWidth > 0 || yearWidth > 0) [self hideAnyInlineDatePicker];
         return [RACSignal empty];
     }]
    subscribeCompleted:^{
        //completed
    }];
}

#pragma mark Table Button Bar Cell Methods
- (void)configureButtonBarCell:(KKButtonBarCell*)cell atIndexPath:(NSIndexPath *)indexPath {
    //format button
    [cell.clearButton setBackgroundImage:[UIImage imageNamed:@"btn_clearAllHighlighted"] forState:UIControlStateHighlighted];
    [cell.clearButton addTarget:self action:@selector(clearAllAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // we decide here that any cell in the table not a date cell is not selectable (it's just an indicator)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSwipeGesturesToCell:cell];
    
    //enable/disable our swipe gesture based on if the keyboard is showing or not
	RAC(cell, clearButton.enabled) = [RACSignal
                                         combineLatest:@[
                                                         RACObserve(self, keyboardIsShowing)
                                                         ] reduce: ^(NSNumber *isShowing) {
                                                             return @(!isShowing.boolValue);
                                                         }];
}

#pragma mark Table Date Differences Cell Methods
- (void)configureEndDateCalculationCell:(KKCalculatedEndDateCell*)cell atIndexPath:(NSIndexPath *)indexPath {
    //format the bottom button
    [cell.addEventButton setBackgroundImage:[UIImage imageNamed:@"btn_addEventHighlighted"] forState:UIControlStateHighlighted];
    [cell.addEventButton addTarget:self action:@selector(addEventAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.frame = CGRectMake(cell.frame.origin.x,
                                  cell.frame.origin.y,
                                  cell.frame.size.width,
                                  [self determineEndDateCalculationRowHeightForTableView:self.tableView forIndexPath:indexPath]);
    
    [self addSwipeGesturesToCell:cell];
    
    @weakify(self)
    [RACObserve(cell, calculatedEndDateField.text) subscribeNext:^(id x) {
        @strongify(self)
        self.calculatedEndDateString = x;
    }];
}

#pragma mark Table Date Picker Cell Methods
- (void)configureDatePickerCell:(KKDatePickerCell*)cell {
    [cell.datePicker addTarget:self action:@selector(dateAction:) forControlEvents:UIControlEventValueChanged];
    [cell.doneButton addTarget:self action:@selector(hideAnyInlineDatePicker) forControlEvents:UIControlEventTouchUpInside];
    
    // we decide here that any cell in the table not a date cell is not selectable (it's just an indicator)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)addSwipeGesturesToCell:(id)cell {
    //add swipe up/down gesture to row to close/open the end date date picker row
    [cell addGestureRecognizer:[self addSwipeDownGestureForContext:self]];
    [cell addGestureRecognizer:[self addSwipeUpGestureForContext:self]];
}

#pragma mark - Table UI Show/Hide
/*! Checks to see if the row we swiped on is the durations row, the last row in our table view
 @param gesture The swipe gesture performed on cell it's attached to
 */
- (BOOL)isDurationsRow:(UIView *)viewForRow {
    BOOL isDurationsRow = FALSE;
    
    if ([viewForRow isKindOfClass:[KKDurationEntryCell class]]) {
        isDurationsRow = TRUE;
    }
    
    return isDurationsRow;
}

/*! Checks to see if the row we swiped on is the calculated end date row, the last row in our table view
 @param gesture The swipe gesture performed on cell it's attached to
 */
- (BOOL)isCalculationsRow:(UIView *)viewForRow {
    BOOL isCalculationsRow = FALSE;
    
    if ([viewForRow isKindOfClass:[KKCalculatedEndDateCell class]]) {
        isCalculationsRow = TRUE;
    }
    
    return isCalculationsRow;
}

/*! Checks to see if the row we swiped on is the buttons row, the next to last row in our table view
 @param gesture The swipe gesture performed on cell it's attached to
 */
- (BOOL)isButtonsRow:(UIView *)viewForRow {
    BOOL isButtonsRow = FALSE;
    
    if ([viewForRow isKindOfClass:[KKButtonBarCell class]]) {
        isButtonsRow = TRUE;
    }
    
    return isButtonsRow;
}

/*! Adds or removes a UIDatePicker cell below the given indexPath.
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath]) {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } else {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath {
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker]) {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    [self hideAnyInlineDatePicker];
    
    if (!sameCellClicked) {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
        
        //also, highlight our date field
        [self highlightDateCellAtIndexPath:indexPath];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}

- (void)highlightDateCellAtIndexPath:(NSIndexPath*)indexPath {
    //highlight the corresponding date field
    KKDateCell *cell = (KKDateCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if([cell respondsToSelector:@selector(addTextFieldOutline)]) [cell addTextFieldOutline];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 @param gesture The swipe gesture performed on cell it's attached to
 */
- (void)displayInlineDatePickerForRowWithSwipeGesture:(UISwipeGestureRecognizer *)gesture {
    NSIndexPath *idx = nil;
    NSIndexPath *idxToDisplay = nil;
    NSInteger rowsToRemove = 0;
    
    // get affected cell
    UITableViewCell *cell = (UITableViewCell *)[gesture view];
    // get indexPath of cell
    idx = [self.tableView indexPathForCell:cell];
    NSInteger newRow = idx.row;
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        //we need to determine which row the gesture started on so that we can
        //ensure we remove the correct row in relation to it
        
        if ([self isDurationsRow:[gesture view]]) {
            rowsToRemove = [self hasInlineDatePicker] ? 2 : 1;
        }
        
        if ([self isButtonsRow:[gesture view]]) {
            rowsToRemove = [self hasInlineDatePicker] ? 3 : 2;
        }
        
        if ([self isCalculationsRow:[gesture view]]) {
            rowsToRemove = [self hasInlineDatePicker] ? 4 : 3;
        }
        
        newRow = idx.row - rowsToRemove;
    }
    
    //also, check if we made a legal downswipe gesture
    if (![self isLegalDownSwipeGesture:gesture]) return;
    
    //since we want to display the date picker row above our swiped down row, create a new indexpath
    //and use the row above
    idxToDisplay = [NSIndexPath indexPathForRow:newRow inSection:0];
    //now that we have the indexpath the swipe was performed on, proceed with display of date picker
    [self displayInlineDatePickerForRowAtIndexPath:idxToDisplay];
}

- (BOOL)isLegalDownSwipeGesture:(UISwipeGestureRecognizer*)gesture {
    //all swipes legal by default
    BOOL isLegal = YES;
    
    //check for illegal down swipes to prevent date pickers inadvertently getting inserted in wrong rows and/or downswipes causing close animations
    if (gesture.direction == UISwipeGestureRecognizerDirectionDown) {
        //if swipe down and self.datePickerIndexPath.row is one, it means the start date's date picker is showing, so exit
        if (self.datePickerIndexPath.row == 1) {
            isLegal = NO;
        }
    }
    return isLegal;
}

- (void)hideAnyInlineDatePicker {
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker]) {
        [self.tableView beginUpdates];
        
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
        
        [self.tableView endUpdates];
        
        //also, unhighlight any date fields
        [[NSNotificationCenter defaultCenter] postNotificationName:@"unhighlightDateField" object:nil];
    }
}

//this will hide any date picker first, then checks to see we're swiping the end date row up to reveal its date picker
- (void)hideAnyInlineDatePickerForRowWithSwipeGesture:(UISwipeGestureRecognizer *)gesture {
    [self hideAnyInlineDatePicker];
}

#pragma mark - Gesture Methods
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

- (UISwipeGestureRecognizer *)addSwipeDownGestureForContext:(id)context {
    UISwipeGestureRecognizer *swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:context action:@selector(displayInlineDatePickerForRowWithSwipeGesture:)];
    [swipeDownGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [swipeDownGestureRecognizer setNumberOfTouchesRequired:1];
    swipeDownGestureRecognizer.delegate = self;
    
	//enable/disable our swipe gesture based on if the keyboard is showing or not
	RAC(swipeDownGestureRecognizer, enabled) = [RACSignal
	                                            combineLatest:@[
                                                                RACObserve(self, keyboardIsShowing)
                                                                ] reduce: ^(NSNumber *isShowing) {
                                                                    return @(!isShowing.boolValue);
                                                                }];
    
    return swipeDownGestureRecognizer;
}

- (UISwipeGestureRecognizer *)addSwipeUpGestureForContext:(id)context {
    UISwipeGestureRecognizer *swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:context action:@selector(hideAnyInlineDatePickerForRowWithSwipeGesture:)];
    [swipeUpGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeUpGestureRecognizer setNumberOfTouchesRequired:1];
    swipeUpGestureRecognizer.delegate = self;
    
	//enable/disable our swipe gesture based on if the keyboard is showing or not
	RAC(swipeUpGestureRecognizer, enabled) = [RACSignal
	                                          combineLatest:@[
                                                              RACObserve(self, keyboardIsShowing)
                                                              ] reduce: ^(NSNumber *isShowing) {
                                                                  return @(!isShowing.boolValue);
                                                              }];
    
    return swipeUpGestureRecognizer;
}

#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender {
//    NSIndexPath *targetedCellIndexPath = nil;
//    
//    if ([self hasInlineDatePicker]) {
//        // inline date picker: update the cell's date "above" the date picker cell
//        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
//    } else {
//        // external date picker: update the current "selected" cell's date
//        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
//    }
    
    UIDatePicker *targetedDatePicker = sender;
    self.startDateString = [self.dateFormatter stringFromDate:targetedDatePicker.date];
}

/*! User is trying to calculate the end date by clicking the "Calculate" button.
 @param sender The sender for this action: The "Calculate" button.
 */
- (void)calculateAction {
    //don't do anything if we don't have start date and at least one duration set
    if (self.startDateString.length <= 0 || (self.daysString.length <= 0 && self.weeksString.length <= 0 && self.monthsString.length <= 0 && self.yearsString.length <= 0)) return;
    
    //returns our calculated end date as NSString
    NSString *endDateCalculation = [KKDateManager doEndDateCalculationForStartDate:self.startDateString andTotalDurations:[self createDurationsDictionary]];
    //attach our end date string to notification and post; listened to by KKCalculatedEndDateCell
    [[NSNotificationCenter defaultCenter] postNotificationName:@"calculateEndDate" object:nil userInfo:@{@"endDate" : endDateCalculation}];
}

/*! User is trying to clear the date input fields by clicking the "Clear All" button.
 @param sender The sender for this action: The "Clear All" button.
 */
- (IBAction)clearAllAction:(id)sender {
    [self hideAnyInlineDatePicker];
    
    //tell our KKDateCells to reset themselves via notifications
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zeroDateDifferences" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clearDurationFields" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clearDateFields" object:nil];
    
    //clear our local date string properties
    self.startDateString = @"";
}

/*! User wants to add a calendar event at the End Date value displayed
 @param sender The sender for this action: The "Add New Event" button.
 */
- (IBAction)addEventAction:(id)sender {
    [self hideAnyInlineDatePicker];
    NSDictionary *dateToAdd = @{@"date" : self.calculatedEndDateString};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewEvent" object:nil userInfo:dateToAdd];
}

@end
