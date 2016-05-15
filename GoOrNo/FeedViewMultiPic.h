//
//  FeedViewMultiPic.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 16/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedViewGoOrNo.h"

@interface FeedViewMultiPic : FeedViewGoOrNo

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic,strong) NSArray * photos;

@end
