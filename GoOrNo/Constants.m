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

#import "Constants.h"

NSString *const AppUserKey = @"AppUser";

//#warning To run this sample correctly, you must set the following constants.
AWSRegionType const CognitoRegionType = AWSRegionUSEast1;
//NSString *const CognitoIdentityPoolId = @"us-east-1:fdb4023b-eb5a-4865-92fc-8feed28fb73b";

NSString *const CognitoIdentityPoolId = @"us-east-1:2289304c-6ae3-42ef-9b5a-7879dce015d4";
NSString *const CognitoS3BucketName = @"goorno-testapp001-bucket";
NSString * CognitoS3ImagePath(NSString * imageName) {
  return [NSString stringWithFormat:@"https://s3.amazonaws.com/%@/%@",CognitoS3BucketName,imageName];
}
NSString *const ImageNameGoOrNo = @"goornoimage.png";
NSString *const ProfileImage    = @"profileimage.png";
NSString *const FolderUploadImages = @"uploadimages";

NSString *const SNSPlatformApplicationArn = @"arn:aws:sns:us-east-1:807764767528:app/APNS_SANDBOX/GoOrNo";
NSString *const MobileAnalyticsAppId = @"YourMobileAnalyticsAppId";

//NSString *const DeviceTokenKey = @"DeviceToken";
//NSString *const CognitoDeviceTokenKey = @"CognitoDeviceToken";
//NSString *const CognitoPushNotification = @"CognitoPushNotification";


