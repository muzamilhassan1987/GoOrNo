//
//  GNRating.h
//  GoOrNo
//
//  Created by O16 Labs on 06/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GNUser.h"

typedef enum {
  RatingStatusNone = 0,
  RatingStatusGo = 1,
  RatingStatusNo = 2,
  RatingStatusImage0 = 1,
  RatingStatusImage1 = 2,
  RatingStatusImage2 = 3,
  RatingStatusImage3 = 4,
  RatingStatusImage4 = 5,
  RatingStatusAnswer0 = 1,
  RatingStatusAnswer1 = 2,
  RatingStatusAnswer2 = 3,
} RatingStatus;

NSNumber * RatingStatusMake(RatingStatus status);

@interface GNRating : AWSDynamoDBObjectModel <AWSDynamoDBModeling>

@property (nonatomic, strong) NSString * RatingID;
@property (nonatomic, strong) NSString * PostID;
@property (nonatomic, strong) NSString * UserID;
@property (nonatomic, strong) GNUser * user;
@property (nonatomic, strong) NSNumber * RatingStatus;

@end
