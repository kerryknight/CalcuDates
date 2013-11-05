//
//  KKDateDifferencesCell.h
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKDateDifferencesCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UITextField *daysDifferenceField;
@property (weak, nonatomic) IBOutlet UITextField *weeksDifferenceField;
@property (weak, nonatomic) IBOutlet UITextField *monthsDifferenceField;
@property (weak, nonatomic) IBOutlet UITextField *yearsDifferenceField;
@property (weak, nonatomic) IBOutlet UIButton *addEventButton;

@end
