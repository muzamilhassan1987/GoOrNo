//
//  FormVerifyCodeViewController.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 25/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "FormVerifyCodeViewController.h"

@interface FormVerifyCodeViewController ()

@end

@implementation FormVerifyCodeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self setNavigationBackgroundColor:[UIColor blackColor] titleColor:[UIColor whiteColor]];
  [self setBackButton];
  self.title = @"Sign Up";
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.txtVerificationCode becomeFirstResponder];
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

- (IBAction)btnVerifyTapped:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    GNUser *user = [ApplicationData sharedInstance].currentUser;
    user.IsVerified = @(1);
    AWSDynamoDBObjectMapperConfiguration *config = [AWSDynamoDBObjectMapperConfiguration new];
    
    config.saveBehavior = AWSDynamoDBObjectMapperSaveBehaviorUpdate;
    
    
    [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:user configuration:config] continueWithBlock:^id(BFTask *task) {
        
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
                
                [SVProgressHUD showSuccessWithStatus:@"You have been successfully registered"];
                [self performSelectorOnMainThread:@selector(popToMainController)
                                       withObject:nil
                                    waitUntilDone:true];
            }
        
        return task;
    }];
}

-(void) popToMainController {
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
}
@end
