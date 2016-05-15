//
//  AddActionsViewController.m
//  GoOrNo
//
//  Created by O16 Labs on 28/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "AddActionsViewController.h"
#import "AddGoorNoViewController.h"
#import "AddMultiPicViewController.h"
#import "AddMultiAnswerViewController.h"

@implementation AddActionsViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setMenuButtonWithColor:[UIColor blackColor]];
  [self setNavigationBackgroundColor:[UIColor whiteColor] titleColor:[UIColor blackColor]];
  self.title = @"Go or No";
}

- (IBAction)btnAddGoOrNo:(UIButton *)sender {
    
    self.formSheetController.didDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
        
    };
    
    [self dismissMe];
    [self.delegate addActionControllerDidDismissWithOption:AddGoOrNoAction];
}

- (IBAction)btnAddMultiPic:(UIButton *)sender {
    
  
    [self dismissMe];
    [self.delegate addActionControllerDidDismissWithOption:AddMultiPicAction];
}
- (IBAction)btnAddMultiAnswer:(id)sender {
    
  
    [self dismissMe];
    [self.delegate addActionControllerDidDismissWithOption:AddMultiAnswerAction];
}
- (IBAction)btnAddRateAPlace:(id)sender {
    
    
    [self dismissMe];
    [self.delegate addActionControllerDidDismissWithOption:AddRateAPlaceAction];
}

-(IBAction)cancelButtonPressed:(id)sender {
    
    [self dismissMe];
}


-(void) dismissMe {
    
    [self.formSheetController dismissAnimated:YES completionHandler:nil];
}

@end
