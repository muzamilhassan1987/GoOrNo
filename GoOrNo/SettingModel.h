//
//  SettingOptionModel.h
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject
{
    
}
@property(nonatomic, strong) NSString *settingStoryboarID;
@property(nonatomic, strong) NSString *settingTitle;
@property(nonatomic, strong) NSString *settingIconImage;

- (id)initWithStoryboardID:(NSString *)aStoryboardID title:(NSString *)aTitle imageName:(NSString *)aImageName;
@end
