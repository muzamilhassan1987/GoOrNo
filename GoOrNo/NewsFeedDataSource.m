//
//  NewsFeedDataSource.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 08/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "NewsFeedDataSource.h"


@implementation NewsFeedDataSource

- (id)initWithViewController:(UIViewController *)viewcontroller noDataText:(NSString *)noDataText loadingText:(NSString *)loadingText {
  self = [super initWithViewController:viewcontroller noDataText:noDataText loadingText:loadingText];
  return self;
}

- (void)reloadDataSource {
  self.numberOfSections = 10;
  [super reloadDataSource];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.numberOfSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString * imageCellId = @"ImageTableViewCell";
  static NSString * userInfoCellId = @"UserInfoTableViewCell";
  static NSString * questionCellId = @"QuestionTableViewCell";
  
  UITableViewCell * cell;
  switch(indexPath.row) {
    case 0:
    {
      ImageTableViewCell * imageCell = [tableView dequeueReusableCellWithIdentifier:imageCellId forIndexPath:indexPath];
      imageCell.imageViewQuestion.backgroundColor = [UIColor grayColor];
      
      //configure left buttons
      MGSwipeButton * noButton = [MGSwipeButton buttonWithTitle:@"NO"
                                                           icon:nil
                                                backgroundColor:[UIColor redColor]
                                                       callback:^BOOL(MGSwipeTableCell *sender) {
                                                         
                                                         [tableView beginUpdates];
                                                         [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                         if(self.numberOfSections > 0)
                                                           self.numberOfSections--;
                                                         else
                                                           self.numberOfSections = 0;
                                                         [tableView endUpdates];
                                                         return true;
                                                       }];
                                  
      imageCell.leftButtons = @[noButton];
      imageCell.leftSwipeSettings.transition = MGSwipeTransitionDrag;
      imageCell.leftExpansion.buttonIndex = 0;
      imageCell.leftExpansion.threshold = 1.0;
      imageCell.leftExpansion.fillOnTrigger = YES;
      
      //configure right buttons
      MGSwipeButton * goButton = [MGSwipeButton buttonWithTitle:@"GO"
                                                           icon:nil
                                                backgroundColor:[UIColor greenColor]
                                                       callback:^BOOL(MGSwipeTableCell *sender) {
                                                         
                                                         [tableView beginUpdates];
                                                         [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                         self.numberOfSections--;
                                                         [tableView endUpdates];
                                                         return true;
                                                       }];
      imageCell.rightButtons = @[goButton];
      imageCell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
      imageCell.rightExpansion.buttonIndex = 0;
      imageCell.rightExpansion.threshold = 1.0;
      imageCell.rightExpansion.fillOnTrigger = YES;
      cell = imageCell;
      break;
    }
    case 1:
    {
      UserInfoTableViewCell * infoCell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId forIndexPath:indexPath];
      infoCell.lblName.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
      infoCell.lblAddress.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
      infoCell.lblTime.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
      cell = infoCell;
      break;
    }
    case 2:
    {
      QuestionTableViewCell * qCell = [tableView dequeueReusableCellWithIdentifier:questionCellId forIndexPath:indexPath];
      cell = qCell;
      break;
    }
    default:
      cell = nil;
      break;
  }
  return cell;
}

@end
