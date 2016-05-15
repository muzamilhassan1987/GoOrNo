//
//  ASDataSource.m
//  BeerPong
//
//  Created by Mudassir Younus on 11/5/13.
//  Copyright (c) 2013 salsoft. All rights reserved.
//

#import "ASDataSource.h"

@implementation ASDataSource {
  
}

@synthesize requestIsInProgress = _requestIsInProgress;

- (void)baseInitWithViewController:(UIViewController *)viewcontroller noDataText:(NSString *)noDataText loadingText:(NSString *)loadingText
{
  _viewcontroller = viewcontroller;
  _tableView = [_viewcontroller valueForKey:@"tableView"];
  _itemsArray = [NSMutableArray array];
//  _numberOfPagesLoaded = 0;
//  _stopLoadingNextPages = NO;
//  _requestIsInProgress = NO;
    _noRecordMessage = (noDataText) ? noDataText : @"No Data";
    _loadingText = (loadingText) ? loadingText : @"Loading...";
}

- (id)initWithViewController:(UIViewController *)viewcontroller noDataText:(NSString *)noDataText loadingText:(NSString *)loadingText
{
  self = [super init];
  if (self) {
    [self baseInitWithViewController:viewcontroller noDataText:noDataText loadingText:loadingText];
  }
  return self;
}

- (id)initWithTableViewController:(UITableViewController *)viewcontroller noDataText:(NSString *)noDataText loadingText:(NSString *)loadingText
{
  self = [super init];
  if (self) {
    [self baseInitWithViewController:viewcontroller noDataText:noDataText loadingText:loadingText];
  }
  return self;
}

- (void)reloadDataSource
{
  [self reloadTableViewData];
}

- (void)loadNextPage
{
  //Override in subclass
}

- (void)reloadTableViewData
{
//  _tableView.tableHeaderView = (self.itemsArray.count > 0) ? nil : [self noRocordView];
  
  // Uncomment this line to (print 5 demo cells & hide noRecordView) even when itemsArray is nil. But dont uncomment it here. Subclass it first and then over-ride this method.
  if(self.itemsArray.count > 0)
    self.tableView.backgroundView = nil;
  else
    [self showNoRecordView];
  
  [_tableView reloadData];
}

- (void)showLoadingView {
  self.tableView.backgroundView = [self noRocordViewWithText:_loadingText];
  [self.tableView reloadData];
}
- (void)showNoRecordView {
  self.tableView.backgroundView = [self noRocordViewWithText:_noRecordMessage];
}

- (UIView *)noRocordViewWithText:(NSString *)title
{
  CGFloat width = MIN(_tableView.frame.size.width, [UIScreen mainScreen].bounds.size.width);
  CGFloat height = MIN(_tableView.frame.size.height, [UIScreen mainScreen].bounds.size.height);
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellId = @"Cell";
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  if (!cell) {
    assert(@"TableViewCell can not be nil");
  }
  return cell;
}

@end
