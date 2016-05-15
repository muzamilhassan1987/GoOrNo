//
//  ASDataSource.h
//  BeerPong
//
//  Created by Mudassir Younus on 11/5/13.
//  Copyright (c) 2013 salsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ASDataSource : NSObject <UITableViewDataSource>
{
@private
  NSString * _noRecordMessage;
  NSString * _noDataText;
  NSString * _loadingText;
//  NSInteger _numberOfPagesLoaded;
//  BOOL _stopLoadingNextPages;
//  BOOL _requestIsInProgress;
  UIView *_noRecordView;
}

/** ViewController that holds the tableview of this datasource */
@property (nonatomic, weak) UIViewController *viewcontroller;

@property (nonatomic, weak) UITableView * tableView;

/** Array of items, each item holds data for associated row */
@property (nonatomic, strong) NSMutableArray *itemsArray;

/** True when a url request for getting data is already in progress */
@property (nonatomic, readonly) BOOL requestIsInProgress;

/** initialize datasource. Subclasses should override this method to load the items array */
- (id)initWithViewController:(UIViewController *)viewcontroller noDataText:(NSString *)noDataText loadingText:(NSString *)loadingText;

/** initialize datasource for a UITableViewController. Subclasses should override this method to load the items array */
- (id)initWithTableViewController:(UITableViewController *)viewcontroller noDataText:(NSString *)noDataText loadingText:(NSString *)loadingText;

/** loads data into itemsArray and calls reloadTableViewData to show reload tableView - Subclass must override this method */
- (void)reloadDataSource;

/** loads the data from next page then adds those rows to datasource - Subclass may override this mthod to implement paginations */
- (void)loadNextPage;

/** reloads the tableview and show noRecordView if itemsArray has no items, Important: Use this method instead of [tableview reloadData] */
- (void)reloadTableViewData;

/** No Records View To show when there are not any rows to show */
- (void)showNoRecordView;
- (void)showLoadingView;

@end
