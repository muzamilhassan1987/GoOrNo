//
//  AboutUsModel.h
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AboutUsModel : NSObject
{
    
}
@property(nonatomic, strong) NSString *aboutUsSectionTitle;
@property(nonatomic, strong) NSString *aboutUsText;

- (id)initWithSectionTitle:(NSString *)sectionTitle text:(NSString *)aboutUs;
@end
