//
//  AboutUsModel.m
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "AboutUsModel.h"

@implementation AboutUsModel
- (id)initWithSectionTitle:(NSString *)sectionTitle text:(NSString *)aboutUs {
    self = [super init];
    
    self.aboutUsSectionTitle = [sectionTitle copy];
    self.aboutUsText = [aboutUs copy];
    
    return self;
}
@end
