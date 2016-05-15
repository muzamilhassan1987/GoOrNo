//
//  GNQuestion.h
//  GoOrNo
//
//  Created by O16 Labs on 28/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNQuestion : AWSDynamoDBObjectModel <AWSDynamoDBModeling>

@property (nonatomic,strong) NSNumber * QuestionID;
@property (nonatomic,strong) NSString * Name;

@end
