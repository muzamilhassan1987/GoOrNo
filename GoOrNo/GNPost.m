//
//  AWSPost.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 21/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "GNPost.h"

NSNumber * PostTypeMake(PostType type) {
  return [NSNumber numberWithInteger:type];
}

@implementation GNPost

//- (instancetype)init {
//  self = [super init];
//  if (self) {
//    self.DefaultIndex = @0;
//  }
//  return self;
//}

- (NSString *)NavigationTitle {
  NSString * title = nil;
  switch (self.Type.integerValue) {
    case PostTypeGoNo:
      title = @"Go or No";
      break;
    case PostTypeMultiPic:
      title = @"Multi Picture";
      break;
    case PostTypeMultiAnswer:
      title = @"Multi Answer";
      break;
    case PostTypeRatePlace:
      title = @"Rate Place";
      break;
    default:
      break;
  }
  return title;
}

- (NSString*)postType {
  switch (self.Type.integerValue) {
    case PostTypeGoNo:
      return @"PostTypeGoNo";
    case PostTypeMultiPic:
      return @"PostTypeMultiPic";
    case PostTypeMultiAnswer:
      return @"PostTypeMultiAnswer";
    case PostTypeRatePlace:
       return @"PostTypeRatePlace";
  }

  return nil;
}

- (UIColor *)BackgroundColor {
    UIColor * color = [UIColor orangeColor];
    switch (self.Type.integerValue) {
        case PostTypeGoNo:
            color = [UIColor cyanColor];
            break;
        case PostTypeMultiPic:
            color = [UIColor orangeColor];
            break;
        case PostTypeMultiAnswer:
            color = [UIColor greenColor];
            break;
        case PostTypeRatePlace:
            color = [UIColor magentaColor];
            break;
        default:
            break;
    }
    return color;
}

- (UIColor *)TextColor {
  UIColor * color = [UIColor whiteColor];
  switch (self.Type.integerValue) {
    case PostTypeGoNo:
      color = [UIColor blackColor];
      break;
    case PostTypeMultiPic:
    case PostTypeMultiAnswer:
    case PostTypeRatePlace:
    default:
      break;
  }
  return color;
}

- (NSString *)DefaultImage {
  NSString * image = self.S3Image0;
  if (self.Type.integerValue == PostTypeMultiPic) {
    image = [self valueForKey:[NSString stringWithFormat:@"S3Image%ld",(long)self.DefaultIndex.integerValue]];
  }
  return image;
}

- (NSNumber *)NumberOfImages {
  NSString * imageName = [self valueForKey:[NSString stringWithFormat:@"S3Image%d",0]];
  int number = 0;
  for (number = 0; imageName!=nil; number++) {
    imageName = (number>=4) ? nil : [self valueForKey:[NSString stringWithFormat:@"S3Image%d",number+1]];
  }
  return [NSNumber numberWithInt:number];
}

- (NSNumber *)NumberOfAnswers{
    NSString * answer = [self valueForKey:[NSString stringWithFormat:@"Answer%d",1]];
    int number = 1;
    for (number = 1; answer!=nil; number++) {
        answer = (number>=2) ? nil : [self valueForKey:[NSString stringWithFormat:@"Answer%d",number+1]];
    }
    return [NSNumber numberWithInt:number];
}

- (NSString *)AnswerAtIndex:(NSInteger)index {
  switch (index) {
    case 0:
      if (self.Answer1) {
        return self.Answer1;
      } else if(self.Answer2) {
        return self.Answer2;
      } else {
        return self.Answer3;
      }
      break;
    case 1:
      if(self.Answer2) {
        return self.Answer2;
      } else {
        return self.Answer3;
      }
      break;
    case 2:
      return self.Answer3;
      break;
    default:
      break;
  }
  return nil;
}
- (NSString *)S3ImageAtIndex:(NSInteger)index {
  return [self valueForKey:[NSString stringWithFormat:@"S3Image%ld",(long)index]];
}

- (RatingStatus)PostRatingStatus {
  RatingStatus rating = (RatingStatus)self.DefaultIndex.integerValue+1;
  return rating;
}

-(float)PostPhotoRatingNumberAtIndex:(NSInteger)imageIndex ratings:(NSArray*)ratingArray{
    float count = 0;
    for (GNRating *rating in ratingArray) {
        if ([rating.RatingStatus integerValue] == imageIndex)
            count++;
    }
    if (count!=0)
        count = count/ratingArray.count;
    return count;
}

-(float)PostAnswerRatingNumberAtIndex:(NSInteger)answerIndex ratings:(NSArray *)ratingArray{
    float count = 0;
    for (GNRating *rating in ratingArray) {
        if ([rating.RatingStatus integerValue] == answerIndex)
            count++;
    }
    if (count!=0)
        count = count/ratingArray.count;
    return count;
}

+ (NSString *)dynamoDBTableName {
  return @"Posts";
}

+ (NSString *)hashKeyAttribute {
  return @"UserID";
}

+ (NSString *)rangeKeyAttribute {
  return @"PostID";
}

@end
