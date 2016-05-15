//
//  FeedViewGoOrNo.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 17/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "FeedViewGoOrNo.h"

@implementation FeedViewGoOrNo

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
  self.noLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-100, 20, 200, 60)];
  _noLabel.text = @"NO";
  _noLabel.font = [UIFont systemFontOfSize:32.0];
  _noLabel.textAlignment = NSTextAlignmentRight;
  _noLabel.backgroundColor = [UIColor clearColor];
  _noLabel.textColor = [UIColor redColor];
  _noLabel.alpha = 0.0f;
  [self addSubview:_noLabel];
  
  self.yesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 90, 60)];
  _yesLabel.text = @"GO";
  _yesLabel.font = [UIFont systemFontOfSize:32.0];
  _yesLabel.textAlignment = NSTextAlignmentLeft;
  _yesLabel.backgroundColor = [UIColor clearColor];
  _yesLabel.textColor = [UIColor greenColor];
  _yesLabel.alpha = 0.0f;
  [self addSubview:_yesLabel];
  [self bringSubviewToFront:self.yesLabel];
  [self bringSubviewToFront:self.noLabel];
}

- (IBAction)btnImageTapped:(UIButton *)sender {
  if (_delegate && [_delegate respondsToSelector:@selector(feedViewClickedImage:)]) {
    [_delegate feedViewClickedImage:self];
  }
}
@end
