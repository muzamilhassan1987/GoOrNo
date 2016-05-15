//
//  GNAnswer.m
//  GoOrNo
//
//  Created by O16 Labs on 15/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "GNAnswer.h"

@implementation GNAnswer

+ (NSString *)dynamoDBTableName {
  return @"Answers";
}

+ (NSString *)hashKeyAttribute {
  return @"AnswerID";
}

- (NSString *)description {
  return self.Name;
}

@end
