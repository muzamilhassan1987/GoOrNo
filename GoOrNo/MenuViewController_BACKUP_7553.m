//
//  MenuViewController.m
//  GoOrNo
//
//  Created by O16 Labs on 25/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "MenuViewController.h"
#import "StatisticsRulingViewController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

#define NAV_TO_STATS  @"navToStats"
#define NAV_TO_RULING @"navToRuling"

@implementation MenuViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.delegate = self;
<<<<<<< HEAD
    if ([[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"SAVED_DATA"]) [self getUser];
  self.menuItems = @[@"StatisticsOrRuling", @"New", @"StatisticsOrRuling", @"NewsFeedViewController"];
=======
  
  self.menuItems = @[@"StatisticsOrRuling", @"New", @"StatisticsOrRuling", @"NewsFeedViewController", @"NotificationsController"];
>>>>>>> origin/asif
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
<<<<<<< HEAD
  if (indexPath.row < 4) {
      [self getCustomVC:(indexPath.row == 0)?NAV_TO_STATS:@"" vcIndexPath:indexPath];
      
      [self.sideMenuViewController hideMenuViewController];
=======
  if (indexPath.row < 5) {
    [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:self.menuItems[indexPath.row]] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
>>>>>>> origin/asif
  }
}

-(void)getUser{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [ApplicationData sharedInstance].currentUser = [defaults rm_customObjectForKey:@"SAVED_DATA"];
}

-(void)getCustomVC:(NSString*)VCType vcIndexPath:(NSIndexPath*)indexPath{
    
    UIViewController *VC;
    VC = [self.storyboard instantiateViewControllerWithIdentifier:self.menuItems[indexPath.row]];
    
    if ([VCType isEqualToString:NAV_TO_STATS]) {
        UINavigationController *navView = (UINavigationController*) VC;
        StatisticsRulingViewController *SVC;
        NSMutableArray *VCs = [[NSMutableArray alloc] initWithArray:navView.viewControllers];
        NSUInteger index = 0;
        
        for (UIViewController *cVC in navView.viewControllers) {
            if ([cVC isKindOfClass:[StatisticsRulingViewController class]]) {
                index  = [navView.viewControllers indexOfObject:cVC];
                SVC = (StatisticsRulingViewController*) cVC;
                SVC.isStat = YES;
            }
        }
        [VCs replaceObjectAtIndex:index withObject:SVC];
        [navView setViewControllers:VCs];
        VC = navView;
    }
    
    [self.sideMenuViewController setContentViewController:VC animated:YES];
}

@end
