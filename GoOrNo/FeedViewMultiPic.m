//
//  FeedViewMultiPic.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 16/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "FeedViewMultiPic.h"

@implementation FeedViewMultiPic

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
  [super awakeFromNib];
  self.yesLabel.text = @"That's it";
  self.noLabel.text = @"That's it";
}

@end
