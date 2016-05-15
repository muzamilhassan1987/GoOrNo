//
//  WebClient.h
//  HPSmart
//
//  Created by Faheem Ziker on 14/01/2014.
//  Copyright (c) 2014 V7iTech. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#define WEB_MANAGER [WebClient sharedClient]


@class HomeData;
@class Product;
@class ProductCategory;
@class CartProduct;
@class ChatUser;
@class ChatGroup;
@class ChatBroadcast;
@class ChatConversation;

@interface  UploadFile : NSObject

@property(nonatomic,strong) NSString *name,*fileName,*type;
@property(nonatomic,strong) NSData *fileData;

@end


@interface WebClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (void)postPath:(NSString *)URLString
parameters:(NSDictionary *)parameters
showLoading:(NSString *)message
success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure;
@end