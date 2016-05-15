//
//  StatTableViewCell.m
//  GoOrNo
//
//  Created by Mavericks Machine on 6/6/15.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "StatTableViewCell.h"
#import "UIColor+HexColors.m"
#import "UIImageView+XHURLDownload.h"

@implementation StatTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellData:(GNRating *)rating withType:(GNPost *)post withIndexPath:(NSIndexPath*)index withSubRate:(float)subRate{
    GNUser *user = rating.user;
    if (post.Type == PostTypeNone) {
        
    }
    else if (post.Type == PostTypeMake(PostTypeGoNo)){
        [self.labelUser setText:user.Name];
        [self.labelReply setText:([rating.RatingStatus intValue] == 1) ? @"Voted Yes":@"Voted No"];
        ([rating.RatingStatus intValue] == 1)?[self.labelReply setTextColor:[UIColor colorWithHexString:@"0ab0d6"]]:@"";
    }
    else if (post.Type == PostTypeMake(PostTypeMultiPic)){
        [self.imageMultiPhoto setImageWithURL:[NSURL URLWithString:CognitoS3ImagePath([post S3ImageAtIndex:index.row])] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self setupStatView:self.labelPercent withProgressColor:[UIColor colorWithHexString:@"ed5e56"] withSize:6 withAmout:subRate];
    }
    else if (post.Type == PostTypeMake(PostTypeRatePlace)){
        [self.labelUser setText:user.Name];
        [self.labelReply setText:[rating.RatingStatus stringValue]];
    }
    else if (post.Type == PostTypeMake(PostTypeMultiAnswer)){
        [self.LabelDesc setText:[post AnswerAtIndex:(int)index]];
        [self setupStatView:self.labelAnswerPercent withProgressColor:[UIColor colorWithHexString:@"0ab0d6"] withSize:6 withAmout:subRate];
    }
}

-(void)setupStatView:(KAProgressLabel*)kLabel withProgressColor:(UIColor*)progressColor withSize:(int)size withAmout:(float)amount{
    if (amount) {
        
    }
    kLabel.fillColor = [UIColor whiteColor];
    kLabel.trackColor = [UIColor colorWithHexString:@"e4e8eb"];
    kLabel.progressColor = progressColor;
    
    kLabel.trackWidth = size;
    kLabel.progressWidth = size;
    kLabel.roundedCornersWidth = size;

    kLabel.labelVCBlock = ^(KAProgressLabel *label) {
        label.text = [NSString stringWithFormat:@"%.0f%%", (label.progress * 100)];
    };

    [kLabel setProgress:amount
                               timing:TPPropertyAnimationTimingEaseOut
                             duration:0.5
                                delay:0.2];
}

@end
