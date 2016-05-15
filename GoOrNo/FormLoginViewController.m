//
//  FormLoginViewController.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 25/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "FormLoginViewController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface FormLoginViewController ()

@end

@implementation FormLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self setNavigationBackgroundColor:[UIColor blackColor] titleColor:[UIColor whiteColor]];
  [self setBackButton];
  self.title = @"Sign In";
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.txtEmail becomeFirstResponder];
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

- (IBAction)btnSignInTapped:(UIButton *)sender {
  NSArray * subviews = self.view.subviews;
  NSString * validationMessage = nil;
  BOOL dataIsValid = YES;
  if (dataIsValid) {
    // All fields are filled
    for (UITextField * view in subviews) {
      if ([view isKindOfClass:[UITextField class]]) {
        if ([view.text isEmptyOrNSNull]) {
          validationMessage = [NSString stringWithFormat:@"Missing: %@",view.placeholder];
          dataIsValid = NO;
          break;
        }
      }
    }
  }
  if (dataIsValid) {
    if (![self.txtEmail.text isValidEmailAddress]) {
      validationMessage = @"Email is not valid";
      dataIsValid = NO;
    }
  }
  if (dataIsValid) {
    [self signIn];
  } else {
    [SVProgressHUD showErrorWithStatus:validationMessage];
  }
}
- (void)signIn {
  [SVProgressHUD show];
  GNUser * user = [GNUser new];
  user.Email = self.txtEmail.text;
  user.Password = self.txtPassword.text;
  user.UserID = [NSString stringWithFormat:@"email_%@",self.txtEmail.text];
  [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] load:[GNUser class] hashKey:user.UserID rangeKey:nil] continueWithBlock:^id(BFTask *task) {
    if (task.error) {
      NSLog(@"The request failed. Error: [%@]", task.error);
      dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:@"Failed. Error Occured"];
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
      GNUser * loginUser = (GNUser *)task.result;
      dispatch_async(dispatch_get_main_queue(), ^{
        if (loginUser.UserID==nil || [loginUser.UserID isEmptyOrNSNull]) {
          [SVProgressHUD showErrorWithStatus:@"User doesn't exists"];
        } else if ([loginUser.Password isEqualToString:user.Password]) {
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults rm_setCustomObject:loginUser forKey:@"SAVED_DATA"];
            
            [ApplicationData sharedInstance].currentUser = loginUser;
//          [loginUser saveInUserDefaultsWithKey:AppUserKey];
          [SVProgressHUD showSuccessWithStatus:@"Login Successful"];
          [self.navigationController popViewControllerAnimated:YES];
        } else {
          [SVProgressHUD showSuccessWithStatus:@"Invalid Password"];
        }
      });
    }
    return nil;
  }];
}
@end
