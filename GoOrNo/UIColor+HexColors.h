//
//  UIColor+HexColors.h
//  GoOrNo
//
//  Created by Mavericks Machine on 6/5/15.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColors)

+(UIColor *)colorWithHexString:(NSString *)hexString;
+(NSString *)hexValuesFromUIColor:(UIColor *)color;

@end