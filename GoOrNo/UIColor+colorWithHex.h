//
//  UIColor+colorWithHex.h
//  GoOrNo
//
//  Created by Mavericks Machine on 6/5/15.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (colorWithHex)

+ (UIColor *)colorWithHex:(int)hex;
+ (UIColor *)colorWithHex:(int)hex withAlpha:(CGFloat)alpha;

@end