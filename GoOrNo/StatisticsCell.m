//
//  StatisticsCell.m
//  GoOrNo
//
//  Created by O16 Labs on 30/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "StatisticsCell.h"

@implementation StatisticsCell
@synthesize statDelegate;

- (IBAction)buttonDetailTapped:(id)sender {
    [self.statDelegate ShowDetailScreen:self.cellPost];
}

@end
