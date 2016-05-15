//
//  MultiUserTableViewCell.m
//  GoOrNo
//
//  Created by Mavericks Machine on 6/8/15.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "MultiUserTableViewCell.h"

@implementation MultiUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellData:(GNRating *)rating withUsers:(GNUser *)user index:(int)selectedIndex {
    [self.labelUserName setText:user.Name];
    [self.labelVote setText:(rating.UserID == user.UserID)?@"Voted Yes":@"Voted No"];
}

@end
