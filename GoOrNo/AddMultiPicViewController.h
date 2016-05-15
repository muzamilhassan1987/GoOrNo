//
//  AddMultiPicViewController.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 16/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "AddBaseViewController.h"

@interface AddMultiPicViewController : AddBaseViewController <UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) ASCollectionViewDataSource * dataSourcePics;
@property (nonatomic,assign) NSUInteger defaultPicIndex;

- (IBAction)btnDeletePic:(UIButton *)sender;
- (IBAction)btnAddPicTapped:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPics;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintAddImageHeight;

@end
