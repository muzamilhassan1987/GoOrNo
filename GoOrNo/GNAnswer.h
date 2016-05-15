//
//  GNAnswer.h
//  GoOrNo
//
//  Created by O16 Labs on 15/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNAnswer : AWSDynamoDBObjectModel <AWSDynamoDBModeling>

@property (nonatomic,strong) NSNumber * AnswerID;
@property (nonatomic,strong) NSString * Name;

@end
