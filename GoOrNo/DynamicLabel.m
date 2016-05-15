//
//  DynamicLabel.m
//  GoOrNo
//
//  Created by O16 Labs on 13/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "DynamicLabel.h"

@implementation DynamicLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    // If this is a multiline label, need to make sure
    // preferredMaxLayoutWidth always matches the frame width
    // (i.e. orientation change can mess this up)
    
    if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self setNeedsUpdateConstraints];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
    [super layoutSubviews];
}
@end
