//
//  Utility.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 21/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface Utility : NSObject

+ (void)saveImage:(UIImage *)image withName:(NSString *)name inFolder:(NSString *)folder;
+ (UIImage *)loadImage:(NSString *)name fromFolder:(NSString *)folder;
+ (NSString *)pathForImageName:(NSString *)image inFolder:(NSString *)folder;
+ (NSURL *)urlForImageName:(NSString *)name inFolder:(NSString *)folder;
+ (NSString *) trimSpacesAndCharactersFromPhoneNumber:(NSString *) number;

@end
