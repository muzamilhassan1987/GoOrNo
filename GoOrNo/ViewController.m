//
//  ViewController.m
//  GoOrNo
//
//  Created by Kumar on 07/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#include "FormEmailSignupViewController.h"
#include "FormPhoneSignupViewController.h"
#import "FormLoginViewController.h"
#import "UIViewController+GoOrNoAdditions.h"
#import "AddActionsViewController.h"
#import "NewsFeedViewController.h"
#import "AddBaseViewController.h"
#import "EmailLoginViewController.h"
#import "SignupContainerViewController.h"

@interface ViewController ()<LoginViewControllerDelegate, AddActionsViewControllerDelegate>
{
    UIButton *addPostButton;
}

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
    if (![self isKindOfClass:[NewsFeedViewController class]]) {
        
        [self addFeedsButon];
    }
    if ([self isKindOfClass:[AddBaseViewController class]]
        || [self isKindOfClass:[TableViewController class]]) {
        
        [self hideAddButton];
    }
    else {
        [self addCreatePostsButton];
    }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)setViewControllerClass:(NSString *)cls {
    if (![cls isEqualToString:self.view.styleClass]) {
        self.navigationController.navigationBar.styleClass = cls;
        [self.navigationController.navigationBar updateStylesAsync];

        self.navigationController.toolbar.styleClass = cls;
        [self.navigationController.toolbar updateStylesAsync];

        self.view.styleClass = cls;
        [self.view updateStylesAsync];
    }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - LoginViewControllerDelegate
- (void)loginViewController:(LoginViewController *)controller dismissedPopoverWithAction:(LoginPopoverDismissAction)action {
  switch (action) {
    case LoginPopoverDismissActionEmailSignUp:
    {
      NSLog(@"Email Signup");
      FormEmailSignupViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FormEmailSignupViewController"];
      [self.navigationController pushViewController:controller animated:YES];
      break;
    }
    case LoginPopoverDismissActionPhoneSignUp:
    {
      NSLog(@"Phone Signup");
      FormPhoneSignupViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FormPhoneSignupViewController"];
      [self.navigationController pushViewController:controller animated:YES];
      break;
    }
    case LoginPopoverDismissActionLogin:
    {
      NSLog(@"Login");
      FormLoginViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FormLoginViewController"];
      [self.navigationController pushViewController:controller animated:YES];
      break;
    }
    case LoginPopoverDismissActionFacebookLogin:
    {
      NSLog(@"Facebook Login");
      break;
    }
    case LoginPopoverDismissActionNone:
    {
        if ([GNUser loadUserFromDefaults]) {
            [ApplicationData sharedInstance].currentUser = [GNUser loadUserFromDefaults];
        }
        else if (![GNUser checkIfUserIsLoggedIn]) {
            
            GNUser *anonymous = [GNUser createAnonymousUser];
            [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:[GNUser createAnonymousUser]] continueWithBlock:^id(BFTask *task) {
                
                if (task.result) {
                    
                    [ApplicationData sharedInstance].currentUser = anonymous;
                    [GNUser saveUser:[[ApplicationData sharedInstance] currentUser]];
                    
                }
                
                return task;
            }];
        }
        else {
            
        }
        
      break;
    }
      
    default:
      break;
  }
}


-(void) addCreatePostsButton {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    if (!addPostButton) {
        
        addPostButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addPostButton setFrame:CGRectMake(screenSize.width / 2 - 20, screenSize.height - 100, 40, 40)];
//        [addPostButton setTitle:@"Add" forState:UIControlStateNormal];
        [addPostButton setBackgroundColor:[UIColor clearColor]];
        [addPostButton setBackgroundImage:[UIImage imageNamed:@"button_addPosts"]
                                 forState:UIControlStateNormal];
        [addPostButton addTarget:self
                          action:@selector(addPostButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addPostButton];
    }
    
    
}

-(void) showAddButton {
    
    [self.navigationController.view bringSubviewToFront:addPostButton];
    [addPostButton setHidden:NO];
}

-(void) hideAddButton {
    
    [addPostButton setHidden:YES];
}

-(void) addPostButtonPressed:(id) sender {
    
    if (![self isRegisteredUser]) {
        [self showLoginPopoverWithDelegate:self
                                completion:nil];
        return;
    }
    
    [self showCreatePostOptionsWithDelegate:self completion:nil];
}

#pragma mark AddActionViewController delegate
-(void) addActionControllerDidDismissWithOption:(AddAction)option {
    
    switch (option) {
        case AddGoOrNoAction:
            [self showControllerWithStoryboardID:@"AddGoorNoViewController"];
            break;
        case AddMultiPicAction:
            [self showControllerWithStoryboardID:@"AddMultiPicViewController"];
            break;
        case AddMultiAnswerAction:
            [self showControllerWithStoryboardID:@"AddMultiAnswerViewController"];
            break;
        case AddRateAPlaceAction:
            [self showControllerWithStoryboardID:@"AddPlaceViewController"];
            break;
        case AddCancelAction:
            
            break;
            
        default:
            break;
    }
}

-(BOOL) isRegisteredUser {
    
    if (![GNUser checkIfUserIsLoggedIn] && [ApplicationData sharedInstance].showLoginDialog) {
        
        [ApplicationData sharedInstance].showLoginDialog = NO;
        return NO;
    }
    if ([GNUser checkForAnonymousUser] && [ApplicationData sharedInstance].showLoginDialog) {
        
        [ApplicationData sharedInstance].showLoginDialog = NO;
        return NO;
    }
    
    return YES;
}

#pragma mark Private

- (void)showControllerWithStoryboardID:(NSString *)storyboardId {
    
    BOOL allLoaded = [[ApplicationData sharedInstance] allCategoriesQuestionAndAnswerAreLoaded];
    if (!allLoaded) {
        //Will automatically load categories, question & answers
    } else if ([[ApplicationData sharedInstance] currentUser] && allLoaded) {
        UIViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:storyboardId];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [self showLoginPopoverWithDelegate:self completion:nil];
    }
}

@end
