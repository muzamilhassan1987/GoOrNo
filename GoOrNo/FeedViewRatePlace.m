//
//  FeedViewRatePlace.m
//  GoOrNo
//
//  Created by O16 Labs on 20/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "FeedViewRatePlace.h"

@implementation FeedViewRatePlace

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
  [super awakeFromNib];
  self.yesLabel.text = @"Go";
  self.noLabel.text = @"No";
}

@end
