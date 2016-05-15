//
//  LoginViewController.m
//  GoOrNo
//
//  Created by Kumar on 07/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "LoginViewController.h"
#import "AmazonClientManager.h"
#import "GNUser.h"

@interface LoginViewController ()<FBSDKLoginButtonDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.btnFacebookLogin.readPermissions = @[@"public_profile", @"email", @"user_friends"];
  self.btnFacebookLogin.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [LoginViewController loginWithFacebookIfPossible];
}

+ (void)loginWithFacebookIfPossible {
  FBSDKAccessToken * accessToken = [FBSDKAccessToken currentAccessToken];
  if (accessToken != nil) {
    // Enable AWS Logging
    [AWSLogger defaultLogger].logLevel = AWSLogLevelVerbose;
    [self loginWithFacebookTokenString:accessToken.tokenString];
  }
}

+ (void)loginWithFacebookTokenString:(NSString *)tokenString {
  // Initialize the Amazon Cognito credentials provider
  NSDictionary * logins = @{ @(AWSCognitoLoginProviderKeyFacebook) : tokenString };
  // Retrieve your Amazon Cognito ID.
  [[AmazonClientManager sharedInstance] completeLogin:logins completionHandler:^id(BFTask *task) {
    // Login
    NSLog(@"Amazon Cognito Login");
    NSString *cognitoId = [[AmazonClientManager sharedInstance] credentialsProvider].identityId;
    if(cognitoId) {
      // Create or Get User
      [self createOrUpdateUserWithFacebookTokenString:tokenString cognitoID:cognitoId];
    } else {
      NSLog(@"AWS Congnito Login Failed but Facebook Login Successful");
    }
    return task;
  }];
}

+ (void)createOrUpdateUserWithFacebookTokenString:(NSString *)tokenString cognitoID:(NSString *)cognitoID {
  AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
  [manager GET:@"https://graph.facebook.com/me" parameters:@{@"access_token":tokenString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    GNUser * newUser = [GNUser new];
    newUser.UserID = [NSString stringWithFormat:@"fb_%@",responseObject[@"id"]];
    newUser.FacebookID = [NSString stringWithFormat:@"fb_%@",responseObject[@"id"]];
    newUser.Name = responseObject[@"name"];
    newUser.CognitoID = cognitoID;
    
    [[dynamoDBObjectMapper load:[GNUser class] hashKey:newUser.UserID rangeKey:nil]
     continueWithBlock:^id(BFTask *task) {
       if (task.error) {
         NSLog(@"The request failed. Error: [%@]", task.error);
       }
       if (task.exception) {
         NSLog(@"The request failed. Exception: [%@]", task.exception);
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
                [SVProgressHUD dismiss];
                //Do something with the result.
                NSLog(@"Created: [%@]", task.result);
                [ApplicationData sharedInstance].currentUser = newUser;
//                [newUser saveInUserDefaultsWithKey:AppUserKey];
              }
              return nil;
            }];
         } else {
           [SVProgressHUD dismiss];
           [ApplicationData sharedInstance].currentUser = oldUser;
//           [oldUser saveInUserDefaultsWithKey:AppUserKey];
         }
         
       }
       return nil;
     }];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Facebook Get User Profile Error: %@", error);
  }];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
  
  NSLog(@"Login With Facebook Tapped");
  if (error) {
    // Handle Error
  } else if (result.isCancelled) {
    // Handle Cancelation
  } else {
    [[self class] loginWithFacebookTokenString:result.token.tokenString];
  }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
  NSLog(@"Logout Facebook");
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

- (IBAction)btnSignInNowTapped:(UIButton *)sender {
  self.formSheetController.didDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
    
  };
  [self.formSheetController mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    if (_delegate && [_delegate respondsToSelector:@selector(loginViewController:dismissedPopoverWithAction:)]) {
      [_delegate loginViewController:self dismissedPopoverWithAction:LoginPopoverDismissActionLogin];
    }
  }];
}

- (IBAction)btnCloseTapped:(UIButton *)sender {
  self.formSheetController.didDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
    
  };
  [self.formSheetController dismissAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    if (_delegate && [_delegate respondsToSelector:@selector(loginViewController:dismissedPopoverWithAction:)]) {
      [_delegate loginViewController:self dismissedPopoverWithAction:LoginPopoverDismissActionNone];
    }
  }];
}

- (IBAction)btnLoginWithFacebook:(id)sender {
  self.formSheetController.didDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
    
  };
  [self.formSheetController dismissAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    if (_delegate && [_delegate respondsToSelector:@selector(loginViewController:dismissedPopoverWithAction:)]) {
      [_delegate loginViewController:self dismissedPopoverWithAction:LoginPopoverDismissActionFacebookLogin];
    }
  }];
}

- (IBAction)btnSignupWithEmail:(UIButton *)sender {
  self.formSheetController.didDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
    
  };
  [self.formSheetController dismissAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    if (_delegate && [_delegate respondsToSelector:@selector(loginViewController:dismissedPopoverWithAction:)]) {
      [_delegate loginViewController:self dismissedPopoverWithAction:LoginPopoverDismissActionEmailSignUp];
    }
  }];
}

- (IBAction)btnSignupWithPhone:(UIButton *)sender {
  self.formSheetController.didDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
    
  };
  [self.formSheetController dismissAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    if (_delegate && [_delegate respondsToSelector:@selector(loginViewController:dismissedPopoverWithAction:)]) {
      [_delegate loginViewController:self dismissedPopoverWithAction:LoginPopoverDismissActionPhoneSignUp];
    }
  }];
}
@end
