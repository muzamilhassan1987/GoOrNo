//
//  ApplicationSettingModel.h
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ApplicationSettingType) {
    ApplicationSettingTypeBoolean,
    ApplicationSettingTypeMutilevel,
};

extern NSString *const kSettingRatingPopUpOnFirst;
extern NSString *const kSettingRatingPopUpOnFinal;
extern NSString *const kSettingRatingPopUpOnEvery;

extern NSString *const kSettingDeleteRatingAfterOneMonth;
extern NSString *const kSettingDeleteRatingAfterTwoMonth;
extern NSString *const kSettingDeleteRatingAfterFourMonth;
extern NSString *const kSettingDeleteRatingAfterSixMonth;

extern NSString *const kSettingUpdateContactManually;
extern NSString *const kSettingUpdateContactAutomatic;

@interface ApplicationSettingModel : NSObject
{
    
}
@property(nonatomic, assign) ApplicationSettingType settingType;
@property(nonatomic, strong) NSString *settingPlaceHolder;

@property(nonatomic, strong) NSString *settingTextCurrent;
@property(nonatomic, assign) BOOL settingBoolCurrent;

@property(nonatomic, strong) NSMutableArray *settingsOptions;

- (id)initWithType:(ApplicationSettingType)settingtype placeHolder:(NSString *)placeholder selectedSettingText:(NSString *)selectedSettingText selectedSettingBoolean:(BOOL)selectedSettingBool settingOptions:(NSMutableArray *)settings;
@end
