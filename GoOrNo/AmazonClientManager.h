//
//  AmazonClientManager.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 13/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmazonClientManager : NSObject

+ (AmazonClientManager *)sharedInstance;
//- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (void)completeLogin:(NSDictionary *)logins completionHandler:(BFContinuationBlock)completionHandler;

@property (nonatomic,strong) AWSCognitoCredentialsProvider * credentialsProvider;

@property (nonatomic,strong) AWSS3TransferManager *transferManager;

@property (nonatomic,strong) AWSDynamoDBObjectMapper * dynamoDbObjectMapper;

@end
