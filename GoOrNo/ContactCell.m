//
//  ContactCell.m
//  GoOrNo
//
//  Created by Asif Ali on 05/06/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)inviteButtonPressed:(id)sender {
    
    [_delegate inviteButtonDidPressed:self];
}

@end
