//
//  AWSPost.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 21/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GNRating.h"

typedef enum {
  PostTypeNone = 0,
  PostTypeGoNo = 1,
  PostTypeMultiPic = 2,
  PostTypeMultiAnswer = 4,
  PostTypeRatePlace = 8
} PostType;

NSNumber * PostTypeMake(PostType type);

@interface GNPost : AWSDynamoDBObjectModel <AWSDynamoDBModeling>

@property (nonatomic,strong) NSNumber * Type;

// Common Attributes
@property (nonatomic,strong) NSString * PostID;
@property (nonatomic,strong) NSString * UserID;
@property (nonatomic,strong) NSNumber * CategoryID;
@property (nonatomic,strong) NSNumber * QuestionID;
@property (nonatomic,strong) NSString * CustomQuestion;
@property (nonatomic,strong) NSString * SharingScope;
@property (nonatomic,strong) NSString * InvitedUsers;
@property (nonatomic,strong) NSNumber * Date;

// Read-only
- (RatingStatus)PostRatingStatus;
-(float)PostPhotoRatingNumberAtIndex:(NSInteger)imageIndex ratings:(NSArray*)ratingArray;
-(float)PostAnswerRatingNumberAtIndex:(NSInteger)imageIndex ratings:(NSArray*)ratingArray;
- (NSString *)NavigationTitle;
- (UIColor *)BackgroundColor;
- (UIColor *)TextColor;
- (NSString *)DefaultImage;
- (NSNumber *)NumberOfImages;
- (NSNumber *)NumberOfAnswers;
- (NSString *)AnswerAtIndex:(NSInteger)index;
- (NSString *)S3ImageAtIndex:(NSInteger)index;

- (NSString*)postType;

// Multi-Image
@property (nonatomic,strong) NSNumber * DefaultIndex;
@property (nonatomic,strong) NSString * S3Image0;
@property (nonatomic,strong) NSString * S3Image1;
@property (nonatomic,strong) NSString * S3Image2;
@property (nonatomic,strong) NSString * S3Image3;
@property (nonatomic,strong) NSString * S3Image4;

// Multi-Answer
@property (nonatomic,strong) NSNumber * TotalNumberOfAnswers;
@property (nonatomic,strong) NSNumber * Answer1ID;
@property (nonatomic,strong) NSString * Answer1;
@property (nonatomic,strong) NSNumber * Answer2ID;
@property (nonatomic,strong) NSString * Answer2;
@property (nonatomic,strong) NSNumber * Answer3ID;
@property (nonatomic,strong) NSString * Answer3;

// Rate Place
@property (nonatomic,strong) NSString * PlaceDescription;
@property (nonatomic,strong) NSString * PlaceAddress;
@property (nonatomic,strong) NSNumber * Latitude;
@property (nonatomic,strong) NSNumber * Longitude;

@end
