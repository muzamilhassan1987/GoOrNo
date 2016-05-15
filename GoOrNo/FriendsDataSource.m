//
//  FriendsDataSource.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 11/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "FriendsDataSource.h"

@implementation FriendsDataSource

- (id)initWithViewController:(UIViewController *)viewcontroller {
  self = [super initWithViewController:viewcontroller noDataText:@"" loadingText:@"Loading..." collectionViewPropertyName:@"collectionFriends"];
  if (self) {
    //Init
  }
  return self;
}

@end
