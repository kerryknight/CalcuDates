//
//  KKTimePeriodTableViewControllerTests.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/19/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKTimePeriodTableViewController.h"
#import <objc/runtime.h>
#import "KKDateCell.h"
#import "KKButtonBarCell.h"
#import "KKDateDifferencesCell.h"
#import "KKDatePickerCell.h"
#import "KKSlightIndentTextField.h"


static NSString *kDateCellID = @"KKDateCell";     // the cells with the start or end date
static NSString *kDatePickerCellID = @"KKDatePickerCell"; // the cell containing the date picker
static NSString *kButtonCellID = @"KKButtonCell";     // the cell containing calculate/clear buttons
static NSString *kDateDifferencesCellID = @"KKDifferencesCell"; // the cell containing all the calculations

@interface KKTimePeriodTableViewControllerTests : XCTestCase {
    NSIndexPath *dateStartRow;
    NSIndexPath *dateEndRow;
    NSIndexPath *buttonRow;
    NSIndexPath *dateDifferencesRow;
}
@property (nonatomic, strong) KKTimePeriodTableViewController *sut;
@end

@implementation KKTimePeriodTableViewControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    //we need to load our nib from the storyboard to be able to access the view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    self.sut = [[KKTimePeriodTableViewController alloc] init];
    self.sut = [storyboard instantiateViewControllerWithIdentifier:@"TimePeriod"];
    //this forces iOS to load the nib, even though we’re not displaying anything
    [self.sut performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    [self.sut performSelectorOnMainThread:@selector(viewDidLoad) withObject:nil waitUntilDone:YES];
    [self.sut performSelectorOnMainThread:@selector(viewDidAppear:) withObject:nil waitUntilDone:YES];
    
    dateStartRow = [NSIndexPath indexPathForRow:0 inSection:0];
    dateEndRow  = [NSIndexPath indexPathForRow:1 inSection:0];
    buttonRow  = [NSIndexPath indexPathForRow:2 inSection:0];
    dateDifferencesRow  = [NSIndexPath indexPathForRow:3 inSection:0];
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
    XCTAssertTrue(ivar != NULL, @"Time period vc needs a calculate data differences row height ivar.");
}

#pragma mark - Properties
- (void)test_dataArray_hasFourItems {
    XCTAssertTrue([self.sut.dataArray count] == (NSUInteger)4, @"Time Period View Controller data array should have 4 items.");
}

- (void)test_dateFormatter_dateFormatIsInitiallyDDMMMYYYY {
    XCTAssertEqualObjects(self.sut.dateFormatter.dateFormat, @"dd-MMM-yyyy", @"Time Period View Controller date formatter dateFormat should initially be dd-MMM-yyyy.");
}

- (void)test_pickerCellRowHeight_valueIsSetToDatePickerCellHeightConstant {
    XCTAssertEqual((NSUInteger)self.sut.pickerCellRowHeight, (NSUInteger)162.0f, @"self.pickerCellRowHeight should be equal to kDATE_PICKER_CELL_HEIGHT constant value.");
}

#pragma mark - TableView
- (void)test_tableView_hasFourRows {
    XCTAssertTrue([self.sut.tableView numberOfRowsInSection:0] == (NSUInteger)4, @"Time Period View Controller table view should have 4 rows.");
}

- (void)test_tableView_hasFiveRowsAfterClickingOnStartDateRow {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    XCTAssertTrue([self.sut.tableView numberOfRowsInSection:0] == (NSUInteger)5, @"Time Period View Controller table view should have 5 rows after start date click.");
}

- (void)test_tableView_hasFiveRowsAfterClickingOnEndDateRow {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateEndRow];
    XCTAssertTrue([self.sut.tableView numberOfRowsInSection:0] == (NSUInteger)5, @"Time Period View Controller table view should have 5 rows after end date click.");
}

- (void)test_tableView_hasFiveRowsAfterClickingTwoDifferentDateRows {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateEndRow];
    XCTAssertTrue([self.sut.tableView numberOfRowsInSection:0] == (NSUInteger)5, @"Time Period View Controller table view should have 5 rows after clicking 2 different date rows.");
}

- (void)test_tableView_hasFourRowsAfterClickingStartDateRowTwice {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    XCTAssertTrue([self.sut.tableView numberOfRowsInSection:0] == (NSUInteger)4, @"Time Period View Controller table view should have 4 rows after clicking start date row twice.");
}

- (void)test_tableView_hasFourRowsAfterClickingEndDateRowTwice {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateEndRow];
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateEndRow];
    XCTAssertTrue([self.sut.tableView numberOfRowsInSection:0] == (NSUInteger)4, @"Time Period View Controller table view should have 4 rows after clicking end date row twice.");
}

- (void)test_tableView_rowCountEqualsDataArrayItemCount {
    XCTAssertTrue([self.sut.tableView numberOfRowsInSection:0] == [self.sut.dataArray count], @"Time Period View Controller table view row count should equal dataArray count.");
}

#pragma mark - Methods
- (void)test_datePickerIndexPathPropertyShouldBeNilIfDatePickerHidden {
    [self.sut hideAnyInlineDatePicker];
    XCTAssertNil(self.sut.datePickerIndexPath, @"Time Period View Controller must have a datePickerIndexPath property.");
}

- (void)test_datePickerIndexPathPropertyShouldNotBeNilStartDateRowClicked {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    XCTAssertNotNil(self.sut.datePickerIndexPath, @"datePickerIndexPath should not be nil if start date row is clicked.");
}

- (void)test_datePickerIndexPathPropertyShouldNotBeNilEndDateRowClicked {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateEndRow];
    XCTAssertNotNil(self.sut.datePickerIndexPath, @"datePickerIndexPath should not be nil if end date row is clicked.");
}

- (void)test_dateFieldsShouldOnlyAppearForStartAndEndDateRows {
    XCTAssertTrue([self.sut indexPathHasDate:dateStartRow] == TRUE, @"Date start row should have date");
    XCTAssertTrue([self.sut indexPathHasDate:dateEndRow] == TRUE, @"Date end row should have date");
    XCTAssertTrue([self.sut indexPathHasDate:buttonRow] == FALSE, @"Button row should not have date");
    XCTAssertTrue([self.sut indexPathHasDate:dateDifferencesRow] == FALSE, @"Date differences row should not have date");
}

- (void)test_shouldDetermineCorrectCellIDBaseOnIndexPath {
    XCTAssertEqualObjects([self.sut determineCellIdentifierForIndexPath:dateStartRow], kDateCellID, @"Index path for start date row should generate correct cell ID.");
    XCTAssertEqualObjects([self.sut determineCellIdentifierForIndexPath:dateEndRow], kDateCellID, @"Index path for end date row should generate correct cell ID.");
    XCTAssertEqualObjects([self.sut determineCellIdentifierForIndexPath:buttonRow], kButtonCellID, @"Index path for button row should generate correct cell ID.");
    XCTAssertEqualObjects([self.sut determineCellIdentifierForIndexPath:dateDifferencesRow], kDateDifferencesCellID, @"Index path for date differences row should generate correct cell ID.");
}

#pragma mark - Custom Table Cells
- (void)test_startDateRowCellShouldBeACustomDateCell {
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateStartRow] isKindOfClass:[KKDateCell class]], @"Cell at date start row should be a KKDateCell");
}

- (void)test_endDateRowCellShouldBeACustomDateCell {
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateEndRow] isKindOfClass:[KKDateCell class]], @"Cell at date end row should be a KKDateCell");
}

- (void)test_buttonRowCellShouldBeACustomButtonCell {
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:buttonRow] isKindOfClass:[KKButtonBarCell class]], @"Cell at button row should be a KKButtonBarCell");
}

- (void)test_dateDifferencesRowCellShouldBeACustomDateDifferencesCell {
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateDifferencesRow] isKindOfClass:[KKDateDifferencesCell class]], @"Cell at button row should be a KKDateDifferencesCell");
}

- (void)test_rowAfterStartDateCellAfterClickingStartDateCellShouldBeACustomDatePickerCell {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    NSIndexPath *pickerIndex = [NSIndexPath indexPathForRow:(dateStartRow.row + 1) inSection:0];
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:pickerIndex] isKindOfClass:[KKDatePickerCell class]], @"Row below clicked start date row should be a custom KKDAtePickerCell");
}

- (void)test_rowAfterEndDateCellAfterClickingEndDateCellShouldBeACustomDatePickerCell {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateEndRow];
    NSIndexPath *pickerIndex = [NSIndexPath indexPathForRow:(dateEndRow.row + 1) inSection:0];
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:pickerIndex] isKindOfClass:[KKDatePickerCell class]], @"Row below clicked end date row should be a custom KKDAtePickerCell");
}

- (void)test_rowAfterStartDateCellAfterClickingStartDateCellTwiceShouldBeACustomDateCell {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    NSIndexPath *pickerIndex = [NSIndexPath indexPathForRow:(dateStartRow.row + 1) inSection:0];
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:pickerIndex] isKindOfClass:[KKDateCell class]], @"Row after start date row after clicking start date row twice should be custom KKDateCell");
}

- (void)test_rowAfterEndDateCellAfterClickingEndDateCellTwiceShouldBeACustomButtonBarCell {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateEndRow];
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateEndRow];
    NSIndexPath *pickerIndex = [NSIndexPath indexPathForRow:(dateEndRow.row + 1) inSection:0];
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:pickerIndex] isKindOfClass:[KKButtonBarCell class]], @"Row after end date row after clicking end date row twice should be custom KKButtonBarCell");
}

- (void)test_rowAfterStartDateCellAfterClickingEndDateCellThenStartDateCellShouldBeACustomDatePickerCell {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateEndRow];
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    NSIndexPath *pickerIndex = [NSIndexPath indexPathForRow:(dateStartRow.row + 1) inSection:0];
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:pickerIndex] isKindOfClass:[KKDatePickerCell class]], @"Row after start date row after clicking end date row then start date row should be custom KKDatePickerCell");
}

- (void)test_rowAfterEndDateCellAfterClickingStartDateCellThenEndDateCellShouldBeACustomDatePickerCell {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateEndRow];
    NSIndexPath *pickerIndex = [NSIndexPath indexPathForRow:(dateEndRow.row + 1) inSection:0];
    XCTAssertTrue([[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:pickerIndex] isKindOfClass:[KKDatePickerCell class]], @"Row after end date row after clicking start date row then end date row should be custom KKDatePickerCell");
}

- (void)test_startDateCellShouldHaveCorrectTitle {
    KKDateCell *cell = (KKDateCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateStartRow];
    XCTAssertEqualObjects(cell.title.text, @"Select Start Date*:", @"Start date cell should have correct title.");
}

- (void)test_endDateCellShouldHaveCorrectTitle {
    KKDateCell *cell = (KKDateCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateEndRow];
    XCTAssertEqualObjects(cell.title.text, @"Select End Date*:", @"End date cell should have correct title.");
}

- (void)test_startDateCellShouldObserveStartDateStringValueViaRAC {
    KKDateCell *cell = (KKDateCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateStartRow];
    self.sut.startDateString = @"Fake Date";
    XCTAssertEqualObjects(cell.date.text, @"Fake Date", @"Start date cell should observe startDateString via RAC");
}

- (void)test_endDateCellShouldObserveEndDateStringValueViaRAC {
    KKDateCell *cell = (KKDateCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateEndRow];
    self.sut.endDateString = @"Fake Date";
    XCTAssertEqualObjects(cell.date.text, @"Fake Date", @"End date cell should observe endDateString via RAC");
}

- (void)test_buttonCellShouldHaveTwoConnectedButtons {
    KKButtonBarCell *cell = (KKButtonBarCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:buttonRow];
    XCTAssertTrue(cell.calculateButton != nil, @"Button cell calculate button should be connected.");
    XCTAssertTrue(cell.clearButton != nil, @"Button cell clear button should be connected.");
}

- (void)test_buttonCellCalculateButtonShouldCallCorrectAction {
    KKButtonBarCell *cell = (KKButtonBarCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:buttonRow];
    XCTAssertEqual(YES, [[cell.calculateButton actionsForTarget:self.sut forControlEvent:UIControlEventTouchUpInside] containsObject:@"calculateAction:"], @"Calculate Button should be connected to correct action");
}

- (void)test_buttonCellClearButtonShouldCallCorrectAction {
    KKButtonBarCell *cell = (KKButtonBarCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:buttonRow];
    XCTAssertEqual(YES, [[cell.clearButton actionsForTarget:self.sut forControlEvent:UIControlEventTouchUpInside] containsObject:@"clearAllAction:"], @"Clear Button should be connected to correct action");
}

- (void)test_dateDifferencesCellShouldHaveOneConnectedButtons {
    KKDateDifferencesCell *cell = (KKDateDifferencesCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateDifferencesRow];
    XCTAssertTrue(cell.addEventButton != nil, @"Date differences cell add event button should be connected.");
}

- (void)test_dateDifferencesCellAddEventButtonShouldCallCorrectAction {
    KKDateDifferencesCell *cell = (KKDateDifferencesCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateDifferencesRow];
    XCTAssertEqual(YES, [[cell.addEventButton actionsForTarget:self.sut forControlEvent:UIControlEventTouchUpInside] containsObject:@"addEventAction:"], @"Add Event Button should be connected to correct action");
}

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

- (void)test_endDateCellsSuperSuperviewShouldHaveTwoSwipeGestures {
    KKDateCell *cell = (KKDateCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateEndRow];
    XCTAssertTrue([[[cell.contentView superview] superview].gestureRecognizers count] == (NSUInteger)2, @"End date cell super superview should have 2 gestures attached.");
}

- (void)test_buttonCellsSuperSuperviewShouldHaveTwoSwipeGestures {
    KKButtonBarCell *cell = (KKButtonBarCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:buttonRow];
    XCTAssertTrue([[[cell.contentView superview] superview].gestureRecognizers count] == (NSUInteger)2, @"Button cell super superview should have 2 gestures attached.");
}

- (void)test_dateDifferencesCellsSuperSuperviewShouldHaveTwoSwipeGestures {
    KKDateDifferencesCell *cell = (KKDateDifferencesCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:dateDifferencesRow];
    XCTAssertTrue([[[cell.contentView superview] superview].gestureRecognizers count] == (NSUInteger)2, @"Date differences cell super superview should have 2 gestures attached.");
}

- (void)test_datePickerCellsSuperSuperviewShouldHaveZeroSwipeGestures {
    [self.sut displayInlineDatePickerForRowAtIndexPath:dateStartRow];
    NSIndexPath *pickerIndex = [NSIndexPath indexPathForRow:(dateStartRow.row + 1) inSection:0];
    KKDatePickerCell *cell = (KKDatePickerCell *)[self.sut tableView:self.sut.tableView cellForRowAtIndexPath:pickerIndex];
    XCTAssertTrue([[[cell.contentView superview] superview].gestureRecognizers count] == (NSUInteger)0, @"Date picker cell super superview should have 2 gestures attached.");
}


@end
    