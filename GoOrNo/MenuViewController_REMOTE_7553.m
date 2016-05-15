//
//  MenuViewController.m
//  GoOrNo
//
//  Created by O16 Labs on 25/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.delegate = self;
  
  self.menuItems = @[@"StatisticsOrRuling", @"New", @"StatisticsOrRuling", @"NewsFeedViewController", @"NotificationsController"];
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.row < 5) {
    [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:self.menuItems[indexPath.row]] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
  }
}

@end
