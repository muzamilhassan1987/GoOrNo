//
//  GNUser.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 20/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "GNUser.h"
#import <NSUserDefaults+RMSaveCustomObject.h>

@implementation GNUser

- (void)saveInUserDefaultsWithKey:(NSString *)key {
  NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:encodedObject forKey:key];
  [defaults synchronize];
}

+ (instancetype)loadFromUserDefaultsWithKey:(NSString *)key {
  NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
  NSData *encodedObject     = [defaults objectForKey:key];
  GNUser * object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
  return object;
}

+(void) saveUser:(GNUser *) user {
        
    [[NSUserDefaults standardUserDefaults] rm_setCustomObject:user forKey:@"loggedInUser"];
}

+(GNUser *) loadUserFromDefaults {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedInUser"] == nil) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"loggedInUser"];
    
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  //Encode properties, other class variables, etc
  if (self.UserID) {
    [encoder encodeObject:self.UserID forKey:@"UserID"];
  }
  if (self.FacebookID) {
    [encoder encodeObject:self.FacebookID forKey:@"FacebookID"];
  }
  if (self.Email) {
    [encoder encodeObject:self.Email forKey:@"Email"];
  }
  if (self.Phone) {
    [encoder encodeObject:self.Phone forKey:@"Phone"];
  }
  if (self.CognitoID) {
    [encoder encodeObject:self.CognitoID forKey:@"CognitoID"];
  }
  if (self.Name) {
    [encoder encodeObject:self.Name forKey:@"Name"];
  }
  if (self.Password) {
    [encoder encodeObject:self.Password forKey:@"Password"];
  }
    if (self.City) {
        [encoder encodeObject:self.City forKey:@"City"];
    }
    if (self.Favorites) {
        [encoder encodeObject:self.Favorites forKey:@"Favorites"];
    }
    if (self.DeviceToken) {
        [encoder encodeObject:self.DeviceToken forKey:@"DeviceToken"];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
  if((self = [super initWithCoder:decoder])) {
    //decode properties, other class vars
    self.UserID = [decoder decodeObjectForKey:@"UserID"];
    self.FacebookID = [decoder decodeObjectForKey:@"FacebookID"];
    self.Email = [decoder decodeObjectForKey:@"Email"];
    self.Phone = [decoder decodeObjectForKey:@"Phone"];
    self.CognitoID = [decoder decodeObjectForKey:@"CognitoID"];
    self.Name = [decoder decodeObjectForKey:@"Name"];
    self.Password = [decoder decodeObjectForKey:@"Password"];
    self.City = [decoder decodeObjectForKey:@"City"];
      self.Favorites = [decoder decodeObjectForKey:@"Favorites"];
      self.DeviceToken = [decoder decodeObjectForKey:@"DeviceToken"];
  }
  return self;
}

+ (NSString *)dynamoDBTableName {
  return @"Users";
}

+ (NSString *)hashKeyAttribute {
  return @"UserID";
}

+(BOOL) checkIfUserIsLoggedIn {
    
    return [[ApplicationData sharedInstance] currentUser] != nil;
}

+(BOOL) checkForAnonymousUser {
    
    return [[[ApplicationData sharedInstance] currentUser] UserType].intValue == UserTypeAnonymous;
}

+(GNUser *) createAnonymousUser {
    
    NSString *uniqueID = [[NSUUID UUID] UUIDString];
    GNUser *user = [[GNUser alloc] init];
    user.UserID = uniqueID;
    user.Email = [uniqueID stringByAppendingString:@"@anonymous.com"];
    user.Name = @"Anonymous";
    user.UserType = @(UserTypeAnonymous);
    user.DeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenKey];
    return user;
}

+ (GNUser *)createOrUpdateUserWithFacebookID:(NSString *)facebookID awsCognitoID:(NSString *)congnitoID {
  
//  AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
//  
//  // Read
//  [[dynamoDBObjectMapper load:[Book class] hashKey:@"3456789012" rangeKey:nil]
//   continueWithBlock:^id(BFTask *task) {
//     if (task.error) {
//       NSLog(@"The request failed. Error: [%@]", task.error);
//     }
//     if (task.exception) {
//       NSLog(@"The request failed. Exception: [%@]", task.exception);
//     }
//     if (task.result) {
//       Book *book = task.result;
//       //Do something with the result.
//       NSLog(@"Read [%@]", book);
//     }
//     return nil;
//   }];
//  
//  // Create
//  GNUser * newUser = [GNUser new];
//  newUser.UserID = [[NSUUID UUID] UUIDString];
//  newUser.FacebookID = facebookID;
//  newUser.CognitoID = congnitoID;
//  
//  [[dynamoDBObjectMapper save:myBook]
//   continueWithBlock:^id(BFTask *task) {
//     if (task.error) {
//       NSLog(@"The request failed. Error: [%@]", task.error);
//     }
//     if (task.exception) {
//       NSLog(@"The request failed. Exception: [%@]", task.exception);
//     }
//     if (task.result) {
//       //Do something with the result.
//       NSLog(@"Created: [%@]", task.result);
//     }
//     return nil;
//   }];
  return nil;

}

@end
