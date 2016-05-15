//
//  SettingsViewController.m
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "SettingsViewController.h"
#import "AboutUsViewController.h"
#import "EditProfileViewController.h"
#import "ApplicationSettingsViewController.h"
#import "SettingModel.h"
#import "SettingCell.h"


@interface SettingsViewController ()
{
    IBOutlet UITableView *tableViewOptions;
    
    NSMutableArray *optionsArray;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Settings";
    [self setNavigationBackgroundColor:nil titleColor:[UIColor blackColor]];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self setBackButtonWithColor:[UIColor blackColor]];
    
    SettingModel *optionModel1 = [[SettingModel alloc] initWithStoryboardID:NSStringFromClass([EditProfileViewController class]) title:@"Edit Profile" imageName:@"settings-edit"];
    SettingModel *optionModel2 = [[SettingModel alloc] initWithStoryboardID:NSStringFromClass([ApplicationSettingsViewController class]) title:@"Application Settings" imageName:@"settings-application"];
    SettingModel *optionModel3 = [[SettingModel alloc] initWithStoryboardID:NSStringFromClass([AboutUsViewController class]) title:@"About Us" imageName:@"settings-about-us"];
    
    optionsArray = [NSMutableArray arrayWithObjects:optionModel1,optionModel2,optionModel3, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDatasource and Delegates - 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return optionsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = NSStringFromClass([SettingCell class]);
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)configureCell:(SettingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    SettingModel *optionModel = [optionsArray objectAtIndex:indexPath.row];
    
    [cell.lblTitle setText:optionModel.settingTitle];
    [cell.imgIcon setImage:[UIImage imageNamed:optionModel.settingIconImage]];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && [ApplicationData sharedInstance].currentUser.UserType.integerValue == UserTypeAnonymous) {
        
        [RMUniversalAlert showAlertInViewController:self
                                          withTitle:@"Info"
                                            message:@"Only registered user can edit their profiles"
                                  cancelButtonTitle:@"Ok"
                             destructiveButtonTitle:nil
                                  otherButtonTitles:nil
                                           tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex) {
                                               
                                               
                                           }];
        return;
    }
    
    SettingModel *optionModel = [optionsArray objectAtIndex:indexPath.row];
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:optionModel.settingStoryboarID];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
