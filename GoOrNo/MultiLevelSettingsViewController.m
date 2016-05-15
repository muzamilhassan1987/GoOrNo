//
//  MultiLevelSettingsViewController.m
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "MultiLevelSettingsViewController.h"
#import "MultiLevelSettingCell.h"

@interface MultiLevelSettingsViewController () <UITableViewDelegate>
{
    IBOutlet UITableView *tableViewMultiLevelSetting;
}
@end

@implementation MultiLevelSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.selectedSettingModel.settingPlaceHolder.capitalizedString;
    
    [self setNavigationBackgroundColor:nil titleColor:[UIColor blackColor]];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self setBackButtonWithColor:[UIColor blackColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDatasource and Delegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedSettingModel.settingsOptions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = NSStringFromClass([MultiLevelSettingCell class]);
    MultiLevelSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [self configureCellMultilevel:cell indexPath:indexPath];
    
    return cell;
    
}
- (void)configureCellMultilevel:(MultiLevelSettingCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    NSString *settingTitle = [self.selectedSettingModel.settingsOptions objectAtIndex:indexPath.row];
    
    [cell.lblTitle setText:settingTitle];
    
    if([settingTitle isEqualToString:self.selectedSettingModel.settingTextCurrent]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selectedSetting = [self.selectedSettingModel.settingsOptions objectAtIndex:indexPath.row];
    
    self.selectedSettingModel.settingTextCurrent = selectedSetting;
    
    [tableView reloadData];
    
    if([self.delegate respondsToSelector:@selector(settingsAreChanged:)]) {
        [self.delegate settingsAreChanged:self.selectedSettingModel];
    }
}

@end
