//
//  KKDateDifferencesCell.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKDateDifferencesCell.h"

@interface KKDateDifferencesCell (){}

@end

@implementation KKDateDifferencesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //get our custom cell's nib file from app bundle
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KKDateDifferencesCell" owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[KKDateDifferencesCell class]])
                self = (KKDateDifferencesCell *)oneObject;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
