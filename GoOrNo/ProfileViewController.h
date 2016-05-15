//
//  ProfileViewController.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 11/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ViewController.h"

@interface ProfileViewController : ViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblNameGender;
@property (weak, nonatomic) IBOutlet UILabel *lblHomeTown;
@property (weak, nonatomic) IBOutlet UILabel *lblBirthday;
@property (weak, nonatomic) IBOutlet UILabel *lblMobile;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;


@property (nonatomic,strong) ASCollectionViewDataSource * dataSourceInterests;
@property (nonatomic,strong) ASCollectionViewDataSource * dataSourceFriends;

@end
