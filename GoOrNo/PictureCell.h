//
//  PictureCell.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 16/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureCell : UICollectionViewCell

@property (nonatomic,weak) IBOutlet UIImageView * picture;
@property (nonatomic,strong) IBOutlet UILabel * lblIsDefault;

@end
