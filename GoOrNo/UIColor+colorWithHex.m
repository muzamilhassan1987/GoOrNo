//
//  UIColor+colorWithHex.m
//  GoOrNo
//
//  Created by Mavericks Machine on 6/5/15.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "UIColor+colorWithHex.h"

@implementation UIColor (colorWithHex)

+ (UIColor *)colorWithHex:(int)hex
{
    
    return [self colorWithHex:hex withAlpha:1.0f];
    
}

+ (UIColor *)colorWithHex:(int)hex withAlpha:(CGFloat)alpha
{
    
    CGFloat r = ((hex & 0xFF0000) >> 16) / 255.0;
    CGFloat g = ((hex & 0x00FF00) >> 8 ) / 255.0;
    CGFloat b = ((hex & 0x0000FF)      ) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    
}

@end