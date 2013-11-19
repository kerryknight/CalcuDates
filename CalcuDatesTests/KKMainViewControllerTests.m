//
//  MainViewControllerTests.m
//  CalcuDatesTests
//
//  Created by Kerry Knight on 10/30/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "KKMainViewController.h"
#import "KKTabBarController.h"

@interface KKMainViewControllerTests : XCTestCase {
}

@property (nonatomic, strong) KKMainViewController *sut;
@end

@implementation KKMainViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    //we need to load our nib from the storyboard to be able to access the view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    self.sut = [[KKMainViewController alloc] init];
    self.sut = [storyboard instantiateViewControllerWithIdentifier:@"KKMainViewController"];
    //this forces iOS to load the nib, even though we’re not displaying anything
    [self.sut performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    [self.sut viewDidLoad];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.sut = nil;
}

#pragma mark - Main View Controller
- (void)test_main_vc_conformsToUIViewControllerTransitioningDelegateProtocol {
    XCTAssertTrue([self.sut conformsToProtocol: @protocol(UIViewControllerTransitioningDelegate)], @"Main View Controller must conform to UIViewControlelrTransitioningDelegate protocol.");
}

- (void)test_main_vc_conformsToUITabBarControllerDelegate {
    XCTAssertTrue([self.sut conformsToProtocol: @protocol(UITabBarControllerDelegate)], @"Main View Controller must conform to UITabBarControllerDelegate protocol.");
}

- (void)test_main_timePeriodButton_shouldBeSelectedInitially {
//    [self.sut toggleButtonSelections];
    XCTAssertTrue([self.sut timePeriodButtonSelected] == TRUE, @"Time Period button should be selected initially");
}

- (void)test_main_toggleButtonSelection_shouldSelectedNewDataView {
    [self.sut toggleButtonSelections];
    XCTAssertTrue([self.sut gnuDateButtonSelected] == TRUE, @"Subsequent toggleButtonSelections: should select New Data view");
}

#pragma mark - Time Period Button
- (void)test_main_timePeriodBarButton_shouldBeConnected {
    XCTAssertTrue(self.sut.timePeriodButton != nil, @"Time Period Button should have an outlet.");
}

- (void)test_main_timePeriodBarButton_shouldHaveOneAction {
    //be sure to cast the == # to an int as the assert compares object types too
    XCTAssertEqual((int)1, (int)[[self.sut.timePeriodButton actionsForTarget:self.sut forControlEvent:UIControlEventTouchUpInside] count], @"Time Period Button should be connected to only one action");
}

- (void)test_main_timePeriodBarButton_shouldTriggerCorrectAction {
    XCTAssertEqual(YES, [[self.sut.timePeriodButton actionsForTarget:self.sut forControlEvent:UIControlEventTouchUpInside] containsObject:@"timePeriodButtonClickHandler:"], @"Time Period Button should be connected to correct action");
}

#pragma mark - New Date Button
- (void)test_main_gnuDateBarButton_shouldBeConnected {
    XCTAssertTrue(self.sut.gnuDateButton != nil, @"New Date Button should have an outlet.");
}

- (void)test_main_gnuDateBarButton_shouldHaveOneAction {
    //be sure to cast the == # to an int as the assert compares object types too
    XCTAssertEqual((int)1, (int)[[self.sut.gnuDateButton actionsForTarget:self.sut forControlEvent:UIControlEventTouchUpInside] count], @"New Date Button should be connected to only one action");
}

- (void)test_main_gnuDateBarButton_shouldTriggerCorrectAction {
    XCTAssertEqual(YES, [[self.sut.gnuDateButton actionsForTarget:self.sut forControlEvent:UIControlEventTouchUpInside] containsObject:@"gnuDateButtonClickHandler:"], @"New Date Button should be connected to correct action");
}

#pragma mark - Settings Button
- (void)test_main_settingsButton_shouldBeConnected {
    XCTAssertTrue(self.sut.settingsButton != nil, @"Settings Button should have an outlet.");
}

- (void)test_main_settingsButton_shouldHaveOneAction {
    //be sure to cast the == # to an int as the assert compares object types too
    XCTAssertEqual((int)1, (int)[[self.sut.settingsButton actionsForTarget:self.sut forControlEvent:UIControlEventTouchUpInside] count], @"Settings Button should be connected to only one action");
}

- (void)test_main_settingsButton_shouldTriggerCorrectAction {
    XCTAssertEqual(YES, [[self.sut.settingsButton actionsForTarget:self.sut forControlEvent:UIControlEventTouchUpInside] containsObject:@"settingsButtonClickHandler:"], @"Settings Button should be connected to correct action");
}

#pragma mark - Container View
- (void)test_main_containerView_shouldBeConnected {
    XCTAssertTrue(self.sut.containerView != nil, @"Container View should have an outlet.");
}

#pragma mark - Tab Bar Controller
- (void)test_main_tabBarControllerIVar_exists {
    Ivar tabViewIVar = class_getInstanceVariable([self.sut class], "tabBarVC");
    XCTAssertTrue(tabViewIVar != NULL, @"View controller needs a tab bar controller");
}

@end
