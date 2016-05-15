//
//  RulingDataSource.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 09/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ASCollectionViewDataSource.h"
#import "StatisticsCell.h"

@interface RulingDataSource : ASCollectionViewDataSource{
    NSMutableArray *ratingArray;
    NSArray *postArray;
    NSMutableArray *rulingArray;
}

- (id)initWithViewController:(UIViewController *)viewcontroller;


@end
