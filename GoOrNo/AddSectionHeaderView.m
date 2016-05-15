//
//  AddHeader.m
//  GoOrNo
//
//  Created by O16 Labs on 25/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "AddSectionHeaderView.h"

@implementation AddSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btnSectionTapped:(UIButton *)sender {
  if (_delegate && [_delegate respondsToSelector:@selector(sectionTapped:)]) {
    [self.delegate sectionTapped:self.section];
  }
}
@end
