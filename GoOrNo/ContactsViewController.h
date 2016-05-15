//
//  ContactsViewController.h
//  GoOrNo
//
//  Created by Asif Ali on 05/06/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ViewController.h"

@class AddBaseViewController;
@interface ContactsViewController : ViewController

@property (nonatomic, strong) AddBaseViewController *addPostController;

-(IBAction)saveButtonPressed:(id)sender;
@end
