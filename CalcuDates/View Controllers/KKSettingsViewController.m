//
//  KKSettingsViewController.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/11/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKSettingsViewController.h"
#import "UINavigationController+MHDismissModalView.h"

@interface KKSettingsViewController ()
@end

@implementation KKSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.title = @"Settings, etc.";
    self.title = @"Acknowledgements";
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.versionLabel.text = [NSString stringWithFormat:@"Version: %@", version];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
