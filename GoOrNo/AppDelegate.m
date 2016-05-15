//
//  AppDelegate.m
//  GoOrNo
//
//  Created by Kumar on 07/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "AWSDynamoDB.h"
#import "AmazonClientManager.h"
#import "ApplicationData.h"
#import <NSUserDefaults+RMSaveCustomObject.h>
#import "Constants.h"
#import "NewsFeedViewController.h"
#import <AWSSNS/AWSSNS.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
  
  return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  // Override point for customization after application launch.
  [FBSDKLoginButton class];
  
//  [[SDImageCache sharedImageCache] clearDisk];
  
  [AWSLogger defaultLogger].logLevel = AWSLogLevelDebug;
  [AmazonClientManager sharedInstance];
    [ApplicationData sharedInstance].showLoginDialog = YES;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedInUser"]) {
        [ApplicationData sharedInstance].currentUser = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"loggedInUser"];
    }
    
  
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                                UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
//    [self performSelector:@selector(testRunner) withObject:nil afterDelay:10];
    
  
  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                         didFinishLaunchingWithOptions:launchOptions];
}

-(void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"APNS register error:%@", error);
}

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokenString = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceTokenString: %@", deviceTokenString);
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:kDeviceTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AWSSNS *sns = [AWSSNS defaultSNS];
    AWSSNSCreatePlatformEndpointInput *request = [AWSSNSCreatePlatformEndpointInput new];
    request.token = deviceTokenString;
    request.platformApplicationArn = SNSPlatformApplicationArn;
    [[sns createPlatformEndpoint:request] continueWithBlock:^id(BFTask *task) {
        if (task.error != nil) {
            NSLog(@"Error: %@",task.error);
        } else {
            AWSSNSCreateEndpointResponse *createEndPointResponse = task.result;
            NSLog(@"endpointArn: %@",createEndPointResponse);
            [[NSUserDefaults standardUserDefaults] setObject:createEndPointResponse.endpointArn forKey:@"endpointArn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        return nil;
    }];

}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"APNS:%@", userInfo);
    if ([userInfo objectForKey:@"arguments"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"Show" otherButtonTitles: nil];
        [alertView show];
        
        NSDictionary *args = [NSJSONSerialization JSONObjectWithData:[[userInfo objectForKey:@"arguments"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        NSString *postID = [args objectForKey:@"PostID"];
        UINavigationController *navigation = (UINavigationController *) self.window.rootViewController;
        NewsFeedViewController *newsFeed = [navigation.viewControllers objectAtIndex:0];
        newsFeed.selectedPostID = postID;
        [newsFeed showPostFromNotification:postID];
    }
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"APNS:%@ completionHandler", userInfo);
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)testRunner{
    NSString *postID = @"4823DB99-94C0-4F30-BEBD-8C31C216B21D";
    UINavigationController *navigation = (UINavigationController *) self.window.rootViewController;
    NewsFeedViewController *newsFeed = [navigation.viewControllers objectAtIndex:0];
    [newsFeed showPostFromNotification:postID];
}

@end
