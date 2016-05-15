/*
 * Copyright 2010-2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#define kUserPlaceholder @"user.jpg"
#define kMediaPlaceholder @"placeholder.jpg"

#define kDeviceTokenKey @"deviceToken"
#define kWebServiceBaseURL @"http://54.171.79.98/GoOrNo"

#import <Foundation/Foundation.h>
#import "AWSCore.h"

FOUNDATION_EXPORT NSString *const AppUserKey;

FOUNDATION_EXPORT AWSRegionType const CognitoRegionType;
FOUNDATION_EXPORT NSString *const CognitoIdentityPoolId;
FOUNDATION_EXPORT NSString *const CognitoS3BucketName;

FOUNDATION_EXPORT NSString *const ImageNameGoOrNo;
FOUNDATION_EXPORT NSString *const FolderUploadImages;

FOUNDATION_EXPORT NSString *const SNSPlatformApplicationArn;

NSString * CognitoS3ImagePath(NSString * imageName);

//FOUNDATION_EXPORT NSString *const DeviceTokenKey;
//FOUNDATION_EXPORT NSString *const CognitoDeviceTokenKey;
//FOUNDATION_EXPORT NSString *const CognitoPushNotification;

///**
// * Enables Developer Authentication Login.
// * This sample uses the Java-based Cognito Authentication backend
// */
//#define BYOI_LOGIN                  0
//
//#if BYOI_LOGIN
//
//// This is the default value, if you modified your backend configuration
//// update this value as appropriate
//#define AppName @"awscognitodeveloperauthenticationsample"
//// Update this value to reflect where your backend is deployed
//// !!!!!!!!!!!!!!!!!!!
//// Make sure to enable HTTPS for your end point before deploying your
//// app to production.
//// !!!!!!!!!!!!!!!!!!!
//#define Endpoint @"http://YOUR-AUTH-ENDPOINT"
//// Set to the provider name you configured in the Cognito console.
//#define ProviderName @"PROVIDER_NAME"
//
//#endif