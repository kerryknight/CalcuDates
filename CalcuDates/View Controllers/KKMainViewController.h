//
//  KKFirstViewController.h
//  CalcuDates
//
//  Created by Kerry Knight on 10/30/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKitUI/EventKitUI.h>
#import "EventKitController.h"

@interface KKMainViewController : UIViewController <EKEventEditViewDelegate, EKCalendarChooserDelegate>{
    
}


//in contrast to what the Ray Wenderlich iOS tutorials say about being able to put these in the .m file, which is true, do that hides these from any unit tests, making them untestable. Therefore, I'm keeping them here in order to fully test UI
//IBOutlets
@property (weak, nonatomic) IBOutlet UIButton *timePeriodButton;
@property (weak, nonatomic) IBOutlet UIButton *gnuDateButton; //"gnu" to not conflict with reserved cocoa naming conventions
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

//IBActions
- (IBAction)timePeriodButtonClickHandler:(id)sender;
- (IBAction)gnuDateButtonClickHandler:(id)sender;
- (IBAction)settingsButtonClickHandler:(id)sender;

- (void)toggleButtonSelections;

@end
