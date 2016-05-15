//
//  AddBaseViewController.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 16/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ViewController.h"

#import "GNPost.h"

@interface AddBaseViewController : ViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)btnGoTapped:(id)sender;
- (IBAction)btnNoTapped:(id)sender;

-(void) sendNotificationToUsersWithParameters:(NSDictionary *) params;
-(void) contactsPickerDidSelectContacts:(NSDictionary *) users;

@property (nonatomic,strong) GNPost * post;

@property (weak, nonatomic) IBOutlet UITableView *tableViewGetData;

/// Data of the TableView
@property (nonatomic,strong) NSArray * pickerData;
@property (nonatomic,strong) NSArray *selectedContacts;
@property (nonatomic,strong) NSDictionary *selectedUsers;

@property (nonatomic, assign) CGFloat totalProgress;

@end
