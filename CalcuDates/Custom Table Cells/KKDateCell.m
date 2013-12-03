//
//  KKDateCell.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKDateCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation KKDateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //get our custom cell's nib file from app bundle
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KKDateCell" owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[KKDateCell class]])
                self = (KKDateCell *)oneObject;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTextFieldOutline) name:@"unhighlightDateField" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearDateField) name:@"clearDateFields" object:nil];
    
    self.date.text = @"";
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addTextFieldOutline {
    self.date.layer.borderColor = DRK_BLUE.CGColor;
    self.date.layer.borderWidth = 1.0;
    self.date.layer.cornerRadius = 0.0f;
}

- (void)removeTextFieldOutline {
    self.date.layer.borderWidth = 0.0;
}

- (void)clearDateField {
    self.date.text = @"";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
