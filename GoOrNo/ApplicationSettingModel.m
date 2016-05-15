//
//  ApplicationSettingModel.m
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ApplicationSettingModel.h"

NSString *const kSettingRatingPopUpOnFirst = @"On First Ruling Only";
NSString *const kSettingRatingPopUpOnFinal = @"On Final Ruling Only";
NSString *const kSettingRatingPopUpOnEvery = @"On Every Ruling Only";

NSString *const kSettingDeleteRatingAfterOneMonth = @"After 1 Month";
NSString *const kSettingDeleteRatingAfterTwoMonth = @"After 2 Month";
NSString *const kSettingDeleteRatingAfterFourMonth = @"After 4 Month";
NSString *const kSettingDeleteRatingAfterSixMonth = @"After 6 Month";

NSString *const kSettingUpdateContactManually = @"Manually";
NSString *const kSettingUpdateContactAutomatic = @"Automatic";

@implementation ApplicationSettingModel
- (id)initWithType:(ApplicationSettingType)settingtype placeHolder:(NSString *)placeholder selectedSettingText:(NSString *)selectedSettingText selectedSettingBoolean:(BOOL)selectedSettingBool settingOptions:(NSMutableArray *)settings {
    self = [super init];
    
    self.settingType = settingtype;
    self.settingPlaceHolder = placeholder;
    
    self.settingTextCurrent = selectedSettingText;
    self.settingBoolCurrent = selectedSettingBool;
    
    self.settingsOptions = [settings copy];
    
    return self;
}
@end
