//
//  InterestTableView.h
//  GoOrNo
//
//  Created by Asif Ali on 03/06/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GNCategory;

@protocol InterestTableViewDelegate <NSObject>

@required
-(void) interestDidSelect:(GNCategory *) category;

@end

@interface InterestTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *selectedCategories;
@property (nonatomic, weak) id<InterestTableViewDelegate> delegateController;
@end
