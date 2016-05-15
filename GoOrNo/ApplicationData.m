//
//  ApplicationData.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 20/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ApplicationData.h"
#import "AmazonClientManager.h"

#import "LoginViewController.h"

NSString *const NotificationQuestionAndCategoriesSaved = @"QuestionAndCategoriesSavedNotification";

@implementation ApplicationData

+ (instancetype)sharedInstance
{
  static ApplicationData *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [ApplicationData new];
//    sharedInstance.currentUser = [GNUser loadFromUserDefaultsWithKey:AppUserKey];
    if (!sharedInstance.currentUser) {
      [LoginViewController loginWithFacebookIfPossible];
    }
    [self getCategories:sharedInstance];
    [self getQuestions:sharedInstance];
    [self getAnswers:sharedInstance];
  });
  return sharedInstance;
}

- (BOOL)allCategoriesQuestionAndAnswerAreLoaded {
  BOOL allLoaded = true;
  if (self.questions.count==0) {
    [SVProgressHUD show];
    [self.class getQuestions:self];
    allLoaded = false;
  }
  if (self.categories.count==0) {
    [SVProgressHUD show];
    [self.class getCategories:self];
    allLoaded = false;
  }
  if (self.answers.count==0) {
    [SVProgressHUD show];
    [self.class getAnswers:self];
    allLoaded = false;
  }
  return allLoaded;
}

+ (void)getCategories:(ApplicationData *)instance {
  //Get All Categories From AWS DynamoDB
  instance.categories = @[].mutableCopy;
  AWSDynamoDBScanExpression *categoriesScan = [AWSDynamoDBScanExpression new];
  [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] scan:[GNCategory class]
                                                          expression:categoriesScan]
   continueWithBlock:^id(BFTask *task) {
     if (task.error) {
       NSLog(@"The request failed. Error: [%@]", task.error);
       dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD dismiss];
       });
     }
     if (task.exception) {
       NSLog(@"The request failed. Exception: [%@]", task.exception);
       dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD dismiss];
       });
     }
     if (task.result) {
       AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
       for (GNCategory *category in paginatedOutput.items) {
         //Do something with book.
         [instance.categories addObject:category];
       }
       if (instance.questions.count>0 && instance.answers.count>0) {
         [[NSNotificationCenter defaultCenter] postNotificationName:NotificationQuestionAndCategoriesSaved object:nil];
         dispatch_async(dispatch_get_main_queue(), ^{
           [SVProgressHUD dismiss];
         });
       }
     }
     return nil;
   }];
}

+ (void)getQuestions:(ApplicationData *)instance {
  //Get All Question From AWS DynamoDB
  instance.questions = @[].mutableCopy;
  AWSDynamoDBScanExpression *questionScan = [AWSDynamoDBScanExpression new];
  [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] scan:[GNQuestion class]
                                                          expression:questionScan]
   continueWithBlock:^id(BFTask *task) {
     if (task.error) {
       NSLog(@"The request failed. Error: [%@]", task.error);
       dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD dismiss];
       });
     }
     if (task.exception) {
       NSLog(@"The request failed. Exception: [%@]", task.exception);
       dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD dismiss];
       });
     }
     if (task.result) {
       AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
       for (GNQuestion *question in paginatedOutput.items) {
         //Do something with book.
         [instance.questions addObject:question];
       }
       if (instance.categories.count>0 && instance.answers.count>0) {
         [[NSNotificationCenter defaultCenter] postNotificationName:NotificationQuestionAndCategoriesSaved object:nil];
         dispatch_async(dispatch_get_main_queue(), ^{
           [SVProgressHUD dismiss];
         });
       }
     }
     return nil;
   }];
}

+ (void)getAnswers:(ApplicationData *)instance {
  //Get All Question From AWS DynamoDB
  instance.answers = @[].mutableCopy;
  AWSDynamoDBScanExpression *scan = [AWSDynamoDBScanExpression new];
  [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] scan:[GNAnswer class]
                                                          expression:scan]
   continueWithBlock:^id(BFTask *task) {
     if (task.error) {
       NSLog(@"The request failed. Error: [%@]", task.error);
       dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD dismiss];
       });
     }
     if (task.exception) {
       NSLog(@"The request failed. Exception: [%@]", task.exception);
       dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD dismiss];
       });
     }
     if (task.result) {
       AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
       for (GNQuestion *object in paginatedOutput.items) {
         //Do something with book.
         [instance.answers addObject:object];
       }
       if (instance.categories.count>0 && instance.questions.count>0) {
         [[NSNotificationCenter defaultCenter] postNotificationName:NotificationQuestionAndCategoriesSaved object:nil];
         dispatch_async(dispatch_get_main_queue(), ^{
           [SVProgressHUD dismiss];
         });
       }
     }
     return nil;
   }];
}

+ (void)addCategories {
  //Add All Categories on AWS
  NSMutableArray *tasks = @[].mutableCopy;
  NSArray * categoriesNames = @[@"Art & Design", @"Cars / Boats / Planes", @"Fashion", @"Funny Things", @"Hobbies", @"Travel & Leisure", @"Places", @"Science", @"Sports", @"Technology"];
  NSMutableArray * categories = @[].mutableCopy;
  for(NSInteger i=0; i<categoriesNames.count; i++) {
    GNCategory * category = [GNCategory new];
    category.CategoryID = [NSNumber numberWithInteger:i];
    category.Name = categoriesNames[i];
    [categories addObject:category];
    // Add Image Upload BFTask to tasks array
    [tasks addObject:[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:category]];
  }
  // Group completion task is called when all the images are uploaded
  BFTask *groupTask = [BFTask taskForCompletionOfAllTasks:tasks.copy];
  [groupTask continueWithBlock:^id(BFTask *task) {
    ApplicationData * instance = [self sharedInstance];
    instance.categories = categories;
    return nil;
  }];
}

+ (void)addQuestions {
  NSMutableArray *tasks = @[].mutableCopy;
  NSArray * questionNames = @[@"Question 0",
                           @"Question 1",
                           @"Question 2",
                           @"Question 3",
                           @"Question 4",
                           @"Question 5",
                           @"Question 6",
                           @"Question 7",
                           @"Question 8",
                           @"Question 9",
                           @"Question 10",
                           @"Question 11",
                           @"Question 12",
                           @"Question 13",
                           @"Question 14",
                           @"Question 15",
                           @"Question 16",
                           @"Question 17",
                           @"Question 18",
                           @"Question 19"
                           ];
  NSMutableArray * questions = @[].mutableCopy;
  for(NSInteger i=0; i<questionNames.count; i++) {
    GNQuestion * question = [GNQuestion new];
    question.QuestionID = [NSNumber numberWithInteger:i];
    question.Name = questionNames[i];
    [questions addObject:question];
    // Add Image Upload BFTask to tasks array
    [tasks addObject:[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:question]];
  }
  // Group completion task is called when all the images are uploaded
  BFTask *groupTask = [BFTask taskForCompletionOfAllTasks:tasks.copy];
  [groupTask continueWithBlock:^id(BFTask *task) {
    ApplicationData * instance = [self sharedInstance];
    instance.questions = questions;
    return nil;
  }];
}

@end
