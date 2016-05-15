//
//  FeedViewMultiAnswer.h
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "FeedViewGoOrNo.h"

@interface FeedViewMultiAnswer : FeedViewGoOrNo

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end
