//
//  StatTableViewCell.h
//  GoOrNo
//
//  Created by Mavericks Machine on 6/6/15.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAProgressLabel.h"
#import "GNRating.h"
#import "GNPost.h"

@interface StatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelUser;
@property (weak, nonatomic) IBOutlet UILabel *labelReply;

@property (weak, nonatomic) IBOutlet UIImageView *imageMultiPhoto;
@property (weak, nonatomic) IBOutlet KAProgressLabel *labelPercent;

@property (weak, nonatomic) IBOutlet UILabel *LabelAnswer;
@property (weak, nonatomic) IBOutlet UILabel *LabelDesc;
@property (weak, nonatomic) IBOutlet KAProgressLabel *labelAnswerPercent;


-(void)setCellData:(GNRating*)rating withType:(GNPost*)post  withIndexPath:(NSIndexPath*)index withSubRate:(float)subRate;

@end
