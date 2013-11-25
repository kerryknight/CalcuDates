//
//  KKDateDifferencesCellTests.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/22/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKDateDifferencesCell.h"
#import "UICountingLabel.h"

@interface KKDateDifferencesCellTests : XCTestCase {
    NSDictionary *calculations;
}
@property (nonatomic, strong) KKDateDifferencesCell *sut;
@end

@implementation KKDateDifferencesCellTests

- (void)setUp {
	[super setUp];
	// Put setup code here; it will be run once, before the first test case.
    
	calculations = @{ @"days": @124,
		              @"weeks": @23.3,
		              @"months": @12.37,
		              @"years": @2.45 };
    
    self.sut = [[KKDateDifferencesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"foo"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"calculateDateDifferences" object:nil userInfo:calculations];
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    
    self.sut = nil;
}

- (void)test_dateDifferencesCellShouldHaveCountingLabelsConnected {
    XCTAssertTrue([self.sut.daysDifferenceField isKindOfClass:[UICountingLabel class]], @"Days difference label should be a UICountingLabel");
    XCTAssertTrue([self.sut.weeksDifferenceField isKindOfClass:[UICountingLabel class]], @"Weeks difference label should be a UICountingLabel");
    XCTAssertTrue([self.sut.monthsDifferenceField isKindOfClass:[UICountingLabel class]], @"Months difference label should be a UICountingLabel");
    XCTAssertTrue([self.sut.yearsDifferenceField isKindOfClass:[UICountingLabel class]], @"Years difference label should be a UICountingLabel");
}

- (void)test_dateDifferencesCellShowCorrectCalculations {
    [RACObserve(self.sut, calculationsDictionary) subscribeNext:^(NSDictionary *sender) {
        XCTAssertEqualObjects(calculations, sender, @"Date differences cell sent and returned calculations dictionary should be the same");
    }];
}

- (void)test_dateDifferencesCellDaysCountingLabelDestinationValueShouldMatchInputValue {
    float sentNum = [calculations[@"days"] floatValue];
    XCTAssertTrue(self.sut.daysDifferenceField.destinationValue == sentNum, @"Days difference label destination value should be equal to days value passed in");
}

- (void)test_dateDifferencesCellWeeksCountingLabelDestinationValueShouldMatchInputValue {
    float sentNum = [calculations[@"weeks"] floatValue];
    XCTAssertTrue(self.sut.weeksDifferenceField.destinationValue == sentNum, @"Weeks difference label destination value should be equal to days value passed in");
}

- (void)test_dateDifferencesCellMonthsCountingLabelDestinationValueShouldMatchInputValue {
    float sentNum = [calculations[@"months"] floatValue];
    XCTAssertTrue(self.sut.monthsDifferenceField.destinationValue == sentNum, @"Months difference label destination value should be equal to days value passed in");
}

- (void)test_dateDifferencesCellYearsCountingLabelDestinationValueShouldMatchInputValue {
    float sentNum = [calculations[@"years"] floatValue];
    XCTAssertTrue(self.sut.yearsDifferenceField.destinationValue == sentNum, @"Years difference label destination value should be equal to days value passed in");
}

- (void)test_postingClearNotificationShouldClearAllLabels {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zeroDateDifferences" object:nil];
    XCTAssertEqualObjects(self.sut.daysDifferenceField.text, @"0", @"Days field should be cleared");
    XCTAssertEqualObjects(self.sut.weeksDifferenceField.text, @"0.0", @"Weeks field should be cleared");
    XCTAssertEqualObjects(self.sut.monthsDifferenceField.text, @"0.00", @"Months field should be cleared");
    XCTAssertEqualObjects(self.sut.yearsDifferenceField.text, @"0.00", @"Years field should be cleared");
}



@end
