//
//  AWSCategory.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 22/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNCategory : AWSDynamoDBObjectModel <AWSDynamoDBModeling>

@property (nonatomic,strong) NSNumber * CategoryID;
@property (nonatomic,strong) NSString * Name;

@end
