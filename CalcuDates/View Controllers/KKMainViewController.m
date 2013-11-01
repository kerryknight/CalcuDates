//
//  KKMainViewController.m
//  CalcuDates
//
//  Created by Kerry Knight on 10/30/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKMainViewController.h"
#import "KKTimePeriodViewController.h"
#import "KKNewDateViewController.h"

#pragma mark -
#pragma mark @categories
//category to enable more easily tracing ambiguous layout issues
@interface UIWindow (AutoLayoutDebug)
+ (UIWindow *) keyWindow;
- (NSString *) _autolayoutTrace;
@end

#pragma mark -
#pragma mark @interface

@interface KKMainViewController ()

//instance vars
@property (nonatomic, assign) BOOL timePeriodSelected;
@property (nonatomic, assign) BOOL gnuDateSelected;

//IBOutlets
@property (weak, nonatomic) IBOutlet UIButton *timePeriodButton;
@property (weak, nonatomic) IBOutlet UIButton *gnuDateButton; //"gnu" to not conflict with reserved cocoa naming conventions

//IBActions
- (IBAction)timePeriodButtonClickHander:(id)sender;
- (IBAction)gnuDateButtonClickHandler:(id)sender;

@end

#pragma mark -
#pragma mark @implementation
@implementation KKMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //setup and initialize our buttons
    [self initializeButtons];
    
    //call this to trace autolayout issues
//    [self performSelector:@selector(wrapperForLoggingAutoLayoutConstraints) withObject:nil afterDelay:1.0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _timePeriodSelected = TRUE;
    _gnuDateSelected = FALSE;
    [self toggleButtonSelections];
}

- (IBAction) timePeriodButtonClickHander:(id)sender {
//    NSLog(@"%s", __FUNCTION__);
    //return if already selected
    if (self.timePeriodButton.isSelected == TRUE) return;
    
    [self toggleButtonSelections];
}

- (IBAction) gnuDateButtonClickHandler:(id)sender {
//    NSLog(@"%s", __FUNCTION__);
    //return if already selected
    if (self.gnuDateButton.isSelected == TRUE) return;
    
    [self toggleButtonSelections];
}

- (void) toggleButtonSelections {
    
    [self.timePeriodButton setSelected:_timePeriodSelected];
    [self.gnuDateButton setSelected:_gnuDateSelected];
    
    //toggle our selected values
    _timePeriodSelected = !_timePeriodSelected;
    _gnuDateSelected = !_gnuDateSelected;
}

#pragma mark -
#pragma mark Utility Methods
- (void) wrapperForLoggingAutoLayoutConstraints {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", [[UIWindow keyWindow] _autolayoutTrace]);
}



@end





