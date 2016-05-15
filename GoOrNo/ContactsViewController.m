//
//  ContactsViewController.m
//  GoOrNo
//
//  Created by Asif Ali on 05/06/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ContactsViewController.h"
#import <APAddressBook.h>
#import <APContact.h>
#import <MessageUI/MessageUI.h>
#import "ContactCell.h"
#import "AddBaseViewController.h"

@interface ContactsViewController () <UITableViewDataSource, UITableViewDelegate, ContactCellDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    NSMutableArray *contactsArray;
    NSMutableArray *selectedIndexes;
}

@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackButton];
    [self addSaveButtonInNavigationBar];
    [self getAllContacts];
    selectedIndexes = [NSMutableArray array];
    [self setTitle:@"Contacts"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveButtonPressed:(id)sender {
    
    if ([selectedIndexes count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"Please select atleast one contact to invite"];
        return;
    }
    
    NSMutableArray *users = [NSMutableArray new];
    NSMutableDictionary *usersData = [NSMutableDictionary new];
    
    for (NSNumber *index in selectedIndexes) {
        
        [users addObject:[contactsArray[index.intValue] UserID]];
        [usersData setObject:contactsArray[index.intValue] forKey:[contactsArray[index.intValue] UserID]];
    }
    [self.addPostController contactsPickerDidSelectContacts:usersData];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) getAllContacts {
    
    APAddressBook *addressBook = [[APAddressBook alloc] init];
    addressBook.fieldsMask = APContactFieldEmails | APContactFieldPhones | APContactFieldFirstName | APContactFieldLastName;
    addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0 || contact.emails.count > 0;
    };
    // don't forget to show some activity
    [addressBook loadContacts:^(NSArray *contacts, NSError *error)
     {
         // hide activity
         if (!error)
         {
             NSLog(@"contacts:%@", contacts);
             contactsArray = [NSMutableArray arrayWithArray:contacts];
             [self.contactsTableView reloadData];
             [self queryAppUsers];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
         }
     }];
}

-(void) queryAppUsers {
    
    NSMutableArray *phoneNumbers = [NSMutableArray new];
    
    AWSDynamoDBCondition *condition = [AWSDynamoDBCondition new];
    AWSDynamoDBAttributeValue *attribute = [AWSDynamoDBAttributeValue new];
    
    attribute.S = @"111000";
    [phoneNumbers addObject:attribute];
    for (APContact *contact in contactsArray) {
        
        if ([contact.phones count] > 0) {
            AWSDynamoDBAttributeValue *attribute = [AWSDynamoDBAttributeValue new];
            attribute.S = [Utility trimSpacesAndCharactersFromPhoneNumber:[contact.phones firstObject]];
            [phoneNumbers addObject:attribute];
        }
        
    }
    
    condition.comparisonOperator = AWSDynamoDBComparisonOperatorIN;
    condition.attributeValueList = phoneNumbers;
    NSDictionary *dictionary = @{@"Phone" : condition};

//    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    
    AWSDynamoDBScanExpression *expression = [AWSDynamoDBScanExpression new];
    expression.scanFilter = dictionary;
    expression.limit = @(100);
    
//    query.indexName = @"userid-index";
//    query.tableName = @"Users";
//    query.keyConditions = dictionary;
    
    
    [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] scan:[GNUser class]
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
            for (GNUser *user in output.items) {
                
                [contactsArray insertObject:user atIndex:0];
            }
            [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:true];
        }
        return task;
    }];
}

-(void) reloadTable {
    [self.contactsTableView reloadData];
}

#pragma mark UITableView delegate & datasource

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [contactsArray count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    
    if ([[contactsArray objectAtIndex:indexPath.row] isKindOfClass:[APContact class]]) {
        
        APContact *contact = contactsArray[indexPath.row];
        
        cell.nameLabel.text = contact.firstName;
        cell.phoneLabel.text = [contact.phones lastObject];
        [cell.inviteButton setHidden:NO];
    }
    else if ([[contactsArray objectAtIndex:indexPath.row] isKindOfClass:[GNUser class]]) {
        
        GNUser *user = contactsArray[indexPath.row];
        
        cell.nameLabel.text = user.Name;
        cell.phoneLabel.text = user.Phone.length == 0 ? user.Email : user.Phone;
        [cell.inviteButton setHidden:YES];
    }
    
    __weak id weakSelf = self;
    cell.delegate = weakSelf;
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[contactsArray objectAtIndex:indexPath.row] isKindOfClass:[GNUser class]]) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (![selectedIndexes containsObject:@(indexPath.row)]) {
            [selectedIndexes addObject:@(indexPath.row)];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else {
            [selectedIndexes removeObject:@(indexPath.row)];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        
    }
    
}

-(void) inviteButtonDidPressed:(id)cell {
    
    NSIndexPath *index = [self.contactsTableView indexPathForCell:cell];
    APContact *contact = contactsArray[index.row];
    if ([contact.emails count] > 0 && [contact.phones count] > 0) {
        
        NSArray * buttons = @[@"via SMS", @"via Email"];

        
        [RMUniversalAlert showActionSheetInViewController:self
                                                withTitle:@"Select Option"
                                                  message:nil
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:buttons
                       popoverPresentationControllerBlock:nil
                                                 tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex) {
                                                     
                                                     if (buttonIndex == 2) {
                                                         
                                                         [self sendSMS:contact.phones];
                                                     }
                                                     else if (buttonIndex == 3) {
                                                         
                                                         [self sendEmail:contact.emails];
                                                     }
                                                 }];
    }
    else if([contact.phones count] > 0) {
        
        [self sendSMS:contact.phones];
    }
    else if([contact.emails count] > 0) {
        
        [self sendEmail:contact.emails];
    }
    else {
        NSLog(@"Error occured in invite");
    }
}

-(void) sendSMS:(NSArray *) phoneNumbers {
    
    if(![MFMessageComposeViewController canSendText]) {
        [SVProgressHUD showErrorWithStatus:@"SMS is not supported on your device"];
        return;
    }
    
    MFMessageComposeViewController *messageComposer = [[MFMessageComposeViewController alloc] init];
    messageComposer.recipients = phoneNumbers;
    messageComposer.body = @"Hi There, Please download Go Or No App and vote on my post";
    messageComposer.messageComposeDelegate = self;
    [self presentViewController:messageComposer animated:YES completion:nil];
}

#pragma MFMessageComposeViewController delegate
-(void) messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) sendEmail:(NSArray *) emails {
    
    if(![MFMailComposeViewController canSendMail]) {
        [SVProgressHUD showErrorWithStatus:@"Can not send mail, please make sure you have configured the email settings"];
        return;
    }
    
    MFMailComposeViewController *messageComposer = [[MFMailComposeViewController alloc] init];
    [messageComposer setToRecipients: emails];
    [messageComposer setMessageBody:@"Hi There, Please download Go Or No App and vote on my post"
                             isHTML:NO];
    
    messageComposer.mailComposeDelegate = self;
    [self presentViewController:messageComposer animated:YES completion:nil];
}

#pragma MFMailComposeViewController delegate
-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
