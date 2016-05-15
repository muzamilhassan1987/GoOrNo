//
//  FeedViewGoOrNo.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 17/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeedViewGoOrNo;

@protocol FeedViewGoOrNoDelegate <NSObject>

@optional
- (void)feedViewClickedImage:(FeedViewGoOrNo *)view;

@end
@interface FeedViewGoOrNo : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPic;
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblCompany;
@property (strong, nonatomic) IBOutlet UIButton *btnTime;

@property (nonatomic, strong) UILabel *yesLabel;
@property (nonatomic, strong) UILabel *noLabel;

@property (nonatomic,weak) id<FeedViewGoOrNoDelegate>delegate;

- (IBAction)btnImageTapped:(UIButton *)sender;

@end
