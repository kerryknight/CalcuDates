//
//  KKEndDateCell.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKEndDateCell.h"

@interface KKEndDateCell (){}

@property (weak, nonatomic) IBOutlet UITextField *endDateField;
@property (weak, nonatomic) IBOutlet UIButton *addEventButton;

@end

@implementation KKEndDateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //get our custom cell's nib file from app bundle
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
