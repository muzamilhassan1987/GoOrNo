//
//  FriendsCollectionView.h
//  GoOrNo
//
//  Created by Asif Ali on 05/06/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *dataArray;
}
-(void) reloadWithData:(NSArray *) data;
@end
