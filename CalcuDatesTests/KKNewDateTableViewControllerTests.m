//
//  KKNewDateTableViewControllerTests.m
//  CalcuDates
//
//  Created by Kerry Knight on 12/2/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKNewDateTableViewController.h"
#import <objc/runtime.h>
#import "KKDateCell.h"
#import "KKButtonBarCell.h"
#import "KKDurationEntryCell.h"
#import "KKCalculatedEndDateCell.h"
#import "KKDatePickerCell.h"
#import "KKSlightIndentTextField.h"
#import "KKDateManager.h"


static NSString *kDateCellID = @"KKDateCell";     // the cells with the start or end date
static NSString *kDatePickerCellID = @"KKDatePickerCell"; // the cell containing the date picker
static NSString *kButtonCellID = @"KKButtonCell";     // the cell containing calculate/clear buttons
static NSString *KKDurationEntryCellID = @"KKDurationEntryCell"; // the cell containing the duration entry fields
static NSString *KKCalculatedEndDateCellID = @"KKCalculatedEndDateCell"; // the cell containing the calculated end date

@interface KKNewDateTableViewControllerTests : XCTestCase {
    NSIndexPath *dateStartRow;
    NSIndexPath *durationEntryRow;
    NSIndexPath *buttonRow;
    NSIndexPath *calculatedEndDateRow;
    
    NSDate *startDate;
    NSDateFormatter *dateFormat;
    NSDictionary *endDateCalculations;
    NSString *calculatedEndDate;
    
}
@property (nonatomic, strong) KKNewDateTableViewController *sut;
@end

@implementation KKNewDateTableViewControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    //we need to load our nib from the storyboard to be able to access the view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    self.sut = [[KKNewDateTableViewController alloc] init];
    self.sut = [storyboard instantiateViewControllerWithIdentifier:@"NewDate"];
    //this forces iOS to load the nib, even though we’re not displaying anything
    [self.sut performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    [self.sut performSelectorOnMainThread:@selector(viewDidLoad) withObject:nil waitUntilDone:YES];
    [self.sut performSelectorOnMainThread:@selector(viewDidAppear:) withObject:nil waitUntilDone:YES];
    
    dateStartRow = [NSIndexPath indexPathForRow:0 inSection:0];
    durationEntryRow  = [NSIndexPath indexPathForRow:1 inSection:0];
    buttonRow  = [NSIndexPath indexPathForRow:2 inSection:0];
    calculatedEndDateRow  = [NSIndexPath indexPathForRow:3 inSection:0];
    
    NSString *startDateStr = @"24-Oct-1999";
    
    // Convert string to date object
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    startDate = [dateFormat dateFromString:startDateStr];
    
    endDateCalculations = @{@"days"   : @1,
                            @"weeks"  : @1,
                            @"months" : @1,
                            @"years"  : @1};
    
    calculatedEndDate = [NSString stringWithString:[KKDateManager doEndDateCalculationForStartDate:startDateStr andTotalDurations:endDateCalculations]];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    
    self.sut = nil;
}

#pragma mark - iVars
- (void)test_calculatedDateDifferencesRowHeight_iVarExists {
    Ivar ivar = class_getInstanceVariable([self.sut class], "calculatedDateDifferencesRowHeight");
    XCTAssertTrue(ivar != NULL, @"New Date vc needs a calculate data differences row height ivar.");
}

#pragma mark - Properties
- (void)test_dataArray_hasFourItems {
    XCTAssertTrue([self.sut.dataArray count] == (NSUInteger)4, @"New Date View Controller data array should have 4 items.");
}

- (void)test_dateFormatter_dateFormatIsInitiallyDDMMMYYYY {
    XCTAssertEqualObjects(self.sut.dateFormatter.dateFormat, @"dd-MMM-yyyy", @"New Date View Controller date formatter dateFormat should initially be dd-MMM-yyyy.");
}

- (void)test_pickerCellRowHeight_valueIsSetToDatePickerCellHeightConstant {
    XCTAssertEqual((NSUInteger)self.sut.pickerCellRowHeight, (NSUInteger)162.0f, @"self.pickerCellRowHeight should be equal to kDATE_PICKER_CELL_HEIGHT constant value.");
}

#pragma mark - TableView
- (void)test_tableView_hasFourRows {
    XCTAssertTrue([self.sut.tableView numberOfRowsInSection:0] == (NSUInteger)4, @"New Date View Controller table view should have 4 rows.");
}

- (void)test_tableView_hasFiveRowsAfterClickingOnStartDateRow {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    XCTAssertTrue([self.sut.tableView numberOfRowsInSection:0] == (NSUInteger)5, @"New Date View Controller table view should have 5 rows after start date click.");
}

- (void)test_tableView_hasFourRowsAfterClickingStartDateRowTwice {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    XCTAssertTrue([self.sut.tableView numberOfRowsInSection:0] == (NSUInteger)4, @"New Date View Controller table view should have 4 rows after clicking start date row twice.");
}

- (void)test_tableView_rowCountEqualsDataArrayItemCount {
    XCTAssertTrue([self.sut.tableView numberOfRowsInSection:0] == [self.sut.dataArray count], @"New Date View Controller table view row count should equal dataArray count.");
}

#pragma mark - Methods
- (void)test_datePickerIndexPathPropertyShouldBeNilIfDatePickerHidden {
    [self.sut hideAnyInlineDatePicker];
    XCTAssertNil(self.sut.datePickerIndexPath, @"New Date View Controller must have a datePickerIndexPath property.");
}

- (void)test_datePickerIndexPathPropertyShouldNotBeNilStartDateRowClicked {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    XCTAssertNotNil(self.sut.datePickerIndexPath, @"datePickerIndexPath should not be nil if start date row is clicked.");
}

- (void)test_dateFieldsShouldOnlyAppearForStartDateRow {
    XCTAssertTrue([self.sut indexPathHasDate:dateStartRow] == TRUE, @"Date start row should have date");
    XCTAssertTrue([self.sut indexPathHasDate:calculatedEndDateRow] == FALSE, @"Calculated end date row should have date");
    XCTAssertTrue([self.sut indexPathHasDate:buttonRow] == FALSE, @"Button row should not have date");
    XCTAssertTrue([self.sut indexPathHasDate:durationEntryRow] == FALSE, @"Duration entry row should not have date");
}

- (void)test_shouldDetermineCorrectCellIDBaseOnIndexPath {
    XCTAssertEqualObjects([self.sut determineCellIdentifierForIndexPath:dateStartRow], kDateCellID, @"Index path for start date row should generate correct cell ID.");
    XCTAssertEqualObjects([self.sut determineCellIdentifierForIndexPath:calculatedEndDateRow], KKCalculatedEndDateCellID, @"Index path for calculated end date row should generate correct cell ID.");
    XCTAssertEqualObjects([self.sut determineCellIdentifierForIndexPath:buttonRow], kButtonCellID, @"Index path for button row should generate correct cell ID.");
    XCTAssertEqualObjects([self.sut determineCellIdentifierForIndexPath:durationEntryRow], KKDurationEntryCellID, @"Index path for date duration entry row should generate correct cell ID.");
}

#pragma mark - Custom Table Cells
#pragma mark - test cells exist
- (void)test_startDateRowCellShouldBeACustomDateCell {
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateStartRow] isKindOfClass:[KKDateCell class]], @"Cell at date start row should be a KKDateCell");
}

- (void)test_endDateRowCellShouldBeACustomDateCell {
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:calculatedEndDateRow] isKindOfClass:[KKCalculatedEndDateCell class]], @"Cell at date end row should be a KKCalculatedEndDateCell");
}

- (void)test_buttonRowCellShouldBeACustomButtonCell {
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:buttonRow] isKindOfClass:[KKButtonBarCell class]], @"Cell at button row should be a KKButtonBarCell");
}

- (void)test_dateDifferencesRowCellShouldBeACustomDateDifferencesCell {
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:durationEntryRow] isKindOfClass:[KKDurationEntryCell class]], @"Cell at button row should be a KKDurationEntryCell");
}

#pragma mark - date cells
- (void)test_rowAfterStartDateCellAfterClickingStartDateCellShouldBeACustomDatePickerCell {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    NSIndexPath *pickerIndex = [NSIndexPath indexPathForRow:(dateStartRow.row + 1) inSection:0];
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:pickerIndex] isKindOfClass:[KKDatePickerCell class]], @"Row below clicked start date row should be a custom KKDAtePickerCell");
}

- (void)test_rowAfterStartDateCellAfterClickingStartDateCellTwiceShouldBeACustomDurationEntryCell {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    NSIndexPath *pickerIndex = [NSIndexPath indexPathForRow:(dateStartRow.row + 1) inSection:0];
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:pickerIndex] isKindOfClass:[KKDurationEntryCell class]], @"Row after start date row after clicking start date row twice should be custom KKDurationEntryCell");
}

- (void)test_startDateCellShouldHaveCorrectTitle {
    KKDateCell *cell = (KKDateCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateStartRow];
    XCTAssertEqualObjects(cell.title.text, @"Select Start Date*:", @"Start date cell should have correct title.");
}

- (void)test_startDateCellShouldObserveStartDateStringValueViaRAC {
    KKDateCell *cell = (KKDateCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateStartRow];
    self.sut.startDateString = @"Fake Date";
    XCTAssertEqualObjects(cell.date.text, @"Fake Date", @"Start date cell should observe startDateString via RAC");
}

- (void)test_startDateCellTextFieldUpdatesWhenDateActionCalled {
    [self.sut hideAnyInlineDatePicker];
    //select the start date row
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    NSIndexPath *cellIndex = [NSIndexPath indexPathForRow:(dateStartRow.row) inSection:0];
    KKDateCell *cell = (KKDateCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:cellIndex];
    
    //create a date picker and set its date
    UIDatePicker *dp = [[UIDatePicker alloc] init];
    [dp setDate:(NSDate*)startDate];
    [self.sut dateAction:dp];
    
    NSDate *cellDate = [dateFormat dateFromString: cell.date.text];//cell date should be listening for the date picker's date
    
    XCTAssertEqualObjects(cellDate, startDate, @"Selecting a start date should update the start date text field");
}

#pragma mark - button cell
- (void)test_buttonCellShouldHaveOneConnectedButton {
    KKButtonBarCell *cell = (KKButtonBarCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:buttonRow];
    XCTAssertTrue(cell.clearButton != nil, @"Button cell clear button should be connected.");
}

- (void)test_buttonCellClearButtonShouldCallCorrectAction {
    KKButtonBarCell *cell = (KKButtonBarCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:buttonRow];
    XCTAssertEqual(YES, [[cell.clearButton actionsForTarget:self.sut forControlEvent:UIControlEventTouchUpInside] containsObject:@"clearAllAction:"], @"Clear Button should be connected to correct action");
}

#pragma mark - calculated end date cell
- (void)test_calculatedEndDateCellShouldHaveOneConnectedButtons {
    KKCalculatedEndDateCell *cell = (KKCalculatedEndDateCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:calculatedEndDateRow];
    XCTAssertTrue(cell.addEventButton != nil, @"Calculated end date cell add event button should be connected.");
}

- (void)test_dateDifferencesCellAddEventButtonShouldCallCorrectAction {
    KKCalculatedEndDateCell *cell = (KKCalculatedEndDateCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:calculatedEndDateRow];
    XCTAssertEqual(YES, [[cell.addEventButton actionsForTarget:self.sut forControlEvent:UIControlEventTouchUpInside] containsObject:@"addEventAction:"], @"Add Event Button should be connected to correct action");
}

#pragma mark - date picker cell
- (void)test_datePickerCellShouldHaveAConnectedDatePicker {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    NSIndexPath *pickerIndex = [NSIndexPath indexPathForRow:(dateStartRow.row + 1) inSection:0];
    KKDatePickerCell *cell = (KKDatePickerCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:pickerIndex];
    XCTAssertTrue(cell.datePicker != nil, @"Date picker cell datePicker should be connected.");
}

- (void)test_datePickerCellDatePickerShouldCallCorrectAction {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    NSIndexPath *pickerIndex = [NSIndexPath indexPathForRow:(dateStartRow.row + 1) inSection:0];
    KKDatePickerCell *cell = (KKDatePickerCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:pickerIndex];
    XCTAssertEqual(YES, [[cell.datePicker actionsForTarget:self.sut forControlEvent:UIControlEventValueChanged] containsObject:@"dateAction:"], @"Date picker should be connected to correct action");
}

#pragma mark - Swipe Gestures
- (void)test_startDateCellsSuperSuperviewShouldHaveZeroSwipeGestures {
    KKDateCell *cell = (KKDateCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateStartRow];
    XCTAssertTrue([[[cell.contentView superview] superview].gestureRecognizers count] == (NSUInteger)0, @"Start date cell super superview should have no gestures attached.");
}

- (void)test_DurationEntryCellsSuperSuperviewShouldHaveTwoSwipeGestures {
    KKDurationEntryCell *cell = (KKDurationEntryCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:durationEntryRow];
    XCTAssertTrue([[[cell.contentView superview] superview].gestureRecognizers count] == (NSUInteger)2, @"Duration Entry cell super superview should have 2 gestures attached.");
}

- (void)test_buttonCellsSuperSuperviewShouldHaveTwoSwipeGestures {
    KKButtonBarCell *cell = (KKButtonBarCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:buttonRow];
    XCTAssertTrue([[[cell.contentView superview] superview].gestureRecognizers count] == (NSUInteger)2, @"Button cell super superview should have 2 gestures attached.");
}

- (void)test_calculatedEndDateCellsSuperSuperviewShouldHaveTwoSwipeGestures {
    KKCalculatedEndDateCell *cell = (KKCalculatedEndDateCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:calculatedEndDateRow];
    XCTAssertTrue([[[cell.contentView superview] superview].gestureRecognizers count] == (NSUInteger)2, @"Calculated end date cell super superview should have 2 gestures attached.");
}

- (void)test_datePickerCellsSuperSuperviewShouldHaveZeroSwipeGestures {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    NSIndexPath *pickerIndex = [NSIndexPath indexPathForRow:(dateStartRow.row + 1) inSection:0];
    KKDatePickerCell *cell = (KKDatePickerCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:pickerIndex];
    XCTAssertTrue([[[cell.contentView superview] superview].gestureRecognizers count] == (NSUInteger)0, @"Date picker cell super superview should have 2 gestures attached.");
}


@end
