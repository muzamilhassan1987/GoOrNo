//
//  ProfileOptionsViewController.m
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ProfileOptionsViewController.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "StatisticsRulingViewController.h"

@interface ProfileOptionsViewController ()

@end

@implementation ProfileOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"GO Or NO";
    [self setNavigationBackgroundColor:nil titleColor:[UIColor blackColor]];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self setBackButton];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - IBActions
- (IBAction)settingsButtonTapped:(UIButton *)sender {
    SettingsViewController *settingsViewObj = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsViewObj animated:YES];
}

-(IBAction)profileButtonPressed:(id)sender {
    
    if ([[ApplicationData sharedInstance] currentUser] == nil) {
        
        [self showLoginPopoverWithDelegate:self completion:nil];
        return;
    }
    
    ProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self.navigationController pushViewController:profileView animated:YES];
}

-(IBAction)statisticsButtonPressed:(id)sender {
    
    StatisticsRulingViewController *statsView = [self.storyboard instantiateViewControllerWithIdentifier:@"StatisticsRulingViewController"];
    [self.navigationController pushViewController:statsView animated:YES];
}

-(IBAction)rulingButtonPressed:(id)sender {
    
    StatisticsRulingViewController *statsView = [self.storyboard instantiateViewControllerWithIdentifier:@"StatisticsRulingViewController"];
    [self.navigationController pushViewController:statsView animated:YES];
}
@end
