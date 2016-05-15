//
//  Utility.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 21/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "Utility.h"

@implementation Utility


+ (NSString *)directoryPathForFolder:(NSString *)folder {
//  return  [NSString stringWithFormat:@"%@/%@",NSTemporaryDirectory(), folder];
  return NSTemporaryDirectory();
}
+ (void)saveImage:(UIImage *)image withName:(NSString *)name inFolder:(NSString *)folder {
  NSData *data = UIImageJPEGRepresentation(image, 1.0);
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *fullPath = [[self directoryPathForFolder:folder] stringByAppendingPathComponent:name];
  [fileManager createFileAtPath:fullPath contents:data attributes:nil];
}
+ (UIImage *)loadImage:(NSString *)name fromFolder:(NSString *)folder {
  NSString *fullPath = [[self directoryPathForFolder:folder] stringByAppendingPathComponent:name];
  UIImage *img = [UIImage imageWithContentsOfFile:fullPath];
  
  return img;
}
+ (NSString *)pathForImageName:(NSString *)name inFolder:(NSString *)folder {
  return [[self directoryPathForFolder:folder] stringByAppendingPathComponent:name];
}
+ (NSURL *)urlForImageName:(NSString *)name inFolder:(NSString *)folder {
  return [NSURL fileURLWithPath:[self pathForImageName:name inFolder:folder]];
}

+(NSString *) trimSpacesAndCharactersFromPhoneNumber:(NSString *) number {
    
    

    
//    NSString *phone = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
//    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
//    phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
//    phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
//    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    phone = [phone stringByReplacingOccurrencesOfString:'\U00a0' withString:@""];
    
    NSString *phone = [[number componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    return phone;
}

@end
