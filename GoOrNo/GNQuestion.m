//
//  GNQuestion.m
//  GoOrNo
//
//  Created by O16 Labs on 28/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "GNQuestion.h"

@implementation GNQuestion

+ (NSString *)dynamoDBTableName {
  return @"Questions";
}

+ (NSString *)hashKeyAttribute {
  return @"QuestionID";
}

- (NSString *)description {
  return self.Name;
}

@end
