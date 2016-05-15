//
//  GNNotification.m
//  GoOrNo
//
//  Created by Asif Ali on 06/06/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "GNNotification.h"

@implementation GNNotification

+ (NSString *)dynamoDBTableName {
    return @"Notification";
}

+ (NSString *)hashKeyAttribute {
    return @"NotificationID";
}

@end
