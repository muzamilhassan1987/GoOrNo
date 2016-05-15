//
//  EmailLoginViewController.m
//  GoOrNo
//
//  Created by Kumar on 07/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "EmailLoginViewController.h"
#import "GNUser.h"
#import "AmazonClientManager.h"

@interface EmailLoginViewController ()

@end

@implementation EmailLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
#ifdef DEBUG
  self.txtEmail.text = @"user1@goorno.com";
  self.txtName.text = @"Email Test User";
  self.txtPassword.text = @"1234";
#endif
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

- (IBAction)btnSignupTapped:(id)sender {
  
  // Text Validation
  BOOL dataIsValid = YES;
  NSString *textValidationMessage = nil;
  if(dataIsValid) {
    
    for (UITextField *field in [self.view subviews]) {
      if ([field isKindOfClass:[UITextField class]]) {
        if (!field.text || ([field.text isEqualToString:@""])) {
          dataIsValid = NO;
          textValidationMessage = [NSString stringWithFormat:@"Missing Field: %@",field.placeholder];
          break;
        }
      }
    }
  }
  
  if (dataIsValid) {
    //Post data or do what you want
    [self createOrUpdateUserWithEmail:self.txtEmail.text];
  }
}

- (void)createOrUpdateUserWithEmail:(NSString *)email {
  // Login
  NSLog(@"Amazon Unauthenticated Login");
  AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
  // Create
  GNUser * newUser = [GNUser new];
  newUser.UserID = [NSString stringWithFormat:@"email_%@",email];
  newUser.Email = email;
  newUser.Name = self.txtName.text;
  newUser.Password = self.txtPassword.text;
  
  [[dynamoDBObjectMapper load:[GNUser class] hashKey:newUser.UserID rangeKey:nil]
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
       NSLog(@"Get User: [%@]", task.result);
       // User is already logged in, do work such as go to next view controller.
       GNUser * oldUser = task.result;
       
       if(!oldUser.UserID) {
         [[dynamoDBObjectMapper save:newUser]
          continueWithBlock:^id(BFTask *task) {
            if (task.error) {
              NSLog(@"The request failed. Error: [%@]", task.error);
            }
            if (task.exception) {
              NSLog(@"The request failed. Exception: [%@]", task.exception);
            }
            if (task.result) {
              //Do something with the result.
              NSLog(@"Created: [%@]", task.result);
              [ApplicationData sharedInstance].currentUser = (GNUser *)task.result;
                [ApplicationData sharedInstance].currentUser.UserType = @(UserTypeRegistered);
              // User is already logged in, do work such as go to next view controller.
              AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
              delegate.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
            }
            return nil;
          }];
       } else if ([newUser.Password isEqualToString:oldUser.Password]){
         [[dynamoDBObjectMapper save:oldUser]
          continueWithBlock:^id(BFTask *task) {
            if (task.error) {
              NSLog(@"The request failed. Error: [%@]", task.error);
              dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:task.error.localizedDescription];
              });
            }
            if (task.exception) {
              NSLog(@"The request failed. Exception: [%@]", task.exception);
            }
            if (task.result) {
              //Do something with the result.
              NSLog(@"Created: [%@]", task.result);
              [ApplicationData sharedInstance].currentUser = (GNUser *)task.result;
                [ApplicationData sharedInstance].currentUser.UserType = @(UserTypeRegistered);
              // User is already logged in, do work such as go to next view controller.
              AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
              delegate.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
            }
            return nil;
          }];
       }
       
     }
     return nil;
   }];
  
}
@end
