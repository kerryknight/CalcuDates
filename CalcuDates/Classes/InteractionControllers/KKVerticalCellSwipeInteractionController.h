//
//  KKVerticalCellSwipeInteractionController.h
//  CalcuDates
//
//  Created by Kerry Knight on 05Nov2013
//
//  Adapted from code written by Colin Eberhardt on 22/09/2013.
//  https://github.com/ColinEberhardt/VCTransitionsLibrary/

#import <UIKit/UIKit.h>

/**
 An enumeration that describes the operation that an interaction controller should initiate.
 */
typedef NS_ENUM(NSInteger, KKInteractionOperation) {
    /**
     Indicates that the interaction controller should insert table rows
     */
    KKInteractionOperationShow,
    /**
     Indicates that the interaction controller should delete the opened table rows
     */
    KKInteractionOperationHide
};

/**
 A vertical swipe interaction controller for table view cells to allow the display and hiding of additional rows in table
 */
@interface KKVerticalCellSwipeInteractionController : UIPercentDrivenInteractiveTransition


/**
 This property indicates whether an interactive transition is in progress.
 */
@property (nonatomic, assign) BOOL interactionInProgress;

@end
