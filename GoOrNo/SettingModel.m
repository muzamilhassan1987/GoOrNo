//
//  SettingOptionModel.m
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "SettingModel.h"

@implementation SettingModel
- (id)initWithStoryboardID:(NSString *)aStoryboardID title:(NSString *)aTitle imageName:(NSString *)aImageName {
    self = [super init];
    
    self.settingStoryboarID = [aStoryboardID copy];
    self.settingTitle = [aTitle copy];
    self.settingIconImage = [aImageName copy];
    
    return self;
}
@end
