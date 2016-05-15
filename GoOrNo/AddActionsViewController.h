//
//  AddActionsViewController.h
//  GoOrNo
//
//  Created by O16 Labs on 28/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"

typedef enum AddActionOption {
    
    AddGoOrNoAction,
    AddMultiPicAction,
    AddMultiAnswerAction,
    AddRateAPlaceAction,
    AddCancelAction
} AddAction;

@protocol AddActionsViewControllerDelegate <NSObject>

-(void) addActionControllerDidDismissWithOption:(AddAction) option;

@end


@interface AddActionsViewController : ViewController <LoginViewControllerDelegate>

@property (nonatomic, strong) id<AddActionsViewControllerDelegate> delegate;

@end
