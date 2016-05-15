//
//  UIViewController+GoOrNoAdditions.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 25/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GoOrNoAdditions)

//@property (nonatomic, strong) METransitions *transitions;

- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;

- (void)setBackButton;
- (void) addFeedsButon;
- (void)addSaveButtonInNavigationBar;
- (void)setMenuButtonWithColor:(UIColor *)tintColor;
- (void)setBackButtonWithColor:(UIColor *)tintColor;
- (void)setOtherProfileOptionsBarButtonWithColor:(UIColor *)tintColor;

- (void)showLoginPopoverWithDelegate:(id)delegate completion:(MZFormSheetPresentationCompletionHandler)completionHandler;
- (void)showCreatePostOptionsWithDelegate:(id)delegate
                               completion:(MZFormSheetPresentationCompletionHandler)completion;
- (void)setNavigationBackgroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor;

@end
