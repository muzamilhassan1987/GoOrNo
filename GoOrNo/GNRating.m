//
//  GNRating.m
//  GoOrNo
//
//  Created by O16 Labs on 06/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "GNRating.h"

NSNumber * RatingStatusMake(RatingStatus status) {
  return [NSNumber numberWithInteger:status];
}

@implementation GNRating

+ (NSString *)dynamoDBTableName {
  return @"Ratings";
}

+ (NSString *)hashKeyAttribute {
  return @"PostID";
}

+ (NSString *)rangeKeyAttribute {
  return @"UserID";
}

@end
