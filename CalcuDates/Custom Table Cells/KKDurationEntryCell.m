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
        
        [RACObserve(self.daysToAdd, text) subscribeNext:^(NSString *text) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zeroCalculatedEndDate" object:nil];
        }];
        [RACObserve(self.weeksToAdd, text) subscribeNext:^(NSString *text) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zeroCalculatedEndDate" object:nil];
        }];
        [RACObserve(self.monthsToAdd, text) subscribeNext:^(NSString *text) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zeroCalculatedEndDate" object:nil];
        }];
        [RACObserve(self.yearsToAdd, text) subscribeNext:^(NSString *text) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"zeroCalculatedEndDate" object:nil];
        }];
    }
    
    [self setDurationFieldDelegates];
    [self clearDurationFields];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTextFieldOutlines) name:@"unhighlightDurationFields" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearDurationFields) name:@"clearDurationFields" object:nil];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addOutlineToTextField:(UITextField*)textField {
    textField.layer.borderColor = DRK_BLUE.CGColor;
    textField.layer.borderWidth = 1.0;
    textField.layer.cornerRadius = 0.0f;
}

- (void)removeTextFieldOutlines {
    NSArray *subviews = [self.contentView subviews];
    [subviews enumerateObjectsUsingBlock:^(UIView *aview, NSUInteger idx, BOOL *stop) {
        //first level
        NSArray *childSubviews = [aview subviews];
        [childSubviews enumerateObjectsUsingBlock:^(UIView *childview, NSUInteger idx, BOOL *stop) {
            //second level
            if ([childview isKindOfClass: [UITextField class]]) {
                UITextField *textField = (UITextField *)childview;
                textField.layer.borderWidth = 0.0;
            }
        }];
    }];
}

- (void)clearDurationFields {
    self.daysToAdd.text = @"";
    self.weeksToAdd.text = @"";
    self.monthsToAdd.text = @"";
    self.yearsToAdd.text = @"";
}

- (void)setDurationFieldDelegates {
    self.daysToAdd.delegate = self;
    self.weeksToAdd.delegate = self;
    self.monthsToAdd.delegate = self;
    self.yearsToAdd.delegate = self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self removeTextFieldOutlines];
    [self addOutlineToTextField:(UITextField*)textField];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissAnyKeyboard];
    [super touchesBegan:touches withEvent:event];
}

- (void) dismissAnyKeyboard {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissAnyKeyboard" object:nil];
    
    NSArray *subviews = [self.contentView subviews];
    [subviews enumerateObjectsUsingBlock:^(UIView *aview, NSUInteger idx, BOOL *stop) {
        //first level
        NSArray *childSubviews = [aview subviews];
        [childSubviews enumerateObjectsUsingBlock:^(UIView *childview, NSUInteger idx, BOOL *stop) {
            //second level
            if ([childview isKindOfClass: [UITextField class]]) {
                [self removeTextFieldOutlines];
            }
        }];
    }];
}


@end
