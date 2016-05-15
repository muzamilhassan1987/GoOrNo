//
//  StatisticsDataSource.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 09/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "StatisticsDataSource.h"
#import "StatisticsRulingViewController.h"

@implementation StatisticsDataSource

- (id)initWithViewController:(UIViewController *)viewcontroller {
  self = [super initWithViewController:viewcontroller noDataText:@"" loadingText:@"Loading..." collectionViewPropertyName:@"collectionView"];
  if (self) {
    //Init
  }
  return self;
}

- (void)reloadDataSource {
  [SVProgressHUD show];
  AWSDynamoDBQueryExpression * statisticsQuery = [AWSDynamoDBQueryExpression new];
  statisticsQuery.hashKeyValues = [[[ApplicationData sharedInstance] currentUser] UserID];
  [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] query:[GNPost class] expression:statisticsQuery]
   continueWithBlock:^id(BFTask *task) {
     if (task.error) {
       dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD showErrorWithStatus:task.error.localizedDescription];
       });
       NSLog(@"The request failed. Error: [%@]", task.error);
     }
     if (task.exception) {
       NSLog(@"The request failed. Exception: [%@]", task.exception);
       dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD showErrorWithStatus:task.exception.description];
       });
     }
     if (task.result) {
       AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
         [self.itemsArray removeAllObjects];
       for (GNPost *post in paginatedOutput.items) {
         [self.itemsArray addObject:post];
       }
       dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD dismiss];
         [self reloadCollectionViewData];
       });
     }
     return nil;
   }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.itemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  StatisticsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.statDelegate = (StatisticsRulingViewController*) self.viewcontroller;
    
    GNPost * post = self.itemsArray[indexPath.item];
    NSString * dateTime = [[NSDate dateWithTimeIntervalSince1970:post.Date.doubleValue] timeAgoSimple];
    cell.cellPost = post;
    [cell.btnTime setTitle:[NSString stringWithFormat:@" %@",dateTime] forState:UIControlStateNormal];
    [cell.imageViewPic setImageWithURL:[NSURL URLWithString:CognitoS3ImagePath(post.S3Image0)] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [cell.viewAnswer setHidden:YES];
    [cell.viewRuling setHidden:YES];
    return cell;
}

@end
