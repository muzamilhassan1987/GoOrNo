//
//  SlidingParentViewController.m
//  GoOrNo
//
//  Created by O16 Labs on 25/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "SlidingParentViewController.h"

@implementation SlidingParentViewController

- (void)awakeFromNib
{
  self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
  self.contentViewShadowColor = [UIColor blackColor];
  self.contentViewShadowOffset = CGSizeMake(0, 0);
  self.contentViewShadowOpacity = 0.6;
  self.contentViewShadowRadius = 12;
  self.contentViewShadowEnabled = YES;
  
  self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsFeedViewController"];
  self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
  self.backgroundImage = [UIImage imageNamed:@"side-bg"];
  self.delegate = self;
  
  //  [self.sideMenuViewController presentLeftMenuViewController];
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
//  NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
//  NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
//  NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
//  NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}


@end
