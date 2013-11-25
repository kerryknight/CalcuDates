//
//  KKDurationEntryCell.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKDurationEntryCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation KKDurationEntryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //get our custom cell's nib file from app bundle
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"KKDurationEntryCell" owner:self options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[KKDurationEntryCell class]])
                self = (KKDurationEntryCell *)oneObject;
        
        
        [self.date addObserver:self forKeyPath:@"value" options:0 context:nil];
        
        [RACObserve(self.date, text) subscribeNext:^(NSString *text) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zeroDateDifferences" object:nil];
        }];
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
    [self.date removeObserver:self forKeyPath:@"value"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    DLog(@"3");
//    if ([keyPath isEqualToString:@"value"]) {
//        DLog(@"4");
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"KKDateFieldChanged" object:self];
//    }
//}

@end
