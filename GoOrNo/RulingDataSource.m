//
//  RulingDataSource.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 09/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

@interface RulingLabel : NSObject

@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) UIColor *textColor;
@property(nonatomic,assign) int textSize;

@end

@implementation RulingLabel : NSObject


@end

#import "RulingDataSource.h"
#import "UIColor+PXColors.h"

@implementation RulingDataSource

- (id)initWithViewController:(UIViewController *)viewcontroller {
  self = [super initWithViewController:viewcontroller noDataText:@"" loadingText:@"Loading..." collectionViewPropertyName:@"collectionView"];
  if (self) {
    //Init
  }
  return self;
}

#pragma mark - Private Methods

-(RulingLabel*)getStatus:(PostType)postType ratingObject:(GNRating*)rating{
    RulingLabel *ruling = [[RulingLabel alloc] init];
    if (postType == PostTypeGoNo || postType == PostTypeRatePlace) {
        switch ([rating.RatingStatus intValue]) {
            case 1:{
                UIColor *color = [UIColor colorWithHexString:@"0cd855"];
                [ruling setText:@"GO"];
                [ruling setTextColor:color];
                [ruling setTextSize:22];
                return ruling;
            }
                break;
            case 2:{
                UIColor *color = [UIColor colorWithHexString:@"c20606"];
                [ruling setText:@"NO"];
                [ruling setTextColor:color];
                [ruling setTextSize:22];
                return ruling;
            }
                break;
                
            default:
                break;
        }
    }
    else if (postType == PostTypeMultiPic || postType == PostTypeMultiAnswer){
        [ruling setText:@"That's it"];
        [ruling setTextSize:17];
        return ruling;
    }
    
    return ruling;
}

#pragma mark - Amazon Services

-(void)getRatings{
    AWSDynamoDBCondition *condition = [AWSDynamoDBCondition new];
    AWSDynamoDBAttributeValue *attribute = [AWSDynamoDBAttributeValue new];
    
    attribute.S = [[[ApplicationData sharedInstance] currentUser] UserID];
    
    condition.comparisonOperator = AWSDynamoDBComparisonOperatorIN;
    condition.attributeValueList = @[attribute];
    NSDictionary *dictionary = @{@"UserID" : condition};
    
    
    AWSDynamoDBScanExpression *expression = [AWSDynamoDBScanExpression new];
    expression.scanFilter = dictionary;
    expression.limit = @(100);
    
    [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] scan:[GNRating class] expression:expression] continueWithBlock:^id(BFTask *task) {
        
        if (task.error) {
            NSLog(@"The request failed. Error: [%@]", task.error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:task.error.localizedDescription];
            });
        }
        else if (task.exception) {
            NSLog(@"The request failed. Exception: [%@]", task.exception);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"Failed. Exception occured"];
            });
        }
        else if (task.result) {
            
            ratingArray = (NSMutableArray*)[(AWSDynamoDBPaginatedOutput *)task.result items];
            if (ratingArray.count > 0)
                [self getPosts];
        }
        return task;
    }];
}

-(void)getPosts{
    NSMutableArray *attributes = [NSMutableArray new];
    
    AWSDynamoDBCondition *condition = [AWSDynamoDBCondition new];
    
    for (GNRating *rating in ratingArray) {
        
        AWSDynamoDBAttributeValue *att = [AWSDynamoDBAttributeValue new];
        att.S = rating.PostID;
        [attributes addObject:att];
    }
    condition.comparisonOperator = AWSDynamoDBComparisonOperatorIN;
    condition.attributeValueList = attributes;
    NSDictionary *dictionary = @{@"PostID" : condition};
    
    
    AWSDynamoDBScanExpression *expression = [AWSDynamoDBScanExpression new];
    expression.scanFilter = dictionary;
    expression.limit = @(100);
    
    [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] scan:[GNPost class] expression:expression] continueWithBlock:^id(BFTask *task) {
        
        if (task.error) {
            NSLog(@"The request failed. Error: [%@]", task.error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:task.error.localizedDescription];
            });
        }
        else if (task.exception) {
            NSLog(@"The request failed. Exception: [%@]", task.exception);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"Failed. Exception occured"];
            });
        }
        else if (task.result) {
            postArray = [(AWSDynamoDBPaginatedOutput *)task.result items];
            rulingArray = [NSMutableArray array];
            for (GNPost *post in postArray) {
                [self.itemsArray addObject:post];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"PostID == %@", post.PostID];
                [rulingArray addObject:@{@"rating":[[ratingArray filteredArrayUsingPredicate:predicate] objectAtIndex:0],@"post":post}];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self reloadCollectionViewData];
            });
        }
        
        return task;
    }];
}

#pragma mark - UITabelView DataSource

- (void)reloadDataSource {
    [self getRatings];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StatisticsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    GNPost * post = self.itemsArray[indexPath.item];
    GNRating * rating = [[rulingArray objectAtIndex:indexPath.row] objectForKey:@"rating"];
    
    NSString * question = (post.QuestionID.integerValue>=0) ? [[[ApplicationData sharedInstance] questions][post.QuestionID.integerValue] description] : post.CustomQuestion;
    NSString * dateTime = [[NSDate dateWithTimeIntervalSince1970:post.Date.doubleValue] timeAgoSimple];
    [cell.btnTime setTitle:[NSString stringWithFormat:@" %@",dateTime] forState:UIControlStateNormal];
    [cell.LabelRuling setText:[self getStatus:post.Type.intValue ratingObject:rating].text];
    [cell.LabelRuling setTextColor:[self getStatus:post.Type.intValue ratingObject:rating].textColor];
    [cell.LabelRuling setFont:[UIFont boldSystemFontOfSize:[self getStatus:post.Type.intValue ratingObject:rating].textSize]];
    [cell.imageViewPic setImageWithURL:[NSURL URLWithString:CognitoS3ImagePath(post.S3Image0)] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [cell.buttonDetail setEnabled:NO];
    [cell.LabelGoStat setHidden:YES];
    [cell.LabelNoStat setHidden:YES];
    if (post.Type.intValue == PostTypeMultiAnswer) {
        [cell.labelAnswer setText:question];
    }
    else
        [cell.viewAnswer setHidden:YES];
    
    return cell;
}

@end
