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
    NSString *endDateStr = @"24-Oct-2009";
    
    // Convert string to date object
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    startDate = [dateFormat dateFromString:startDateStr];
    endDate = [dateFormat dateFromString:endDateStr];
    
    dateCalculations = [NSDictionary dictionaryWithDictionary:[KKDateManager doDateCalculationsForStartDate:startDateStr andEndDate:endDateStr]];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    
}

- (void)test_dateManagerReturnsCorrectDaysDifferenceAmount {
    XCTAssertEqualObjects(@"3653", dateCalculations[@"days"], @"KKDateManager class should calculate correct number of days difference.");
}

- (void)test_dateManagerReturnsCorrectWeeksDifferenceAmount {
    XCTAssertEqualObjects(@"521.9", dateCalculations[@"weeks"], @"KKDateManager class should calculate correct number of weeks difference.");
}

- (void)test_dateManagerReturnsCorrectMonthsDifferenceAmount {
    XCTAssertEqualObjects(@"120.44", dateCalculations[@"months"], @"KKDateManager class should calculate correct number of months difference.");
}

- (void)test_dateManagerReturnsCorrectYearsDifferenceAmount {
    XCTAssertEqualObjects(@"10.01", dateCalculations[@"years"], @"KKDateManager class should calculate correct number of years difference.");
}



@end
