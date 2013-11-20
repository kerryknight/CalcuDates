//
//  KKTimePeriodTableViewController.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKTimePeriodTableViewController.h"
#import "KKDateCell.h"
#import "KKButtonBarCell.h"
#import "KKDateDifferencesCell.h"
#import "KKDatePickerCell.h"
#import "KKSlightIndentTextField.h"
#import "YLMoment.h"

#define kPickerAnimationDuration    0.25   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99     // view tag identifiying the date picker view

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value

// keep track of which rows have date cells
#define kDateStartRow    0
#define kDateEndRow      1
#define kButtonRow       2
#define kDateDifferencesRow 3

#define kDATE_PICKER_CELL_HEIGHT 162.0f
#define kHEADER_INSTRUCTION_WHITE_LABEL_HEIGHT 43.0f
#define kCALCULATE_BUTTONS_ROW_HEIGHT 55.0f
#define kDATE_DIFFERENCES_ROW_HEIGHT 165.0f


static NSString *kDateCellID = @"KKDateCell";     // the cells with the start or end date
static NSString *kDatePickerCellID = @"KKDatePickerCell"; // the cell containing the date picker
static NSString *kButtonCellID = @"KKButtonCell";     // the cell containing calculate/clear buttons
static NSString *kDateDifferencesCellID = @"KKDifferencesCell"; // the cell containing all the calculations

#pragma mark -

@interface KKTimePeriodTableViewController () <UIGestureRecognizerDelegate>{
    CGFloat calculatedDateDifferencesRowHeight;
}
@end

#pragma mark -

@implementation KKTimePeriodTableViewController

/*! Primary view has been loaded for this view controller
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup our data source
    NSMutableDictionary *itemOne = [@{ kTitleKey : @"Select Start Date*:",
                                       kDateKey : [NSDate date] } mutableCopy];
    NSMutableDictionary *itemTwo = [@{ kTitleKey : @"Select End Date*:",
                                         kDateKey : [NSDate date] } mutableCopy];
    NSMutableDictionary *itemThree = [@{ kTitleKey : @"Button row" } mutableCopy];
    NSMutableDictionary *itemFour = [@{ kTitleKey : @"Calculations row" } mutableCopy];
    self.dataArray = @[itemOne, itemTwo, itemThree, itemFour];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd-MMM-yyyy"];//allow customization of this later
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
//    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
//    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
    self.pickerCellRowHeight = kDATE_PICKER_CELL_HEIGHT;
    
    // knightka - this is from Apple example code; unused for now but could potentially be utilized later
    // if the locale changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
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
/*! Returns the major version of iOS, (i.e. for iOS 6.1.3 it returns 6)
 */
NSUInteger DeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    
    return _deviceSystemMajorVersion;
}

#define EMBEDDED_DATE_PICKER (DeviceSystemMajorVersion() >= 7)

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
        KKDateCell *associatedDatePickerCell = (KKDateCell*)[self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
   
        if (targetedDatePicker != nil) {
            // we found a UIDatePicker in this cell, so update it's date value
            //
            NSDictionary *itemData = self.dataArray[self.datePickerIndexPath.row - 1];
            [targetedDatePicker setDate:[itemData valueForKey:kDateKey] animated:NO];
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker {
//    NSLog(@"%s", __FUNCTION__);
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath {
//    NSLog(@"%s", __FUNCTION__);
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath {
    BOOL hasDate = NO;
    
    if ((indexPath.row == kDateStartRow) || (indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1)))) {
        hasDate = YES;
    }
    
    return hasDate;
}

- (CGFloat)determineDateRowHeight:(NSIndexPath*) indexPath {
    CGFloat h = self.tableView.rowHeight;
    
    if ((indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1)))) {
        h += 5;
    }
    
    return h;
}

/*! Determines if the given indexPath points to a cell that contains calculate/clear all buttons
 @param indexPath The indexPath to check if it represents button bar cell.
 */
- (BOOL)indexPathHasButtons:(NSIndexPath *)indexPath {
    BOOL hasButtons = NO;
    
    if (self.datePickerIndexPath != nil && ((indexPath.row == kButtonRow + 1) || (indexPath.row == kDateEndRow + 1))) {
        //we're showing a date picker so add 1 to each row
        hasButtons = YES;
    }
    
    if (self.datePickerIndexPath == nil && ((indexPath.row == kButtonRow) || (indexPath.row == kDateEndRow))) {
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


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self indexPathHasPicker:indexPath]) {
        // the indexPath is the one containing the inline date picker
        return self.pickerCellRowHeight;
    } else if ([self indexPathHasDate:indexPath]) {
        // the indexPath is one that contains the date information
        return [self determineDateRowHeight:indexPath];
    } else if ([self indexPathHasButtons:indexPath]) {
        // the indexPath is one that contains the buttons
        return kCALCULATE_BUTTONS_ROW_HEIGHT;
    } else {
        return [self determineDateDifferencesRowHeightForTableView:tableView forIndexPath:indexPath];
    }
}

//dynamically generate the height for our date differences row based on the device's window screen size
- (CGFloat)determineDateDifferencesRowHeightForTableView:(UITableView *)tableView forIndexPath:(NSIndexPath*)indexPath {
    //first, go through the app window to get at the main view controller's container view; for some reason,
    //accessing the iboutlet property in a .h file wasn't working for this so had to use viewWithTag:
    id appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    UIViewController *mainAppViewController = window.rootViewController;
    UIView *containerView = [mainAppViewController.view viewWithTag:kCONTAINER_VIEW_TAG];
    CGFloat containerViewHeight = containerView.frame.size.height;
    
    //since the rows in our table above us should be constants, calculate how far down the table our row starts
    CGFloat rowStartPoint = kCALCULATE_BUTTONS_ROW_HEIGHT + (self.tableView.rowHeight * 2); //rowHeight * 2 for 2 date fields
    
    //make our row at least as large as our nib file has it
    return MAX(kDATE_DIFFERENCES_ROW_HEIGHT, containerViewHeight - rowStartPoint - kHEADER_INSTRUCTION_WHITE_LABEL_HEIGHT);
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
    KKDateCell *cell = (KKDateCell *) [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:kDateCellID]) {
        if (EMBEDDED_DATE_PICKER)
            [self displayInlineDatePickerForRowAtIndexPath:indexPath];
        else
            [self displayExternalDatePickerForRowAtIndexPath:indexPath];
        
        return;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [self determineCellIdentifierForIndexPath:indexPath];
    
    UITableViewCell *cell;

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
    } else if ([cellID isEqualToString:kDateDifferencesCellID]) {
        KKDateDifferencesCell *sell = (KKDateDifferencesCell *) [tableView dequeueReusableCellWithIdentifier:kDateDifferencesCellID];
        
        if (sell == nil) {
            sell = [[KKDateDifferencesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDateDifferencesCellID];
        }
        
        [self configureDateDifferencesCell:sell forTableView:tableView atIndexPath:indexPath];
        
        cell = (UITableViewCell*)sell;//cast back to regular table cell so we can disable selection style
    } else {
        KKDatePickerCell *sell = (KKDatePickerCell *) [tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
        
        if (sell == nil) {
            sell = [[KKDatePickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDatePickerCellID];
            
            //configure cell at alloc as we only want to add our signal subscribers once so we don't end up with multiple
            //subscriptions each time a cell get's reused/cached
            [self configureDatePickerCell:sell];
        }
        
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
    } else {
        cellID = kDateDifferencesCellID;
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
    
    //if it's the end date row, add ability to swipe down to reveal start date row's date picker and swipe up to hide it
    if ((indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1)))) {
        [self addSwipeGesturesToCell:cell];
    }
    
    //pass our cell in to create our text field RAC subscribers
    [self subscribeRACTextFieldsForDateCell:cell forIndexPath:indexPath];
}

- (void)subscribeRACTextFieldsForDateCell:(KKDateCell*)cell forIndexPath:(NSIndexPath*)indexPath {
    //subscribe our cell value to the instance variable signals
    if ((indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1)))) {
        //end date cell row
        [[RACObserve(self, endDateString) distinctUntilChanged] subscribeNext:^(NSString *string) {
            //update a date text
            cell.date.text = self.endDateString;
        }];
    } else {
        //start date cell row
        [[RACObserve(self, startDateString) distinctUntilChanged] subscribeNext:^(NSString *string) {
            //update a date text
            cell.date.text = self.startDateString;
        }];
    }
}

#pragma mark Table Button Bar Cell Methods
- (void)configureButtonBarCell:(KKButtonBarCell*)cell atIndexPath:(NSIndexPath *)indexPath {
    //format buttons
    [cell.calculateButton setBackgroundImage:[UIImage imageNamed:@"btn_calculateHighlighted"] forState:UIControlStateHighlighted];
    [cell.clearButton setBackgroundImage:[UIImage imageNamed:@"btn_clearAllHighlighted"] forState:UIControlStateHighlighted];
    
    [cell.calculateButton addTarget:self action:@selector(calculateAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.clearButton addTarget:self action:@selector(clearAllAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // we decide here that any cell in the table not a date cell is not selectable (it's just an indicator)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSwipeGesturesToCell:cell];
}

#pragma mark Table Date Differences Cell Methods
- (void)configureDateDifferencesCell:(KKDateDifferencesCell*)cell forTableView:(UITableView* )tableView atIndexPath:(NSIndexPath *)indexPath {
    //format the bottom button
    [cell.addEventButton setBackgroundImage:[UIImage imageNamed:@"btn_addEventHighlighted"] forState:UIControlStateHighlighted];
    [cell.addEventButton addTarget:self action:@selector(addEventAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.frame = CGRectMake(cell.frame.origin.x,
                                  cell.frame.origin.y,
                                  cell.frame.size.width,
                                  [self determineDateDifferencesRowHeightForTableView:tableView forIndexPath:indexPath]);
    
    [self addSwipeGesturesToCell:cell];
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
/*! Checks to see if the row we swiped on is the date differences row, the last row in our table view
 If it is, we need to jump back 2 rows instead of one as we don't want to show a date picker for our button row above it
 @param gesture The swipe gesture performed on cell it's attached to
 */
- (BOOL)isCalculationsRow:(UIView *)viewForRow {
    BOOL isCalculationsRow = FALSE;
    
    if ([viewForRow isKindOfClass:[KKDateDifferencesCell class]]) {
        isCalculationsRow = TRUE;
    }
    
    return isCalculationsRow;
}

/*! Checks to see if the row we swiped on is the end date row
 @param gesture The swipe gesture performed on cell it's attached to
 */
- (BOOL)isEndDateRow:(id)viewForRow {
    BOOL isEndDateRow = FALSE;
    
    // get views cell
    UITableViewCell *cell = (UITableViewCell *)viewForRow;
    // get indexPath of cell
    NSIndexPath *idx = [self.tableView indexPathForCell:cell];
    
    if ([viewForRow isKindOfClass:[KKDateCell class]]) {
        if ((idx.row == kDateEndRow || ([self hasInlineDatePicker] && (idx.row == kDateEndRow + 1)))) {
            isEndDateRow = TRUE;
        }
    }
    
    return isEndDateRow;
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
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
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
        //verify if we swiped the last row or not
        BOOL isCalculationsRow = [self isCalculationsRow:[gesture view]];
        
        //if we swiped our last (the date differences/calculations row) row, we need to jump back up 2 rows instead of the usual 1
        rowsToRemove = isCalculationsRow ? 2 : 1;
        newRow = idx.row - rowsToRemove;
    }
    
    //check if we swiped up on a row; this should only ever kick in if we swiped up on the end date row while the start date row's date picker is showing
    //if so, we'll reset the newRow back to what it was and proceed so we can add the date picker for the end date row
    if (gesture.direction == UISwipeGestureRecognizerDirectionUp && [self isEndDateRow:[gesture view]]) {
        newRow = idx.row;
    }
    
    //since we want to display the date picker row above our swiped down row, create a new indexpath
    //and use the row above
    idxToDisplay = [NSIndexPath indexPathForRow:newRow inSection:0];
    //now that we have the indexpath the swipe was performed on, proceed with display of date picker
    [self displayInlineDatePickerForRowAtIndexPath:idxToDisplay];
}

- (void)hideAnyInlineDatePicker {
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker]) {
        [self.tableView beginUpdates];
        
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
        
        [self.tableView endUpdates];
    }
}

//this will hide any date picker first, then checks to see we're swiping the end date row up to reveal its date picker
- (void)hideAnyInlineDatePickerForRowWithSwipeGesture:(UISwipeGestureRecognizer *)gesture {
    
    //check if it's the end date row we swiped up on; if so, we should display the end date row's date picker
    if ([self isEndDateRow:[gesture view]] && [self hasInlineDatePicker]) {
        [self hideAnyInlineDatePicker];
        [self displayInlineDatePickerForRowWithSwipeGesture:gesture];
    } else {
        [self hideAnyInlineDatePicker];
    }
}

- (void)hideCalculationsRow {
    DLog(@"2");
}

/*! Reveals the UIDatePicker as an external slide-in view, iOS 6.1.x and earlier, called by "didSelectRowAtIndexPath".
 @param indexPath The indexPath used to display the UIDatePicker.
 */
- (void)displayExternalDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath {
    // first update the date picker's date value according to our model
    NSDictionary *itemData = self.dataArray[indexPath.row];
    [self.pickerView setDate:[itemData valueForKey:kDateKey] animated:YES];
    
    // the date picker might already be showing, so don't add it to our view
    if (self.pickerView.superview == nil) {
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = self.view.frame.size.height;
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        
        self.pickerView.frame = startFrame;
        
        [self.view addSubview:self.pickerView];
        
        // animate the date picker into view
        [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = endFrame; }
                         completion:^(BOOL finished) {
                             // add the "Done" button to the nav bar
                             self.navigationItem.rightBarButtonItem = self.doneButton;
                         }];
    }
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
    return swipeDownGestureRecognizer;
}

- (UISwipeGestureRecognizer *)addSwipeUpGestureForContext:(id)context {
    UISwipeGestureRecognizer *swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:context action:@selector(hideAnyInlineDatePickerForRowWithSwipeGesture:)];
    [swipeUpGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeUpGestureRecognizer setNumberOfTouchesRequired:1];
    swipeUpGestureRecognizer.delegate = self;
    return swipeUpGestureRecognizer;
}

#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender {
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker]) {
        // inline date picker: update the cell's date "above" the date picker cell
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    } else {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    KKDateCell *cell = (KKDateCell*)[self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    if ([self isEndDateRow:cell]) {
        self.endDateString = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    } else {
        self.startDateString = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    }
}


/*! User chose to finish using the UIDatePicker by pressing the "Done" button, (used only for non-inline date picker), iOS 6.1.x or earlier
 @param sender The sender for this action: The "Done" UIBarButtonItem
 */
- (IBAction)doneAction:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    CGRect pickerFrame = self.pickerView.frame;
    pickerFrame.origin.y = self.view.frame.size.height;
    
    // animate the date picker out of view
    [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = pickerFrame; }
                     completion:^(BOOL finished) {
                         [self.pickerView removeFromSuperview];
                     }];
    
    // remove the "Done" button in the navigation bar
	self.navigationItem.rightBarButtonItem = nil;
    
    // deselect the current table cell
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*! User is trying to calculate the time period differences by clicking the "Calculate" button.
 @param sender The sender for this action: The "Calculate" button.
 */
- (IBAction)calculateAction:(id)sender {
    [self hideAnyInlineDatePicker];
}

/*! User is trying to clear the date input fields by clicking the "Clear All" button.
 @param sender The sender for this action: The "Clear All" button.
 */
- (IBAction)clearAllAction:(id)sender {
    [self hideAnyInlineDatePicker];
}

/*! User wants to add a calendar event at the End Date value displayed
 @param sender The sender for this action: The "Add New Event" button.
 */
- (IBAction)addEventAction:(id)sender {
    [self hideAnyInlineDatePicker];
}

@end
