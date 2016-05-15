//
//  ASCollectionViewDataSource.h
//  PlaylistApp
//
//  Created by FR-MAC on 12/17/14.
//  Copyright (c) 2014 Fitness Republic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ASCollectionViewDataSource : NSObject <UICollectionViewDataSource>
{
@private
  NSString * _noRecordMessage;
  NSString * _noDataText;
  NSString * _loadingText;
  //  NSInteger _numberOfPagesLoaded;
  //  BOOL _stopLoadingNextPages;
  //  BOOL _requestIsInProgress;
  UIView *_noRecordView;
  BOOL _dataIsManualyHandled;
  NSString * _collectionViewName;
}

/** ViewController that holds the tableview of this datasource */
@property (nonatomic, weak) UIViewController *viewcontroller;

@property (nonatomic, weak) UICollectionView * collectionView;

/** Array of items, each item holds data for associated row */
@property (nonatomic, strong) NSMutableArray *itemsArray;

///** True when a url request for getting data is already in progress */
//@property (nonatomic, readonly) BOOL requestIsInProgress;

/** initialize datasource. Subclasses should override this method to load the items array */
- (id)initWithViewController:(UIViewController *)viewcontroller noDataText:(NSString *)noDataText loadingText:(NSString *)loadingText collectionViewPropertyName:(NSString *)name;

/** initialize datasource for a UITableViewController. Subclasses should override this method to load the items array */
- (id)initWithTableViewController:(UITableViewController *)viewcontroller noDataText:(NSString *)noDataText loadingText:(NSString *)loadingText collectionViewPropertyName:(NSString *)name;


/** loads data into itemsArray and calls reloadTableViewData to show reload tableView - Subclass must override this method */
- (void)reloadDataSource;

///** loads the data from next page then adds those rows to datasource - Subclass may override this mthod to implement paginations */
//- (void)loadNextPage;

/** reloads the tableview and show noRecordView if itemsArray has no items, Important: Use this method instead of [tableview reloadData] */
- (void)reloadCollectionViewData;

/** No Records View To show when there are not any rows to show */
- (void)showNoRecordView;
- (void)showLoadingView;
- (void)hideBackgroundView;

@end
