//
//  StatisticsCell.h
//  GoOrNo
//
//  Created by O16 Labs on 30/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "GNPost.h"

@protocol StatCellDelegate <NSObject>

-(void)ShowDetailScreen:(GNPost*)post;

@end

@interface StatisticsCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPic;
@property (strong, nonatomic) IBOutlet UIButton *btnTime;
@property (weak, nonatomic) IBOutlet UIButton *buttonDetail;
@property (weak, nonatomic) IBOutlet UIView *viewAnswer;
@property (strong, nonatomic) GNPost *cellPost;
@property (weak, nonatomic) IBOutlet UILabel *labelAnswer;
@property (weak, nonatomic) IBOutlet UILabel *LabelGoStat;
@property (weak, nonatomic) IBOutlet UILabel *LabelNoStat;
@property (weak, nonatomic) IBOutlet UILabel *LabelRuling;
@property (weak, nonatomic) IBOutlet UIView *viewRuling;

@property (nonatomic,strong) id <StatCellDelegate> statDelegate;

@end
