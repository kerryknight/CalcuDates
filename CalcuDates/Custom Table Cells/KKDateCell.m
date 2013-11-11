//
//  KKDateCell.m
//  CalcuDates
//
//  Created by Kerry Knight on 11/4/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#import "KKDateCell.h"

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
        
        
        [self.date addObserver:self forKeyPath:@"value" options:0 context:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [self.date removeObserver:self forKeyPath:@"value"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    DLog(@"3");
    if ([keyPath isEqualToString:@"value"]) {
        DLog(@"4");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KKDateFieldChanged" object:self];
    }
}

@end
