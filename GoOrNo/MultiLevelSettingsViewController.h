//
//  MultiLevelSettingsViewController.h
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ViewController.h"
#import "ApplicationSettingModel.h"

@protocol MultiLevelSettingsViewControllerDelegate <NSObject>

@optional
- (void)settingsAreChanged:(ApplicationSettingModel *)settingModel;

@end

@interface MultiLevelSettingsViewController : ViewController
{
    
}
@property(nonatomic, weak) id<MultiLevelSettingsViewControllerDelegate> delegate;

@property(nonatomic, strong) ApplicationSettingModel *selectedSettingModel;
@end
