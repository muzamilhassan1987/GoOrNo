//
//  AWSCategory.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 22/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "GNCategory.h"

@implementation GNCategory

+ (NSString *)dynamoDBTableName {
  return @"Categories";
}

+ (NSString *)hashKeyAttribute {
  return @"CategoryID";
}

- (NSString *)description {
  return self.Name;
}

@end
