//
//  KKSettingsViewController.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/11/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKSettingsViewController.h"
#import "SVProgressHUD.h"
#import <RevMobAds/RevMobAds.h>

#define kReactiveCocoaTag           222
#define kReactiveCocoaURL           @"https://github.com/ReactiveCocoa/ReactiveCocoa"
#define kSVProgressHUDTag           333
#define kSVProgressHUDURL           @"https://github.com/samvermette/SVProgressHUD"
#define kVCTransitionsLibraryTag    444
#define kVCTransitionsLibraryURL    @"https://github.com/ColinEberhardt/VCTransitionsLibrary"
#define kDAKeyboardControlTag       555
#define kDAKeyboardControlURL       @"https://github.com/danielamitay/DAKeyboardControl"

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
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStylePlain
                                   target:self action:@selector(dismiss:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        //done
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToURL:(id)sender {
    UIButton *button = (UIButton*)sender;
    if (button.tag == kReactiveCocoaTag) {
        [self loadURL:kReactiveCocoaURL];
    } else if (button.tag == kSVProgressHUDTag) {
        [self loadURL:kSVProgressHUDURL];
    } else if (button.tag == kVCTransitionsLibraryTag) {
        [self loadURL:kVCTransitionsLibraryURL];
    } else if (button.tag == kDAKeyboardControlTag) {
        [self loadURL:kDAKeyboardControlURL];
    } else {
        //do nothing
    }
}

- (void)loadAdLink {
    RevMobAdLink *link = [[RevMobAds session] adLink];
    [link loadWithSuccessHandler:^(RevMobAdLink *link) {
        [link openLink];
        [SVProgressHUD dismiss];
    } andLoadFailHandler:^(RevMobAdLink *link, NSError *error) {
        NSLog(@"RevMob link load error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"Error loading app store."];
    }];
}

- (IBAction)freeAppsButtonClickHandler:(id)sender {
    [SVProgressHUD showWithStatus:@"Loading..."];
    [self loadAdLink];
}

- (void)loadURL:(NSString*)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
