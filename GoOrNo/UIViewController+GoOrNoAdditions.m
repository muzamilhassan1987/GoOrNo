//
//  UIViewController+GoOrNoAdditions.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 25/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "UIViewController+GoOrNoAdditions.h"
#import <objc/runtime.h>

#import "LoginViewController.h"
#import "ProfileOptionsViewController.h"
#import "AddActionsViewController.h"

//static void * TransitionsPropertyKey = &TransitionsPropertyKey;

@implementation UIViewController (GoOrNoAdditions)

//- (METransitions *)transitions {
//  return objc_getAssociatedObject(self, TransitionsPropertyKey);
//}
//
//- (void)setTransitions:(METransitions *)transitions {
//  objc_setAssociatedObject(self, TransitionsPropertyKey, transitions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

#pragma mark IBActions


- (IBAction)backButtonTapped:(id)sender {
  [SVProgressHUD dismiss];
  [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)feedsButtonPressed:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)profileOptionsButtonTapped:(UIBarButtonItem *)sender {
    ProfileOptionsViewController *profileOptionsViewObj = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileOptionsViewController"];
    [self.navigationController pushViewController:profileOptionsViewObj animated:YES];
}
#pragma mark Methods
- (void)setNavigationBackgroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor {
//  [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//  [self.navigationController.toolbar setBarTintColor:bgColor];
    if(titleColor)
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: titleColor};
    else
        self.navigationController.navigationBar.titleTextAttributes = nil;
}
- (void)setBackButton {
    [self setBackButtonWithColor:[UIColor whiteColor]];
}
- (void)setBackButtonWithColor:(UIColor *)tintColor {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTapped:)];
    [button setTintColor:tintColor];
    [self.navigationItem setLeftBarButtonItem:button];
}

- (void)addSaveButtonInNavigationBar {
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-save"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(saveButtonPressed:)];

    [self.navigationItem setRightBarButtonItem:button];
}

- (void)setMenuButtonWithColor:(UIColor *)tintColor {
    
  UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_settings"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonTapped:)];
//  [button setTintColor:tintColor];
  [self.navigationItem setLeftBarButtonItem:button];
}

- (void) addFeedsButon {
    
    self.navigationItem.leftBarButtonItem = nil;
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navigationBar"] style:UIBarButtonItemStylePlain target:self action:@selector(feedsButtonPressed:)];
    //  [button setTintColor:tintColor];
    [self.navigationItem setLeftBarButtonItem:button];
}

- (void)setOtherProfileOptionsBarButtonWithColor:(UIColor *)tintColor {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-back"] style:UIBarButtonItemStylePlain target:self action:@selector(profileOptionsButtonTapped:)];
//    [button setTintColor:tintColor];
    [self.navigationItem setRightBarButtonItem:button];
}
- (void)showLoginPopoverWithDelegate:(id)delegate
                          completion:(MZFormSheetPresentationCompletionHandler)completion {
  LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
  vc.delegate = delegate;
  MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
  formSheet.shouldDismissOnBackgroundViewTap = NO;
  formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
  formSheet.presentedFormSheetSize = CGSizeMake(302.0, 282.0);
  formSheet.view.backgroundColor = [UIColor clearColor];
  [[MZFormSheetController sharedBackgroundWindow] setBackgroundBlurEffect:YES];
  [[MZFormSheetController sharedBackgroundWindow] setBlurRadius:5.0];
  [[MZFormSheetController sharedBackgroundWindow] setBackgroundColor:[UIColor clearColor]];
  [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    if (completion) {
      completion(formSheetController);
    }
  }];
}

- (void)showCreatePostOptionsWithDelegate:(id)delegate
                               completion:(MZFormSheetPresentationCompletionHandler)completion {
    
    AddActionsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"N"];
    vc.delegate = delegate;
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.shouldDismissOnBackgroundViewTap = NO;
    formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
    formSheet.presentedFormSheetSize = CGSizeMake(190.0, 250.0);
    formSheet.view.backgroundColor = [UIColor clearColor];
    [[MZFormSheetController sharedBackgroundWindow] setBackgroundBlurEffect:YES];
    [[MZFormSheetController sharedBackgroundWindow] setBlurRadius:5.0];
    [[MZFormSheetController sharedBackgroundWindow] setBackgroundColor:[UIColor clearColor]];
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        if (completion) {
            completion(formSheetController);
        }
    }];
}

@end
