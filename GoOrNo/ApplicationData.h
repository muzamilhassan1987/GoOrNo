//
//  ApplicationData.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 20/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GNUser.h"

FOUNDATION_EXPORT NSString *const NotificationQuestionAndCategoriesSaved;

@interface ApplicationData : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic,strong) GNUser * currentUser;

@property (nonatomic,strong) NSMutableArray * categories;
@property (nonatomic,strong) NSMutableArray * questions;
@property (nonatomic,strong) NSMutableArray * answers;
@property (nonatomic,assign) BOOL showLoginDialog;

- (BOOL)allCategoriesQuestionAndAnswerAreLoaded;

@end
