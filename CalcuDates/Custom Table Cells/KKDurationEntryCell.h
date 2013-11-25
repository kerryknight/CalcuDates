//
//  KKDurationEntryCell.h
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKSlightIndentTextField.h"

@interface KKDurationEntryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet KKSlightIndentTextField *date;

- (void)addTextFieldOutline;
- (void)removeTextFieldOutline;
@end
