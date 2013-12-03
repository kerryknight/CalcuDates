//
//  KKSlightIndentTextField.m
//
//  Created by Kerry Knight on 7/20/12.
//  Copyright (c) 2012 Kerry Knight. All rights reserved.
//

#import "KKSlightIndentTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation KKSlightIndentTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

//these methods are so the text isn't smooshed against the left side of the textfield
- (CGRect)textRectForBounds:(CGRect)bounds {
    int margin = 5;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - (margin * 2), bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    int margin = 5;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - (margin * 2), bounds.size.height);
    return inset;
}

@end
