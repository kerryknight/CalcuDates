//
//  KKDateDifferencesCell.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKDateDifferencesCell.h"

typedef void (^KKDateDifferencesCellCompletionBlock)();

@interface KKDateDifferencesCell (){
    BOOL isZeroed;
}
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
    
    isZeroed = YES;
    [self configureCountingLabels];
    
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
    self.daysDifferenceField.format = @"%.2f%";
    self.weeksDifferenceField.format = @"%.2f%";
    self.monthsDifferenceField.format = @"%.2f%";
    self.yearsDifferenceField.format = @"%.2f%";
    
    self.daysDifferenceField.method = UILabelCountingMethodEaseOut;
    self.weeksDifferenceField.method = UILabelCountingMethodEaseOut;
    self.monthsDifferenceField.method = UILabelCountingMethodEaseOut;
    self.yearsDifferenceField.method = UILabelCountingMethodEaseOut;
    
    self.daysDifferenceField.completionBlock = ^{
        //do stuff
    };
}

- (void)numberShouldZero:(NSNotification*)notification {
    if (isZeroed) return;
    [self resetAllCounterLabels];
    isZeroed = YES;
}

- (void)numbersShouldCalculate:(NSNotification*)notification {
    self.calculationsDictionary = [NSDictionary dictionaryWithDictionary:[notification userInfo]];
    [self configureCountingLabels];
    [self calculateNumbers:self.calculationsDictionary];
    isZeroed = NO;
}

- (void)calculateNumbers:(NSDictionary*)calculations {
    [self.daysDifferenceField countFrom:0 to:[calculations[@"days"] floatValue]];
    [self.weeksDifferenceField countFrom:0 to:[calculations[@"weeks"] floatValue]];
    [self.monthsDifferenceField countFrom:0 to:[calculations[@"months"] floatValue]];
    [self.yearsDifferenceField countFrom:0 to:[calculations[@"years"] floatValue]];
}

- (void)resetAllCounterLabels {
    self.daysDifferenceField.text = @"0.00";
    self.weeksDifferenceField.text = @"0.00";
    self.monthsDifferenceField.text = @"0.00";
    self.yearsDifferenceField.text = @"0.00";
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
