//
//  KKTabBarController.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKTabBarController.h"
#import "CEHorizontalSwipeInteractionController.h"
#import "CETurnAnimationController.h"
#import "Appirater.h"

@interface KKTabBarController () <UIViewControllerTransitioningDelegate, UITabBarControllerDelegate>

@end

@implementation KKTabBarController {
    CETurnAnimationController *_flipAnimationController;
    CEHorizontalSwipeInteractionController *_interactionController;
}

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //set our UITabBarControllerDelegate
    self.delegate = self;
    
    _flipAnimationController = [CETurnAnimationController new];
    _interactionController = [CEHorizontalSwipeInteractionController new];
    
    UIViewController *initialVC = self.viewControllers[0];
    
    // wire the interaction controller to the view controller
    [_interactionController wireToViewController:initialVC
                                    forOperation:CEInteractionOperationTab];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeSelectedTab {
    [self setSelectedIndex:!self.selectedIndex];
    
    //significant event
    [Appirater userDidSignificantEvent:YES];
}

#pragma mark -
#pragma mark Animations
- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
            animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                              toViewController:(UIViewController *)toVC {
    
    toVC.transitioningDelegate = self;
    
    // wire the interaction controller to the view controller
    [_interactionController wireToViewController:toVC
                                    forOperation:CEInteractionOperationTab];
    
    //set the direction of the animated flip based on which tab was clicked
    NSUInteger fromVCIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSUInteger toVCIndex = [tabBarController.viewControllers indexOfObject:toVC];
    
    _flipAnimationController.reverse = fromVCIndex < toVCIndex;
    return _flipAnimationController;
}

- (id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                      interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController {
    return _interactionController.interactionInProgress ? _interactionController : nil;
}

@end
