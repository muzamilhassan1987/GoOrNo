//
//  FormLoginViewController.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 25/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "TableViewController.h"

@interface FormLoginViewController : TableViewController

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnSignInTapped:(UIButton *)sender;
@end
