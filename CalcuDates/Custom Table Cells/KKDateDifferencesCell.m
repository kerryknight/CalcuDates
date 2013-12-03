//
//  KKDateDifferencesCell.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKDateDifferencesCell.h"

@interface KKDateDifferencesCell (){
}
@property (nonatomic, assign) BOOL isZeroed;
@property (nonatomic, assign) BOOL addEventButtonIsShowing;
- (void)resetAllCounterLabels;
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
    
    self.isZeroed = YES;
    self.addEventButtonIsShowing = YES;
    [self configureCountingLabels];
    
    //set all fields to 0
    [self formatCellForZero];
    
    //hide out button to add event to calendar
    [self hideAddEventButton];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberShouldZero:) name:@"zeroDateDifferences" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numbersShouldCalculate:) name:@"calculateDateDifferences" object:nil];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCountingLabels {
    self.daysDifferenceField.format = @"%.0f%";
    self.weeksDifferenceField.format = @"%.1f%";
    self.monthsDifferenceField.format = @"%.2f%";
    self.yearsDifferenceField.format = @"%.2f%";
    
    self.daysDifferenceField.method = UILabelCountingMethodEaseOut;
    self.weeksDifferenceField.method = UILabelCountingMethodEaseOut;
    self.monthsDifferenceField.method = UILabelCountingMethodEaseOut;
    self.yearsDifferenceField.method = UILabelCountingMethodEaseOut;
    
    self.daysDifferenceField.completionBlock = ^{
        //do stuff when animation completes
    };
}

- (void)numberShouldZero:(NSNotification*)notification {
    if (self.isZeroed) return;
    [self resetAllCounterLabels];
    self.isZeroed = YES;
    
    [self formatCellForZero];
    
    [self hideAddEventButton];
}

- (void)numbersShouldCalculate:(NSNotification*)notification {
    self.calculationsDictionary = [NSDictionary dictionaryWithDictionary:[notification userInfo]];
    [self configureCountingLabels];
    [self calculateNumbers:self.calculationsDictionary];
    self.isZeroed = NO;
    
    [self formatCellForCalculations];
    
    [self showAddEventButton];
}

- (void)calculateNumbers:(NSDictionary*)calculations {
    NSParameterAssert(calculations != nil);
    [self.daysDifferenceField countFrom:0 to:[calculations[@"days"] floatValue]];
    [self.weeksDifferenceField countFrom:0 to:[calculations[@"weeks"] floatValue]];
    [self.monthsDifferenceField countFrom:0 to:[calculations[@"months"] floatValue]];
    [self.yearsDifferenceField countFrom:0 to:[calculations[@"years"] floatValue]];
}

- (void)resetAllCounterLabels {
    self.daysDifferenceField.text = @"--";
    self.weeksDifferenceField.text = @"--";
    self.monthsDifferenceField.text = @"--";
    self.yearsDifferenceField.text = @"--";
}

- (void)formatCellForCalculations {
    self.daysDifferenceField.textColor = DRK_BLUE;
    self.weeksDifferenceField.textColor = DRK_BLUE;
    self.monthsDifferenceField.textColor = DRK_BLUE;
    self.yearsDifferenceField.textColor = DRK_BLUE;
}

- (void)formatCellForZero {
    self.daysDifferenceField.textColor = LT_BLUE;
    self.weeksDifferenceField.textColor = LT_BLUE;
    self.monthsDifferenceField.textColor = LT_BLUE;
    self.yearsDifferenceField.textColor = LT_BLUE;
}

- (void)hideAddEventButton {
	if (!self.addEventButtonIsShowing) return;
	[self.addEventButton setHidden:YES];
    self.addEventButtonIsShowing = NO;
}

- (void)showAddEventButton {
    if (self.addEventButtonIsShowing) return;
    [self.addEventButton setHidden:NO];
    self.addEventButtonIsShowing = YES;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
