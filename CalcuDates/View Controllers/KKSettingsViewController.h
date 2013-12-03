//
//  KKSettingsViewController.h
//  CalcuDates
//
//  Created by Kerry Knight on 11/11/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *freeAppsButton;
- (IBAction)goToURL:(id)sender;
- (IBAction)freeAppsButtonClickHandler:(id)sender;
@end
