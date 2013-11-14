//
//  KKMainViewController.m
//  CalcuDates
//
//  Created by Kerry Knight on 10/30/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKMainViewController.h"
#import "KKTabBarController.h"
#import "KKTimePeriodTableViewController.h"
#import "KKNewDateTableViewController.h"
#import "UIImage+ImageEffects.h"
#import "UINavigationController+MHDismissModalView.h"
#import "KKSettingsViewController.h"

#pragma mark -
#pragma mark @categories
//category to enable more easily tracing ambiguous layout issues
@interface UIWindow (AutoLayoutDebug)
+ (UIWindow *) keyWindow;
- (NSString *) _autolayoutTrace;
@end

#define kTIME_PERIOD_VIEW_INDEX 0
#define kNEW_DATE_VIEW_INDEX 1

#pragma mark -
#pragma mark @interface

@interface KKMainViewController () <UIViewControllerTransitioningDelegate, UITabBarControllerDelegate> {
    //instance vars
    BOOL timePeriodSelected;
    BOOL gnuDateSelected;
    KKTabBarController *tabBarVC;
}

//IBOutlets
@property (weak, nonatomic) IBOutlet UIButton *timePeriodButton;
@property (weak, nonatomic) IBOutlet UIButton *gnuDateButton; //"gnu" to not conflict with reserved cocoa naming conventions
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

//IBActions
- (IBAction)timePeriodButtonClickHandler:(id)sender;
- (IBAction)gnuDateButtonClickHandler:(id)sender;
- (IBAction)settingsButtonClickHandler:(id)sender;

@end

#pragma mark -
#pragma mark @implementation
@implementation KKMainViewController

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //hide out tab bar view as we only want the tab bar controller's container functionality but not its buttons
    [[self.view viewWithTag:999] setHidden:TRUE];
    
    //setup and initialize our buttons
    [self initializeButtons];
    
    //call this to trace autolayout issues
//    [self performSelector:@selector(wrapperForLoggingAutoLayoutConstraints) withObject:nil afterDelay:1.0];
    
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"interactiveSwipeTransitionDidComplete" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSLog(@"%s", __FUNCTION__);
//    NSLog(@"seque: %@", segue.identifier);
    
    if ([segue.identifier isEqualToString:@"ShowTabBarController"]) {
        tabBarVC = segue.destinationViewController;
    }
}

#pragma mark -
#pragma mark Button Methods
- (void) initializeButtons {
    //set our buttons' highlighted and selected state images
    [self.timePeriodButton setBackgroundImage:[UIImage imageNamed:@"btn_timePeriodHighlighted"] forState:UIControlStateHighlighted];
    [self.timePeriodButton setBackgroundImage:[UIImage imageNamed:@"btn_timePeriodSelected"] forState:UIControlStateSelected];
    [self.timePeriodButton setBackgroundImage:[UIImage imageNamed:@"btn_timePeriodSelected"] forState:UIControlStateSelected | UIControlStateHighlighted]; //disables highlight if selected
    [self.gnuDateButton setBackgroundImage:[UIImage imageNamed:@"btn_newDateHighlighted"] forState:UIControlStateHighlighted];
    [self.gnuDateButton setBackgroundImage:[UIImage imageNamed:@"btn_newDateSelected"] forState:UIControlStateSelected];
    [self.gnuDateButton setBackgroundImage:[UIImage imageNamed:@"btn_newDateSelected"] forState:UIControlStateSelected | UIControlStateHighlighted]; //disables highlight if selected
    
    //on load, set our time period button active
    timePeriodSelected = TRUE;
    gnuDateSelected = FALSE;
    [self toggleButtonSelections];
    
    //listen for change events broadcast by swipe interactions so we can correctly toggle to other selected button
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleButtonSelections) name:@"interactiveSwipeTransitionDidComplete" object:nil];
}

- (IBAction) timePeriodButtonClickHandler:(id)sender {
    //return if already selected
    if (self.timePeriodButton.isSelected == TRUE) return;
    
    [self toggleButtonSelections];
    
    //select the time period view controller/tab
    if (tabBarVC) [tabBarVC setSelectedIndex:kTIME_PERIOD_VIEW_INDEX];
}

- (IBAction) gnuDateButtonClickHandler:(id)sender {
    //return if already selected
    if (self.gnuDateButton.isSelected == TRUE) return;
    
    [self toggleButtonSelections];
    
    //select the new date view controller/tab
    if (tabBarVC) [tabBarVC setSelectedIndex:kNEW_DATE_VIEW_INDEX];
}

- (IBAction)settingsButtonClickHandler:(id)sender {
    DLog(@"1");
    KKSettingsViewController *modal = [self.storyboard instantiateViewControllerWithIdentifier:@"KKSettingsViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:modal];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) toggleButtonSelections {
    [self.timePeriodButton setSelected:timePeriodSelected];
    [self.gnuDateButton setSelected:gnuDateSelected];
    
    //toggle our selected values
    timePeriodSelected = !timePeriodSelected;
    gnuDateSelected = !gnuDateSelected;
}

#pragma mark -
#pragma mark Utility Methods
- (void) wrapperForLoggingAutoLayoutConstraints {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", [[UIWindow keyWindow] _autolayoutTrace]);
}

@end





