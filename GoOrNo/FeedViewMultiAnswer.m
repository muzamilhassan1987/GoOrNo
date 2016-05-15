//
//  FeedViewMultiAnswer.m
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "FeedViewMultiAnswer.h"

@implementation FeedViewMultiAnswer

- (void)awakeFromNib {
  [super awakeFromNib];
  self.yesLabel.text = @"That's it";
  self.noLabel.text = @"That's it";
}

@end
