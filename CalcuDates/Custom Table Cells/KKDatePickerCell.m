//
//  KKDatePickerCell.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KKDatePickerCell.h"

@implementation KKDatePickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //get our custom cell's nib file from app bundle
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KKDatePickerCell" owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[KKDatePickerCell class]])
                self = (KKDatePickerCell *)oneObject;
        
        [self createInsetShadow];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createInsetShadow {
    //create top and bottom gradients to display date picker view
    UIView *topGradientView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x,
                                                                    self.contentView.frame.origin.y,
                                                                    self.contentView.frame.size.width,
                                                                    5)];
    CAGradientLayer *topGradient = [CAGradientLayer layer];
    topGradient.frame = topGradientView.bounds;
    topGradient.colors = @[(id)[[UIColor colorWithRed:63.0f/255.0f green:63.0f/255.0f blue:64.0f/255.0f alpha:0.5f] CGColor],
                           (id)[[UIColor clearColor] CGColor]]; //clear and gray
    [topGradientView.layer insertSublayer:topGradient atIndex:0];
    [self.contentView addSubview:topGradientView];
    
    //bottom gradient
    UIView *bottomGradientView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.origin.x,
                                                                       self.contentView.frame.origin.y + self.contentView.frame.size.height - 5,
                                                                       self.contentView.frame.size.width,
                                                                       5)];
    CAGradientLayer *bottomGradient = [CAGradientLayer layer];
    bottomGradient.frame = bottomGradientView.bounds;
    bottomGradient.colors = @[(id)[[UIColor clearColor] CGColor],
                              (id)[[UIColor colorWithRed:63.0f/255.0f green:63.0f/255.0f blue:64.0f/255.0f alpha:0.55f] CGColor]]; //clear and gray
    [bottomGradientView.layer insertSublayer:bottomGradient atIndex:0];
    [self.contentView addSubview:bottomGradientView];
}

@end
