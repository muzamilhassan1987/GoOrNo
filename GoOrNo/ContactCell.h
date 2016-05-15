//
//  ContactCell.h
//  GoOrNo
//
//  Created by Asif Ali on 05/06/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactCellDelegate <NSObject>

-(void) inviteButtonDidPressed:(id) cell;

@end

@interface ContactCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic, weak) IBOutlet UIButton *inviteButton;

@property (nonatomic, strong) id delegate;

-(IBAction)inviteButtonPressed:(id)sender;

@end
