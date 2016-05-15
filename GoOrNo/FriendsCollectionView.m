//
//  FriendsCollectionView.m
//  GoOrNo
//
//  Created by Asif Ali on 05/06/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "FriendsCollectionView.h"
#import "Constants.h"
#import "GNUser.h"

@implementation FriendsCollectionView

-(void) reloadWithData:(NSArray *) data {
    
    dataArray = data;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        
        NSString *title = [[NSString alloc]initWithFormat:@"%d Friends", [dataArray count]];
        UILabel *label = (UILabel *)[view viewWithTag:10];
        label.text = title;

        reusableview = view;
    }
    return reusableview;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"friendsCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                                            forIndexPath:indexPath];
    
    if (!cell) {
        assert(@"CollectionViewCell can not be nil");
    }
    GNUser *contact = [dataArray objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel *) [cell.contentView viewWithTag:11];
    [nameLabel setText:contact.Name];
    
    UIImageView *imageView = (UIImageView *) [cell.contentView viewWithTag:10];
    [imageView.layer setCornerRadius:imageView.frame.size.height / 2.0];
    [imageView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [imageView.layer setBorderWidth:1.0];
    
    [imageView setClipsToBounds:YES];
    [imageView sd_setImageWithURL:[NSURL URLWithString:CognitoS3ImagePath(contact.Image)]
                 placeholderImage:[UIImage imageNamed:kUserPlaceholder]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(60, 60);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(2, 0, 0, 0);
}


@end
