//
//  KKSettingsViewControllerTests.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/19/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "KKSettingsViewController.h"

@interface KKSettingsViewControllerTests : XCTestCase
@property (nonatomic, strong) KKSettingsViewController *sut;
@end

@implementation KKSettingsViewControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    //we need to load our nib from the storyboard to be able to access the view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    self.sut = [[KKSettingsViewController alloc] init];
    self.sut = [storyboard instantiateViewControllerWithIdentifier:@"KKSettingsViewController"];
    [self.sut performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    [self.sut performSelectorOnMainThread:@selector(viewDidLoad) withObject:nil waitUntilDone:YES];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    self.sut = nil;
}

- (void)test_settingsViewController_titleIsSetToAcknowledgements {
    XCTAssertEqualObjects(self.sut.title, @"Acknowledgements", @"Settings View title should be set to Acknowledgements");
}

- (void)test_settingsViewController_correctAppVersionIsDisplayed {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *expectedLabelText = [NSString stringWithFormat:@"Version: %@", version];
    XCTAssertEqualObjects(self.sut.versionLabel.text, expectedLabelText, @"Settings View title should be set to Acknowledgements");
}

@end
