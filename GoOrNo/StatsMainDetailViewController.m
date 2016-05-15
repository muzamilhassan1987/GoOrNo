//
//  StatsMainDetailViewController.m
//  GoOrNo
//
//  Created by Mavericks Machine on 6/2/15.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "StatsMainDetailViewController.h"
#import "UserMultiAnswersViewController.h"
#import "UIImageView+XHURLDownload.h"
#import "UIColor+HexColors.m"
#import "StatTableViewCell.h"

@interface StatsMainDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *statsTableView;
@property (nonatomic, assign) NSMutableDictionary *ratingDict;

@end

@implementation StatsMainDetailViewController


#pragma mark - Private Methods

-(void)setViewContent{
    [self setTitle:@"Statistics"];
    [self setBackButton];
    [mainImageView setImageWithURL:[NSURL URLWithString:CognitoS3ImagePath(self.selectedPost.S3Image0)] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self setViewControllerClass:self.selectedPost.postType];
    [self getRating];
}

-(void)setUserData{
    [self.statsTableView reloadData];
}

-(void)setupStatView:(KAProgressLabel*)kLabel withProgressColor:(UIColor*)progressColor withSize:(int)size withAmout:(float)amout{
    
    kLabel.fillColor = [UIColor whiteColor];
    kLabel.trackColor = [UIColor colorWithHexString:@"e4e8eb"];
    kLabel.progressColor = progressColor;
    
    kLabel.trackWidth = size;
    kLabel.progressWidth = size;
    kLabel.roundedCornersWidth = size;
    
    kLabel.labelVCBlock = ^(KAProgressLabel *label) {
        label.text = [NSString stringWithFormat:@"%.0f%%", (label.progress * 100)];
    };
    
    [kLabel setProgress:amout
                 timing:TPPropertyAnimationTimingEaseOut
               duration:0.5
                  delay:0.2];
}

-(float)getYesCount{
    float count = 0;
    for (GNRating *rating in ratingArray) {
        if ([rating.RatingStatus intValue] == 1) {
            count++;
        }
    }
    return count;
}

-(float)perCellStat:(NSIndexPath*)indexPath{
    if ([self.selectedPost.Type intValue] == PostTypeMultiPic) {
        return [self.selectedPost PostPhotoRatingNumberAtIndex:indexPath.row ratings:ratingArray];
    }
    else if ([self.selectedPost.Type intValue] == PostTypeMultiAnswer){
        return [self.selectedPost PostPhotoRatingNumberAtIndex:indexPath.row ratings:ratingArray];
    }
    return 0;
}

#pragma mark - AWS Services

-(void)getRating{
    
    AWSDynamoDBCondition *condition = [AWSDynamoDBCondition new];
    AWSDynamoDBAttributeValue *attribute = [AWSDynamoDBAttributeValue new];
    
    attribute.S = self.selectedPost.PostID;
    
    condition.comparisonOperator = AWSDynamoDBComparisonOperatorIN;
    condition.attributeValueList = @[attribute];
    NSDictionary *dictionary = @{@"PostID" : condition};
    
    
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
                [self getUsers];
        }
        return task;
    }];
}

-(void)getUsers{
    
    NSMutableArray *attributes = [NSMutableArray new];
    
    AWSDynamoDBCondition *condition = [AWSDynamoDBCondition new];
    self.ratingDict = [NSMutableDictionary dictionary];
    for (GNRating *rating in ratingArray) {
        
        AWSDynamoDBAttributeValue *att = [AWSDynamoDBAttributeValue new];
        att.S = rating.UserID;
        [attributes addObject:att];
//        [self.ratingDict setObject:rating.UserID forKey:@"UserID"];
//        [self.ratingDict setObject:rating.RatingStatus forKey:@""];
    }
    condition.comparisonOperator = AWSDynamoDBComparisonOperatorIN;
    condition.attributeValueList = attributes;
    NSDictionary *dictionary = @{@"UserID" : condition};
    
    
    AWSDynamoDBScanExpression *expression = [AWSDynamoDBScanExpression new];
    expression.scanFilter = dictionary;
    expression.limit = @(100);
    
    [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] scan:[GNUser class] expression:expression] continueWithBlock:^id(BFTask *task) {
        
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
            
            usersArray = [(AWSDynamoDBPaginatedOutput *)task.result items];
            NSMutableArray *tempArray = [NSMutableArray array];
            
            for (GNRating *rating in ratingArray) {
                rating.user = [usersArray objectAtIndex:[ratingArray indexOfObject:rating]];
                [tempArray addObject:rating];
            }
            
            [ratingArray removeAllObjects];
            ratingArray = [[NSMutableArray alloc]initWithArray:tempArray];
            
            [self performSelectorOnMainThread:@selector(setUserData) withObject:nil waitUntilDone:NO];
        }
        
        return task;
    }];
}



#pragma mark - UITableViewDatasource and Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedPost.Type == PostTypeMake(PostTypeGoNo)) {
        return 52;
    }
    else if (self.selectedPost.Type == PostTypeMake(PostTypeMultiPic)){
        return 75;
    }
    else if (self.selectedPost.Type == PostTypeMake(PostTypeRatePlace)){
        return 52;
    }
    else if (self.selectedPost.Type == PostTypeMake(PostTypeMultiAnswer)){
        return 100;
    }
    return 52;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch ([self.selectedPost.Type intValue]) {
        case PostTypeGoNo:
            return usersArray.count;
            break;
        case PostTypeMultiPic:
            return [self.selectedPost.NumberOfImages intValue];
            break;
        case PostTypeRatePlace:
            return usersArray.count;
            break;
        case PostTypeMultiAnswer:
            return [self.selectedPost.NumberOfAnswers intValue];
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StatTableViewCell *cell = [self.statsTableView dequeueReusableCellWithIdentifier:self.selectedPost.postType forIndexPath:indexPath];
    
    GNRating *rating;
    
    switch ([self.selectedPost.Type intValue]) {
        case PostTypeGoNo:
            rating = [ratingArray objectAtIndex:indexPath.row];
            break;
        case PostTypeMultiPic:
            
            break;
        case PostTypeRatePlace:
            rating = [ratingArray objectAtIndex:indexPath.row];
            break;
        case PostTypeMultiAnswer:
            
            break;
            
        default:
            break;
    }
    
    [cell setCellData:rating withType:self.selectedPost withIndexPath:indexPath withSubRate:[self perCellStat:indexPath]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.selectedPost.Type == PostTypeMake(PostTypeGoNo) || self.selectedPost.Type == PostTypeMake(PostTypeRatePlace))
    return 150;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.selectedPost.Type == PostTypeMake(PostTypeGoNo) || self.selectedPost.Type == PostTypeMake(PostTypeRatePlace)) {
        StatHeaderView  *header = [[[NSBundle mainBundle] loadNibNamed:@"StatHeaderView" owner:self options:nil] objectAtIndex:0];
        [header.labelReplyNumber setText:[NSString stringWithFormat:@"%lu",(unsigned long)ratingArray.count]];
        if (ratingArray.count > 0) {
            [self setupStatView:header.kLabelYes withProgressColor:[UIColor colorWithHexString:@"0ab0d6"] withSize:6 withAmout:[self getYesCount]/ratingArray.count];
            [self setupStatView:header.kLabelNo withProgressColor:[UIColor colorWithHexString:@"ed5e56"] withSize:6 withAmout:(ratingArray.count-[self getYesCount])/ratingArray.count];
        }
        return header;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (ratingArray && usersArray) {
        
        switch ([self.selectedPost.Type intValue]) {
            case PostTypeGoNo:
                break;
            case PostTypeMultiPic:{
                if (usersArray.count >0 && ratingArray.count > 0) {
                    UserMultiAnswersViewController * MVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowMultiUserDetail"];
                    [MVC setSelectedPost:self.selectedPost];
                    [MVC setSelectedIndex:(int)indexPath.row];
                    [MVC setAllRatings:ratingArray];
                    [MVC setAllUsers:usersArray];
                    [self.navigationController pushViewController:MVC animated:YES];
                }
            }
                break;
            case PostTypeRatePlace:
                break;
            case PostTypeMultiAnswer:{
                if (usersArray.count >0 && ratingArray.count > 0) {
                    UserMultiAnswersViewController * MVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowMultiUserDetail"];
                    [MVC setSelectedPost:self.selectedPost];
                    [MVC setSelectedIndex:(int)indexPath.row];
                    [MVC setAllRatings:ratingArray];
                    [MVC setAllUsers:usersArray];
                    [self.navigationController pushViewController:MVC animated:YES];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Override Main ViewController Methods

- (IBAction)backButtonTapped:(id)sender {
    [self setViewControllerClass:@"PostTypeMultiPic"];
    [super backButtonTapped:sender];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
