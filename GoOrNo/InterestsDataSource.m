//
//  InterestsDataSource.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 11/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "InterestsDataSource.h"

@implementation InterestsDataSource

- (id)initWithViewController:(UIViewController *)viewcontroller {
  self = [super initWithViewController:viewcontroller noDataText:@"" loadingText:@"Loading..." collectionViewPropertyName:@"collectionInterests"];
  if (self) {
    //Init
  }
  return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 15;
}

@end
