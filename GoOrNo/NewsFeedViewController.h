//
//  RScreenViewController.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 08/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ViewController.h"


@interface NewsFeedViewController : ViewController 

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet ZLSwipeableView *swipeableView;

@property (nonatomic,strong) NSMutableArray * itemsArray;
@property (nonatomic,strong) NSString *selectedPostID;
@property (nonatomic,assign) int currentPostIndex;
@property (nonatomic,assign) BOOL showSelectedPost;

- (IBAction)btnLoginSignUpTapped:(UIButton *)sender;
- (void)downloadSelectedPost;
-(void)showPostFromNotification:(NSString*)postID;

@end
