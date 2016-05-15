//
//  LoginViewController.h
//  GoOrNo
//
//  Created by Kumar on 07/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ViewController.h"
@class LoginViewController;

typedef enum : NSInteger {
  LoginPopoverDismissActionNone = 0,
  LoginPopoverDismissActionFacebookLogin = 1,
  LoginPopoverDismissActionEmailSignUp = 2,
  LoginPopoverDismissActionPhoneSignUp = 4,
  LoginPopoverDismissActionLogin = 8
} LoginPopoverDismissAction;

@protocol LoginViewControllerDelegate <NSObject>
@required
- (void)loginViewController:(LoginViewController *)controller
 dismissedPopoverWithAction:(LoginPopoverDismissAction)action;
@end

@interface LoginViewController : ViewController

@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *btnFacebookLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnEmailSignup;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoneLogin;
@property (weak, nonatomic) id<LoginViewControllerDelegate> delegate;

+ (void)loginWithFacebookIfPossible;

- (IBAction)btnSignInNowTapped:(UIButton *)sender;
- (IBAction)btnCloseTapped:(UIButton *)sender;
- (IBAction)btnLoginWithFacebook:(id)sender;
- (IBAction)btnSignupWithEmail:(UIButton *)sender;
- (IBAction)btnSignupWithPhone:(UIButton *)sender;

@end
