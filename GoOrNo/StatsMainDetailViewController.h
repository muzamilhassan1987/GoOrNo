//
//  StatsMainDetailViewController.h
//  GoOrNo
//
//  Created by Mavericks Machine on 6/2/15.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "KAProgressLabel.h"
#import "GNPost.h"
#import "GNUser.h"
#import "StatHeaderView.h"

@interface StatsMainDetailViewController : ViewController{
    
    __weak IBOutlet UIImageView *mainImageView;
//    __weak IBOutlet UILabel *labelReplyNumber;
//    __weak IBOutlet KAProgressLabel *kLabelYes;
//    __weak IBOutlet KAProgressLabel *kLabelNo;
    
    NSMutableArray *ratingArray;
    NSArray *usersArray;
}

@property (strong,nonatomic) GNPost *selectedPost;


@end
