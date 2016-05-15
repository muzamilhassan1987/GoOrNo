//
//  ViewController.h
//  GoOrNo
//
//  Created by Kumar on 07/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+GoOrNoAdditions.h"

@interface ViewController : UIViewController

- (BOOL) isRegisteredUser;
- (void) showAddButton;
- (void) addCreatePostsButton;
- (void)setViewControllerClass:(NSString*)styleClass;

@end

