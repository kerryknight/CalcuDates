//
//  KKTabBarControllerTests.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/19/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "KKTabBarController.h"

@interface KKTabBarControllerTests : XCTestCase
@property (nonatomic, strong) KKTabBarController *sut;
@end

@implementation KKTabBarControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    self.sut = [[KKTabBarController alloc] init];
    self.sut = [storyboard instantiateViewControllerWithIdentifier:@"tabBarVC"];
    [self.sut performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    [self.sut performSelectorOnMainThread:@selector(viewDidLoad) withObject:nil waitUntilDone:YES];
    [self.sut performSelectorOnMainThread:@selector(viewDidAppear:) withObject:nil waitUntilDone:YES];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    self.sut = nil;
}

#pragma mark - Tab Bar Controller
- (void)test_hasATurnAnimationControllerIVar {
    Ivar ivar = class_getInstanceVariable([self.sut class], "_flipAnimationController");
    XCTAssertTrue(ivar != NULL, @"Tab bar controller needs a flip animation controller");
}

- (void)test_hasAHorizontalSwipeInteractionControllerIVar {
    Ivar ivar2 = class_getInstanceVariable([self.sut class], "_interactionController");
    XCTAssertTrue(ivar2 != NULL, @"Tab bar controller needs a horizontal swipe interaction controller");
}

@end
