//
//  ASCollectionViewDataSource.m
//  PlaylistApp
//
//  Created by FR-MAC on 12/17/14.
//  Copyright (c) 2014 Fitness Republic. All rights reserved.
//

#import "ASCollectionViewDataSource.h"

@implementation ASCollectionViewDataSource

- (void)baseInitWithViewController:(UIViewController *)viewcontroller noDataText:(NSString *)noDataText loadingText:(NSString *)loadingText collectionViewPropertyName:(NSString *)name;
{
  _viewcontroller = viewcontroller;
  _collectionViewName = (name) ? name : @"collectionView";
  _collectionView = [_viewcontroller valueForKey:_collectionViewName];
  _itemsArray = [NSMutableArray array];
  //  _numberOfPagesLoaded = 0;
  //  _stopLoadingNextPages = NO;
  //  _requestIsInProgress = NO;
  _noRecordMessage = (noDataText) ? noDataText : @"No Data";
  _loadingText = (loadingText) ? loadingText : @"Loading...";
}

- (id)initWithViewController:(UIViewController *)viewcontroller noDataText:(NSString *)noDataText loadingText:(NSString *)loadingText collectionViewPropertyName:(NSString *)name
{
  self = [super init];
  if (self) {
    [self baseInitWithViewController:viewcontroller noDataText:noDataText loadingText:loadingText collectionViewPropertyName:name];
  }
  return self;
}

- (id)initWithTableViewController:(UITableViewController *)viewcontroller noDataText:(NSString *)noDataText loadingText:(NSString *)loadingText collectionViewPropertyName:(NSString *)name
{
  self = [super init];
  if (self) {
    [self baseInitWithViewController:viewcontroller noDataText:noDataText loadingText:loadingText collectionViewPropertyName:name];
  }
  return self;
}

- (void)reloadDataSource
{
  [self reloadCollectionViewData];
}

- (void)loadNextPage
{
  //Override in subclass
}

- (void)reloadCollectionViewData
{
  //  _tableView.tableHeaderView = (self.itemsArray.count > 0) ? nil : [self noRocordView];
  
  // Uncomment this line to (print 5 demo cells & hide noRecordView) even when itemsArray is nil. But dont uncomment it here. Subclass it first and then over-ride this method.
//  if(!_dataIsManualyHandled)
//    if(self.itemsArray.count > 0)
//      self.collectionView.backgroundView = nil;
//    else
//      [self showNoRecordView];
//  else
//    self.collectionView.backgroundView = nil;
  
  [_collectionView reloadData];
}

- (void)hideBackgroundView {
  self.collectionView.backgroundView = nil;
}

- (void)showLoadingView {
  self.collectionView.backgroundView = [self noRocordViewWithText:_loadingText];
  [self.collectionView reloadData];
}
- (void)showNoRecordView {
  self.collectionView.backgroundView = [self noRocordViewWithText:_noRecordMessage];
}

- (UIView *)noRocordViewWithText:(NSString *)title
{
  CGFloat width = MIN(_collectionView.frame.size.width, [UIScreen mainScreen].bounds.size.width);
  CGFloat height = MIN(_collectionView.frame.size.height, [UIScreen mainScreen].bounds.size.height);
  CGRect frame = CGRectMake(0.0, 0.0, width, height);
  UIView *noRecordView = [[UIView alloc] initWithFrame:frame];
  noRecordView.backgroundColor = [UIColor clearColor];
  UILabel *label = [[UILabel alloc] initWithFrame:noRecordView.frame];
  label.backgroundColor = [UIColor clearColor];
  label.text = title;
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor whiteColor];
  label.font = [UIFont systemFontOfSize:20.0];
  label.numberOfLines = 0;
  [noRecordView addSubview:label];
  _noRecordView = noRecordView;
  return _noRecordView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellId = @"Cell";
  UICollectionViewCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
  if (!cell) {
    assert(@"CollectionViewCell can not be nil");
  }
  return cell;
}

@end
