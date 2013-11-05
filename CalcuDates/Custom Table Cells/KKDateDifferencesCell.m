//
//  KKDateDifferencesCell.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKDateDifferencesCell.h"

@interface KKDateDifferencesCell (){}

@property (weak, nonatomic) IBOutlet UITextField *daysDifferenceField;
@property (weak, nonatomic) IBOutlet UITextField *weeksDifferenceField;
@property (weak, nonatomic) IBOutlet UITextField *monthsDifferenceField;
@property (weak, nonatomic) IBOutlet UITextField *yearsDifferenceField;
@property (weak, nonatomic) IBOutlet UIButton *addEventButton;


@end

@implementation KKDateDifferencesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //update the look of the date field label
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
