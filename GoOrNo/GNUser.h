//
//  GNUser.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 20/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+RMArchivable.h"

typedef enum GNUserType {
    
    UserTypeAnonymous = 0,
    UserTypeRegistered
} GNUserType;

@interface GNUser : AWSDynamoDBObjectModel <AWSDynamoDBModeling>


+ (void) saveUser:(GNUser *) user;
+ (GNUser *) loadUserFromDefaults;
+ (BOOL) checkForAnonymousUser;
+ (BOOL) checkIfUserIsLoggedIn;
+ (GNUser *) createAnonymousUser;
- (void)saveInUserDefaultsWithKey:(NSString *)key;
+ (instancetype)loadFromUserDefaultsWithKey:(NSString *)key;

@property (nonatomic,strong) NSString * UserID;
@property (nonatomic,strong) NSString * FacebookID;
@property (nonatomic,strong) NSString * Email;
@property (nonatomic,strong) NSString * Phone;
@property (nonatomic,strong) NSNumber * VerificationCode;
@property (nonatomic,strong) NSNumber * IsVerified;
@property (nonatomic,strong) NSNumber * RatingStatus;
@property (nonatomic,strong) NSString * CognitoID;
@property (nonatomic,strong) NSString * Name;
@property (nonatomic,strong) NSString * Password;
@property (nonatomic,strong) NSString * Image;
@property (nonatomic,strong) NSString * City;
@property (nonatomic,strong) NSString * Favorites;
@property (nonatomic,strong) NSNumber * UserType;
@property (nonatomic,strong) NSString * DeviceToken;

//@property (nonatomic, strong) NSString *ISBN;

@end
