//
//  MiltiPicturesDataSource.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 16/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "MultiPicturesDataSource.h"
#import "AddMultiPicViewController.h"

@implementation MultiPicturesDataSource

- (id)initWithViewController:(UIViewController *)viewcontroller collectionViewPropertyName:(NSString *)name {
  self = [super initWithViewController:viewcontroller noDataText:@"No Images" loadingText:@"Loading..."collectionViewPropertyName:name];
  if (self) {
    _controller = (AddMultiPicViewController *)viewcontroller;
  }
  return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  _controller.pageControl.numberOfPages = self.itemsArray.count;
  return self.itemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//  UICollectionViewCell * cell;
//  if (indexPath.row==self.itemsArray.count) {
//    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCell" forIndexPath:indexPath];
//    return cell;
//  }
  PictureCell * picCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//  ALAsset * asset = self.itemsArray[indexPath.item];
  _controller.pageControl.currentPage = indexPath.item;
  if (indexPath.item == _controller.defaultPicIndex) {
    picCell.lblIsDefault.text = @"Default Image";
  } else {
    picCell.lblIsDefault.text = @"Tap to make it default image";
  }
  picCell.picture.image = self.itemsArray[indexPath.item];
  return picCell;
}

@end
