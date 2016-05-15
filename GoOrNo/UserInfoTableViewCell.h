//
//  UserInfoTableViewCell.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 08/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@end
