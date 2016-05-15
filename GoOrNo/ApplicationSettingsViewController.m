//
//  ApplicationSettingsViewController.m
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ApplicationSettingsViewController.h"
#import "ApplicationSettingModel.h"
#import "ApplicationSettingBooleanCell.h"
#import "ApplicationSettingMultiLevelCell.h"
#import "MultiLevelSettingsViewController.h"

@interface ApplicationSettingsViewController () <MultiLevelSettingsViewControllerDelegate>
{
    IBOutlet UITableView *tableViewApplicationSetting;
    NSMutableArray *applicationSettingsArray;
    
    NSIndexPath *selectedIndexPath;
}
@end

@implementation ApplicationSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Application Settings";
    [self setNavigationBackgroundColor:nil titleColor:[UIColor blackColor]];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self setBackButtonWithColor:[UIColor blackColor]];
    
    ApplicationSettingModel *setting1 = [[ApplicationSettingModel alloc] initWithType:ApplicationSettingTypeBoolean placeHolder:@"Ruling Popup Notification" selectedSettingText:nil selectedSettingBoolean:NO settingOptions:nil];
    
    ApplicationSettingModel *setting2 = [[ApplicationSettingModel alloc] initWithType:ApplicationSettingTypeMutilevel placeHolder:@"Rating Popup" selectedSettingText:kSettingRatingPopUpOnFinal selectedSettingBoolean:NO settingOptions:[@[kSettingRatingPopUpOnFirst,kSettingRatingPopUpOnFinal,kSettingRatingPopUpOnEvery] mutableCopy]];
    
    ApplicationSettingModel *setting3 = [[ApplicationSettingModel alloc] initWithType:ApplicationSettingTypeMutilevel placeHolder:@"Delete Old Rating" selectedSettingText:kSettingDeleteRatingAfterOneMonth selectedSettingBoolean:NO settingOptions:[@[kSettingDeleteRatingAfterOneMonth,kSettingDeleteRatingAfterTwoMonth,kSettingDeleteRatingAfterFourMonth,kSettingDeleteRatingAfterSixMonth] mutableCopy]];
    
    ApplicationSettingModel *setting4 = [[ApplicationSettingModel alloc] initWithType:ApplicationSettingTypeMutilevel placeHolder:@"Update Contacts" selectedSettingText:kSettingUpdateContactManually selectedSettingBoolean:NO settingOptions:[@[kSettingUpdateContactManually,kSettingUpdateContactAutomatic] mutableCopy]];
    
    
    
    applicationSettingsArray = [NSMutableArray arrayWithObjects:setting1,setting2,setting3,setting4, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDatasource and Delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return applicationSettingsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplicationSettingModel *settingModel = [applicationSettingsArray objectAtIndex:indexPath.row];
    ApplicationSettingType settingType = settingModel.settingType;
    
    if(settingType == ApplicationSettingTypeMutilevel) {
        NSString *cellIdentifier = NSStringFromClass([ApplicationSettingMultiLevelCell class]);
        ApplicationSettingMultiLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        [self configureCellMultilevel:cell atIndexPath:indexPath];
        
        return cell;
        
    } else {
        NSString *cellIdentifier = NSStringFromClass([ApplicationSettingBooleanCell class]);
        ApplicationSettingBooleanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        [self configureCellBool:cell atIndexPath:indexPath];
        
        return cell;
    }
}
- (void)configureCellMultilevel:(ApplicationSettingMultiLevelCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ApplicationSettingModel *settingsModel = [applicationSettingsArray objectAtIndex:indexPath.row];
    
    [cell.lblPlaceHolder setText:settingsModel.settingPlaceHolder];
    [cell.lblSelectedSetting setText:settingsModel.settingTextCurrent];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}
- (void)configureCellBool:(ApplicationSettingBooleanCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ApplicationSettingModel *settingsModel = [applicationSettingsArray objectAtIndex:indexPath.row];
    
    [cell.lblPlaceHolder setText:settingsModel.settingPlaceHolder];
    [cell.switchSelectedSetting setOn:settingsModel.settingBoolCurrent];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedIndexPath = indexPath;
    
    ApplicationSettingModel *selectedSettingModel = [applicationSettingsArray objectAtIndex:indexPath.row];
    
    if(selectedSettingModel.settingType == ApplicationSettingTypeMutilevel) {
        MultiLevelSettingsViewController *multiLevelSettingObj = [self.storyboard instantiateViewControllerWithIdentifier:@"MultiLevelSettingsViewController"];
        [multiLevelSettingObj setSelectedSettingModel:selectedSettingModel];
        [multiLevelSettingObj setDelegate:self];
        [self.navigationController pushViewController:multiLevelSettingObj animated:YES];
    }
}
#pragma mark - MultiLevelSettingsViewControllerDelegate -
- (void)settingsAreChanged:(ApplicationSettingModel *)settingModel {
    [applicationSettingsArray replaceObjectAtIndex:selectedIndexPath.row withObject:settingModel];
    [tableViewApplicationSetting reloadData];
}
@end
