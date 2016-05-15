//
//  FormPhoneSignupViewController.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 25/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "FormPhoneSignupViewController.h"

#import "FormVerifyCodeViewController.h"

@interface FormPhoneSignupViewController ()

@end

@implementation FormPhoneSignupViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self setNavigationBackgroundColor:[UIColor blackColor] titleColor:[UIColor whiteColor]];
  [self setBackButton];
  self.title = @"Sign Up";
}
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.txtName becomeFirstResponder];
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

- (IBAction)btnSignupTapped:(UIButton *)sender {
    
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
        if (![self.txtMobile.text isNumeric]) {
            validationMessage = @"Phone number is not valid";
            dataIsValid = NO;
        }
    }
    if (dataIsValid) {
        if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text]) {
            validationMessage = @"Passwords don't match";
            dataIsValid = NO;
        }
    }
    if (dataIsValid) {
        [self signUp];
    } else {
        [SVProgressHUD showErrorWithStatus:validationMessage];
    }

}


- (void)signUp {
    
    [SVProgressHUD show];
    
    GNUser * newUser    = [GNUser new];
    newUser.Name        = self.txtName.text;
    newUser.Email       = self.txtEmail.text;
    newUser.Password    = self.txtPassword.text;
    newUser.Phone       = self.txtMobile.text;
    newUser.VerificationCode = @(1111);
    newUser.IsVerified  = @(0);
    newUser.UserID      = [NSString stringWithFormat:@"email_%@",self.txtEmail.text];
    newUser.DeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenKey];
    
    [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:newUser] continueWithBlock:^id(BFTask *task) {
        {
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
                [ApplicationData sharedInstance].currentUser = newUser;
                //        [newUser saveInUserDefaultsWithKey:AppUserKey];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showSuccessWithStatus:@"User Created"];
                    
                    FormVerifyCodeViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FormVerifyCodeViewController"];
                    [self.navigationController pushViewController:controller animated:YES];
                    
                });
            }
            return nil;
        }
    }];
}

@end
