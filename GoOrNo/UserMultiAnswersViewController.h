//
//  UserMultiAnswersViewController.h
//  GoOrNo
//
//  Created by Mavericks Machine on 6/6/15.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ViewController.h"
#import "GNPost.h"

@interface UserMultiAnswersViewController : ViewController

@property(nonatomic,strong) GNPost *selectedPost;
@property(nonatomic,assign) int selectedIndex;
@property(nonatomic,assign) NSArray *allRatings;
@property(nonatomic,assign) NSArray *allUsers;

@property (weak, nonatomic) IBOutlet UIImageView *MapImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelAnswerDetail;
@property (weak, nonatomic) IBOutlet UIView *viewAnswer;
@end
