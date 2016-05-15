//
//  GNNotification.h
//  GoOrNo
//
//  Created by Asif Ali on 06/06/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "AWSDynamoDBObjectMapper.h"

@interface GNNotification : AWSDynamoDBObjectModel <AWSDynamoDBModeling>

@property (nonatomic,strong) NSString * NotificationID;
@property (nonatomic,strong) NSString * InviteeID;
@property (nonatomic,strong) NSString * InviterName;
@property (nonatomic,strong) NSString * PostID;

@end
