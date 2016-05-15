//
//  EmailLoginViewController.h
//  GoOrNo
//
//  Created by Kumar on 07/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ViewController.h"

@interface EmailLoginViewController : ViewController

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnSignupTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPass;
@end
