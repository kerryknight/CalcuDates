//
//  KKDateManagerTests.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/19/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKDateManager.h"


@interface KKDateManagerTests : XCTestCase {
    NSIndexPath *dateStartRow;
    NSIndexPath *dateEndRow;
    NSIndexPath *buttonRow;
    NSIndexPath *dateDifferencesRow;
    
    NSDate *startDate;
    NSDate *endDate;
    NSDateFormatter *dateFormat;
    NSDictionary *dateCalculations;
    NSDictionary *endDateCalculations;
    NSString *calculatedEndDate;
}
@end

@implementation KKDateManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    dateStartRow = [NSIndexPath indexPathForRow:0 inSection:0];
    dateEndRow  = [NSIndexPath indexPathForRow:1 inSection:0];
    buttonRow  = [NSIndexPath indexPathForRow:2 inSection:0];
    dateDifferencesRow  = [NSIndexPath indexPathForRow:3 inSection:0];
    
    NSString *startDateStr = @"24-Oct-1999";
    NSString *endDateStr = @"06-Oct-2009";
    
    // Convert string to date object
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    startDate = [dateFormat dateFromString:startDateStr];
    endDate = [dateFormat dateFromString:endDateStr];
    
    dateCalculations = [NSDictionary dictionaryWithDictionary:[KKDateManager doDateCalculationsForStartDate:startDateStr andEndDate:endDateStr]];
    
    endDateCalculations = @{@"days"   : @1000,
                            @"weeks"  : @1000,
                            @"months" : @1000,
                            @"years"  : @1000};
    
    calculatedEndDate = [NSString stringWithString:[KKDateManager doEndDateCalculationForStartDate:startDateStr andTotalDurations:endDateCalculations]];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    
}

- (void)test_dateManagerReturnsCorrectDaysDifferenceAmount {
    XCTAssertEqualObjects(@"3635", dateCalculations[@"days"], @"KKDateManager class should calculate correct number of days difference.");
}

- (void)test_dateManagerReturnsCorrectWeeksDifferenceAmount {
    XCTAssertEqualObjects(@"519.3", dateCalculations[@"weeks"], @"KKDateManager class should calculate correct number of weeks difference.");
}

- (void)test_dateManagerReturnsCorrectMonthsDifferenceAmount {
    XCTAssertEqualObjects(@"119.85", dateCalculations[@"months"], @"KKDateManager class should calculate correct number of months difference.");
}

- (void)test_dateManagerReturnsCorrectYearsDifferenceAmount {
    XCTAssertEqualObjects(@"9.95", dateCalculations[@"years"], @"KKDateManager class should calculate correct number of years difference.");
}

- (void)test_dateManagerReturnsCorrectEndDateForDurationEntries {
    XCTAssertEqualObjects(@"20-Jan-3105", calculatedEndDate, @"KKDateManager class should calculate correct end date given durations.");
}



@end
