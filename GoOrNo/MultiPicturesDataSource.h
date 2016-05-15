//
//  MiltiPicturesDataSource.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 16/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ASCollectionViewDataSource.h"
#import "PictureCell.h"
@class AddMultiPicViewController;

@interface MultiPicturesDataSource : ASCollectionViewDataSource

- (id)initWithViewController:(UIViewController *)viewcontroller collectionViewPropertyName:(NSString *)name;
@property (nonatomic,strong) AddMultiPicViewController * controller;

@end
