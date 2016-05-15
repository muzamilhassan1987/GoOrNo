//
//  MultiUserTableViewCell.h
//  GoOrNo
//
//  Created by Mavericks Machine on 6/8/15.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GNRating.h"

@interface MultiUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelVote;
-(void)setCellData:(GNRating*)rating withUsers:(GNUser*)user index:(int)selectedIndex;

@end
