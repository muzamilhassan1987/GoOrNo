//
//  CustomQuestionFooterView.m
//  GoOrNo
//
//  Created by O16 Labs on 27/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "CustomQuestionFooterView.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>

@implementation CustomQuestionFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
  [super awakeFromNib];
  self.txtView.placeholderColor = [UIColor lightGrayColor];
  self.txtView.delegate = self;
}

- (IBAction)btnSaveTapped:(UIButton *)sender {
  if (self.txtView.text.length != 0) {
    if (_delegate && [_delegate respondsToSelector:@selector(footerView:customQuestionSaved:)]) {
      [self.delegate footerView:self customQuestionSaved:self.txtView.text];
    }
    [self.txtView resignFirstResponder];
  }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
  if([text isEqualToString:@""] && range.length==1){
    return YES;
  } else if(textView.text.length - range.length + text.length > 160){
    return NO;
  }
  return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
  NSUInteger length = textView.text.length;
  NSInteger remaining = 160-length;
  self.lblCharacterCount.text = [NSString stringWithFormat:@"%lu/160",(unsigned long)remaining];
}
@end
