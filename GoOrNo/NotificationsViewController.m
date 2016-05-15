//
//  NotificationsViewController.m
//  GoOrNo
//
//  Created by Asif Ali on 06/06/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NewsFeedViewController.h"

@interface NotificationsViewController ()
{
    __weak IBOutlet UITableView *notificationsTableView;
    NSMutableArray *notificatonsArray;
}
@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Notifications"];
    notificatonsArray = [NSMutableArray new];
    [self getNotifications];
}

-(void) getNotifications {
    
    AWSDynamoDBCondition *condition = [AWSDynamoDBCondition new];
    AWSDynamoDBAttributeValue *attribute = [AWSDynamoDBAttributeValue new];
    
    attribute.S = [ApplicationData sharedInstance].currentUser.UserID;

    
    condition.comparisonOperator = AWSDynamoDBComparisonOperatorIN;
    condition.attributeValueList = @[attribute];
    NSDictionary *dictionary = @{@"InviteeID" : condition};
    
    //    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    
    AWSDynamoDBScanExpression *expression = [AWSDynamoDBScanExpression new];
    expression.scanFilter = dictionary;
    expression.limit = @(100);
    
    //    query.indexName = @"userid-index";
    //    query.tableName = @"Users";
    //    query.keyConditions = dictionary;
    
    
    [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] scan:[GNNotification class]
                                                            expression:expression]
     continueWithBlock:^id(BFTask *task) {
         
         if (task.error) {
             [SVProgressHUD showErrorWithStatus:[task.error localizedDescription]];
         }
         if (task.exception) {
             [SVProgressHUD showErrorWithStatus:[task.exception reason]];
         }
         if (task.result) {
             
             NSLog(@"result users:%@", task.result);
             AWSDynamoDBPaginatedOutput *output = task.result;
             for (GNNotification *notification in output.items) {
                 
                 [notificatonsArray addObject:notification];
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [notificationsTableView reloadData];
             });
             
         }
         return task;
     }];
}

#pragma mark UITableView delegate & datasource

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [notificatonsArray count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell"
                                                            forIndexPath:indexPath];
    
    GNNotification *notifcation = notificatonsArray[indexPath.row];
    UILabel *label = (UILabel *) [cell.contentView viewWithTag:9];
    
    NSString *constantString = @"inivited you to suggest on his Ruling";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", [notifcation.InviterName capitalizedString], constantString]];

    NSDictionary *attrs = @{ NSForegroundColorAttributeName : [UIColor blackColor],
                             NSFontAttributeName : [UIFont fontWithName:@"Verdana" size:13.0]};
    [attributedString addAttributes:attrs range:NSMakeRange(0, [notifcation.InviterName length] - 1)];
    
    NSDictionary *attrs2 = @{ NSForegroundColorAttributeName : [UIColor darkGrayColor],
                             NSFontAttributeName : [UIFont fontWithName:@"Verdana" size:12.0]};
    [attributedString addAttributes:attrs2 range:NSMakeRange([notifcation.InviterName length] + 1, [constantString length])];
    
    [label setAttributedText:attributedString];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GNNotification *notifcation = notificatonsArray[indexPath.row];
    
    NewsFeedViewController *feedsController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsFeedViewController1"];
    feedsController.showSelectedPost = YES;
    feedsController.selectedPostID = notifcation.PostID;
    [self.navigationController pushViewController:feedsController animated:YES];
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
