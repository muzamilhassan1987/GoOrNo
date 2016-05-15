//
//  VerifyCodeViewController.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 08/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "VerifyCodeViewController.h"
#import "AppDelegate.h"

@interface VerifyCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtVerificationCode;

@end

@implementation VerifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnVerifyTapped:(id)sender {
  AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
  delegate.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
}
- (IBAction)btnResendTapped:(id)sender {
  // TODO: Resend Code Websevice
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
