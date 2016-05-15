//
//  AmazonClientManager.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 13/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "AmazonClientManager.h"

@implementation AmazonClientManager

+ (AmazonClientManager *)sharedInstance
{
  static AmazonClientManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [AmazonClientManager new];
    sharedInstance.credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:CognitoRegionType identityPoolId:CognitoIdentityPoolId];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc]
                                              initWithRegion:CognitoRegionType
                                              credentialsProvider:sharedInstance.credentialsProvider
                                              ];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
  });
  return sharedInstance;
}
- (AWSS3TransferManager *)transferManager {
  return [AWSS3TransferManager defaultS3TransferManager];
}
- (AWSDynamoDBObjectMapper *)dynamoDbObjectMapper {
  return [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
}

//- (BOOL)handleOpenURL:(NSURL *)url
//    sourceApplication:(NSString *)sourceApplication
//           annotation:(id)annotation
//{
//  return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
//}

- (void)completeLogin:(NSDictionary *)logins completionHandler:(BFContinuationBlock)completionHandler{
  BFTask *task;
  self.credentialsProvider.logins = logins;
  //  task = [self.credentialsProvider refresh];
  task = [self.credentialsProvider getIdentityId];
//  if (self.credentialsProvider == nil) {
//    self.credentialsProvider.logins =
//    task = [self initializeClients:logins];
//  }
//  else {
//    NSMutableDictionary *merge = [NSMutableDictionary dictionaryWithDictionary:self.credentialsProvider.logins];
//    [merge addEntriesFromDictionary:logins];
//    self.credentialsProvider.logins = merge;
//    // Force a refresh of credentials to see if we need to merge
//    task = [self.credentialsProvider refresh];
//  }
  
  [[task continueWithBlock:^id(BFTask *task) {
//    if(!task.error){
//      //if we have a new device token register it
//      __block NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//      __block NSData *currentDeviceToken = [userDefaults objectForKey:DeviceTokenKey];
//      __block NSString *currentDeviceTokenString = (currentDeviceToken == nil)? nil : [currentDeviceToken base64EncodedStringWithOptions:0];
//      if(currentDeviceToken != nil && ![currentDeviceTokenString isEqualToString:[userDefaults stringForKey:CognitoDeviceTokenKey]]){
//        [[[AWSCognito defaultCognito] registerDevice:currentDeviceToken] continueWithBlock:^id(BFTask *task) {
//          if(!task.error){
//            [userDefaults setObject:currentDeviceTokenString forKey:CognitoDeviceTokenKey];
//            [userDefaults synchronize];
//          }
//          return nil;
//        }];
//      }
//    }
    return task;
  }] continueWithBlock:completionHandler];
}

@end
