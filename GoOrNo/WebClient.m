//
//  WebClient.m
//  HPSmart
//
//  Created by Faheem Ziker on 14/01/2014.
//  Copyright (c) 2014 V7iTech. All rights reserved.
//

#import "WebClient.h"
#import "Constants.h"
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"

@implementation UploadFile
@synthesize name,fileName,type,fileData;


@end

@implementation WebClient

+ (instancetype)sharedClient {
    static WebClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WebClient alloc] initWithBaseURL:[NSURL URLWithString:kWebServiceBaseURL]];
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    });
    
    return _sharedClient;
}

-(void) showErrorMessage:(NSString *)message{
    
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles: nil] show];
}


-(NSMutableArray *) parseArray:(NSArray *)array
                   ofClassType:(Class)type
                     clientKey:(NSString *)clientKey
                     serverKey:(NSString *)serverKey {
    
    NSMutableArray *objects=[NSMutableArray array];
    
    for (NSDictionary *objectDictionary in array) {
        
        /*BaseEntity *baseEntity=[BaseEntity createOrUpdateEntity:type
                                                           data:objectDictionary
                                                      serverKey:serverKey
                                                      clientKey:clientKey];
        [baseEntity initWithDictionary:objectDictionary];
        
        [objects addObject:baseEntity];*/
        
    }
    return objects;
}


-(void) handleSuccessResponse:(AFHTTPRequestOperation *)operation
               responseObject:(id) responseObject
             showErrorMessage:(BOOL)isShowErrorMessage
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure {
    
    if(responseObject&&[responseObject isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *responseData = (NSDictionary*)responseObject;
        
        if(responseData && ([[responseData objectForKey:@"Response"] caseInsensitiveCompare:@"Error"] == NSOrderedSame||[[responseData objectForKey:@"Response"] caseInsensitiveCompare:@"Fail"] == NSOrderedSame)){
            
            NSString *errorMessage = [responseData objectForKey:@"Result"];
            
            if([errorMessage isKindOfClass:[NSArray class]])
                errorMessage=[(NSArray *)errorMessage firstObject];
            
            NSError *error=[NSError errorWithDomain:@"Server" code:0 userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
            
            failure(error);
            
            //showing error message
            if(isShowErrorMessage) {
                [self showErrorMessage:error.localizedDescription];
            }
        }
        else {
            if(responseData) {
                NSDictionary *dataDictionary = [responseData objectForKey:@"Result"];
                success(dataDictionary);
            }
            else {
                success(responseObject);
            }
        }
    }
    else {
        success(responseObject);
    }
    
}



- (void)postPath:(NSString *)URLString
      parameters:(NSDictionary *)parameters
     showLoading:(NSString *)message
         success:(void (^)(id responseObject))success
         failure:(void (^)(NSError *error))failure
{
    if(message) {
        [SVProgressHUD showWithStatus:message
                             maskType:SVProgressHUDMaskTypeBlack];
    }
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    [manager POST:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [SVProgressHUD dismiss];
              
              success(responseObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [SVProgressHUD dismiss];
              
              if (error && message) {
                  
                  [self showErrorMessage:[error localizedDescription]];
                  
                  if (failure) {
                      NSMutableDictionary *messageDictionary=[NSMutableDictionary dictionaryWithDictionary:error.userInfo];
                      
                      NSError *localError=[NSError errorWithDomain:error.domain
                                                              code:error.code
                                                          userInfo:messageDictionary];
                      failure(localError);
                  }
              }
          }];
}


- (void)getPath:(NSString *)URLString
     parameters:(NSDictionary *)parameters
    showLoading:(NSString *)message
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure
{
  
    if(message) {
        [SVProgressHUD showWithStatus:message
                             maskType:SVProgressHUDMaskTypeBlack];
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    [manager GET:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [SVProgressHUD dismiss];
              
              [self handleSuccessResponse:operation
                           responseObject:responseObject
                         showErrorMessage:message!=nil
                                  success:success
                                  failure:failure];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              [SVProgressHUD dismiss];
              
              if (error) {
                  if (failure) {
                      NSMutableDictionary *messageDictionary=[NSMutableDictionary dictionaryWithDictionary:error.userInfo];
                      
                      NSError *localError=[NSError errorWithDomain:error.domain
                                                              code:error.code
                                                          userInfo:messageDictionary];
                      failure(localError);
                  }
              }
          }];
}

- (void)postPathMultipart:(NSString *)URLString
               parameters:(NSDictionary *)parameters
              showLoading:(NSString *)message
                    files:(NSArray *)filesArray
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    if(message) {
        [SVProgressHUD showWithStatus:message
                             maskType:SVProgressHUDMaskTypeBlack];
    }

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    
    [manager
     POST:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString]
     parameters:parameters
     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
         
         for (UploadFile *file in filesArray ) {
             
             if (file.fileData) {
                 [formData appendPartWithFileData:file.fileData name:file.name fileName:file.fileName mimeType:file.type];
             }
         }
     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [SVProgressHUD dismiss];
         
         [self handleSuccessResponse:operation
                      responseObject:responseObject
                    showErrorMessage:message!=nil
                             success:success failure:failure];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD dismiss];
         
         if (error) {
             if (failure) {
                 failure(error);
             }
         }
         
     }];
}


@end
