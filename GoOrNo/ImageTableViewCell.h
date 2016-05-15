//
//  ImageTableViewCell.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 08/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"

@interface ImageTableViewCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewQuestion;
@end
