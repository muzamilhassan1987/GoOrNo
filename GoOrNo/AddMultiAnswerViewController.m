//
//  AddMultiAnswerViewController.m
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "AddMultiAnswerViewController.h"

@implementation AddMultiAnswerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.post.Type = PostTypeMake(PostTypeMultiAnswer);
  [self setNavigationBackgroundColor:[UIColor greenColor] titleColor:[UIColor whiteColor]];
  self.title = @"Multi Answer";
}

@end
