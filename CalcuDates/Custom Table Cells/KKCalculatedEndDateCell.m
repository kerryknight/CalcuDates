//
//  KKCalculatedEndDateCell.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKCalculatedEndDateCell.h"

@interface KKCalculatedEndDateCell (){
}
@property (nonatomic, assign) BOOL isZeroed;
@property (nonatomic, assign) BOOL addEventButtonIsShowing;
- (void)resetAllCounterLabels;
@end

@implementation KKCalculatedEndDateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //get our custom cell's nib file from app bundle
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KKCalculatedEndDateCell" owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[KKCalculatedEndDateCell class]])
                self = (KKCalculatedEndDateCell *)oneObject;
    }
    
    self.isZeroed = YES;
    self.addEventButtonIsShowing = YES;
    
    //set all fields to 0
    [self formatCellForZero];
    
    //hide out button to add event to calendar
    [self hideAddEventButton];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberShouldZero:) name:@"zeroDateDifferences" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endDateShouldCalculate:) name:@"calculateEndDate" object:nil];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)numberShouldZero:(NSNotification*)notification {
    if (self.isZeroed) return;
    [self resetAllCounterLabels];
    self.isZeroed = YES;
    
    [self formatCellForZero];
    
    [self hideAddEventButton];
}

- (void)endDateShouldCalculate:(NSNotification*)notification {
    self.calculationsDictionary = [NSDictionary dictionaryWithDictionary:[notification userInfo]];
    [self calculateEndDate:self.calculationsDictionary];
    self.isZeroed = NO;
    
    [self formatCellForCalculations];
    
    [self showAddEventButton];
}

- (void)calculateEndDate:(NSDictionary*)calculations {
    NSParameterAssert(calculations != nil);
    self.calculatedEndDateField.text = calculations[@"endDate"];
}

- (void)resetAllCounterLabels {
    self.calculatedEndDateField.text = @"--";
}

- (void)formatCellForCalculations {
    self.calculatedEndDateField.textColor = DRK_BLUE;
}

- (void)formatCellForZero {
    self.calculatedEndDateField.textColor = LT_BLUE;
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
