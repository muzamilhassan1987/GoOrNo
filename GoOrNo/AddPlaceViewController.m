//
//  AddPlaceViewController.m
//  GoOrNo
//
//  Created by O16 Labs on 20/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "AddPlaceViewController.h"
#import "UIPlacePicker.h"
#import "SelectedPlaceViewController.h"

@interface AddPlaceViewController ()<UIPlacePickerDelegate> {
  UIPlacePicker *_picker;
  SelectedPlaceViewController * _placeController;
}

@end

@implementation AddPlaceViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.post.Type = PostTypeMake(PostTypeRatePlace);
  [self setNavigationBackgroundColor:[UIColor greenColor] titleColor:[UIColor whiteColor]];
  self.title = @"Rate a Place";
}

- (IBAction)btnAddPlaceTapped:(id)sender {
  _picker = [[UIPlacePicker alloc] initWithUIPlace:_placeController.place];
  _picker.delegate = self;
  [self presentViewController:_picker animated:YES completion:^{
    
  }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"EmbedSegue"]) {
    SelectedPlaceViewController *embed = segue.destinationViewController;
    _placeController = embed;
  }
}


#pragma mark Place Picker delegate
-(void)placePickerDidSelectPlace:(UIPlace *)__place {
  
  if (!_placeController.place) {
    
    [_btnAddPlace setImage:nil forState:UIControlStateNormal];
    [_btnAddPlace setBackgroundColor:[UIColor clearColor]];
  }
  _placeController.place = __place;
  self.post.PlaceAddress = __place.completeAddress;
  self.post.Latitude = [NSNumber numberWithDouble:__place.location.coordinate.latitude];
  self.post.Longitude = [NSNumber numberWithDouble:__place.location.coordinate.longitude];
  [self hidePlacePicker];
}

-(void)placePickerDidCancel{
  [self hidePlacePicker];
}

-(void)hidePlacePicker{
  [_picker dismissViewControllerAnimated:YES completion:^{
    
  }];
}

- (void)btnGoTapped:(id)sender {
  [self.view endEditing:YES];
  [SVProgressHUD show];
  
  // Save Image To AWS S3
  [super btnGoTapped:sender];
  
  [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:self.post]
   continueWithBlock:^id(BFTask *task) {
     if (task.error) {
       NSLog(@"The request failed. Error: [%@]", task.error);
       dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD showErrorWithStatus:task.error.localizedDescription];
       });
     }
     if (task.exception) {
       NSLog(@"The request failed. Exception: [%@]", task.exception);
       dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD showErrorWithStatus:@"Failed. Exception occured"];
       });
     }
     if (task.result) {
       //Do something with the result.
         
         NSMutableArray *deviceTokens = [NSMutableArray new];
         
         NSArray *ids = [self.post.InvitedUsers componentsSeparatedByString:@","];
         for (NSString *uid in ids) {
             
             GNUser *user = [self.selectedUsers objectForKey:uid];
             if(user.DeviceToken != nil)
                 [deviceTokens addObject:user.DeviceToken];
             
             GNNotification *notification = [[GNNotification alloc] init];
             notification.InviteeID = uid;
             notification.NotificationID = [[NSUUID UUID] UUIDString];
             notification.InviterName = [[[ApplicationData sharedInstance] currentUser] Name];
             notification.PostID = self.post.PostID;
             [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:notification] continueWithBlock:^id(BFTask *task) {
                 
                 return task;
             }];
             
             
         }
         
         NSMutableDictionary *apnsParams = [NSMutableDictionary dictionary];
         NSString *message = [NSString stringWithFormat:@"%@ invited you to suggest on his ruling", [[ApplicationData sharedInstance].currentUser Name]];
         
         NSData *data = [NSJSONSerialization dataWithJSONObject:deviceTokens options:0 error:nil];
         NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         [apnsParams setObject:str forKey:@"deviceTokens"];
         [apnsParams setObject:message forKey:@"message"];
         [apnsParams setObject:@{@"UserID" : [[ApplicationData sharedInstance].currentUser UserID],
                                 @"PostID" : [self.post PostID]} forKey:@"arguments"];
         
         [self performSelectorOnMainThread:@selector(sendNotificationToUsersWithParameters:)
                                withObject:apnsParams
                             waitUntilDone:true];
       dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD showSuccessWithStatus:@"Saved"];
         [self.navigationController popViewControllerAnimated:YES];
       });
     }
     return nil;
   }];
}

@end
