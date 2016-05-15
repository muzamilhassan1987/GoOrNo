//
//  RScreenViewController.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 08/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "NewsFeedDataSource.h"

#import "FeedViewGoOrNo.h"
#import "FeedViewMultiAnswer.h"
#import "FeedViewMultiPic.h"
#import "CVCell.h"
#import "FeedViewRatePlace.h"

#import "AmazonClientManager.h"

#import "LoginViewController.h"
#import "StatisticsRulingViewController.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "NotificationsViewController.h"

#import "XHImageViewer.h"
#import "XHBottomToolBar.h"
#import "UIImageView+XHURLDownload.h"
#import "XHCustomImageView.h"
#import "UIPlacePicker.h"


#define TAG_CollectionView_MultiPic 1000
#define TAG_CollectionView_MultiAnswer 1001
#define TAG_CollectionView_RatePlace 1002

@interface NewsFeedViewController () <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, FeedViewGoOrNoDelegate, XHImageViewerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, MKMapViewDelegate>
{
    __weak IBOutlet UIView *menuView;
    __weak IBOutlet UIView *loadingView;
}

@property(nonatomic, strong) XHBottomToolBar *bottomToolBar;
@property(nonatomic, strong) UIDynamicAnimator *animator;

-(IBAction)settingsButtonPressed:(id)sender;
-(IBAction)profileButtonPressed:(id)sender;
-(IBAction)rulingsButtonPressed:(id)sender;
-(IBAction)statisticsButtonPressed:(id)sender;
-(IBAction)notificatonsButtonPressed:(id)sender;

@end

@implementation NewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [ApplicationData sharedInstance];
    self.title = @"Loading...";
    self.itemsArray = [NSMutableArray array];
    self.currentPostIndex = 0;
    // Optional Delegate
    self.swipeableView.delegate = self;
    if (self.showSelectedPost) {
        
        [self downloadSelectedPost];
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationItem setRightBarButtonItem:nil];
    }
    else {
        
        
        if ([[ApplicationData sharedInstance] questions].count > 0) {
            [self downloadLatestPosts];
        } else {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadLatestPosts) name:NotificationQuestionAndCategoriesSaved object:nil];
        }
    }
    
    [self addCreatePostsButton];
    [self adjustMenuButtons];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self setMenuButtonWithColor:nil];
    
    if (self.itemsArray.count > 0) {
        GNPost *post = self.itemsArray[self.currentPostIndex];
        [self refreshStylesForPost:post];

//        [self setMenuButtonWithColor:post.TextColor];
//        [self setOtherProfileOptionsBarButtonWithColor:post.TextColor];
    } else {
        [self setViewControllerClass:@"NewsFeeds"];
//        [self setNavigationBackgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor]];
//        [self setMenuButtonWithColor:[UIColor whiteColor]];
//        [self setOtherProfileOptionsBarButtonWithColor:[UIColor whiteColor]];
    }

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    // Required Data Source
    self.swipeableView.dataSource = self;
}

#pragma mark - Private Methods

- (XHBottomToolBar *)bottomToolBar {
    if (!_bottomToolBar) {
        _bottomToolBar = [[XHBottomToolBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    }
    return _bottomToolBar;
}

-(void)showPostFromNotification:(NSString*)postID{
    AWSDynamoDBScanExpression *postScan = [AWSDynamoDBScanExpression new];
    AWSDynamoDBCondition *condition = [AWSDynamoDBCondition new];
    AWSDynamoDBAttributeValue *attribute = [AWSDynamoDBAttributeValue new];
    
    attribute.S = postID;
    condition.attributeValueList = @[attribute];
    condition.comparisonOperator = AWSDynamoDBComparisonOperatorEQ;
    postScan.scanFilter = @{@"PostID":condition};
    
    [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] scan:[GNPost class]
                                                            expression:postScan]
     continueWithBlock:^id(BFTask *task) {
         if (task.error) {
             NSLog(@"The request failed. Error: [%@]", task.error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD showErrorWithStatus:task.error.localizedDescription];
             });
         }
         if (task.exception) {
             NSLog(@"The request failed. Exception: [%@]", task.exception);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD showErrorWithStatus:@"Failed. Exception occured"];
             });
         }
         if (task.result) {
             AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
             for (GNPost *post in paginatedOutput.items) {
                 //Do something with book.
                 [self.itemsArray insertObject:post atIndex:0];
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.swipeableView discardAllSwipeableViews];
                 [self.swipeableView loadNextSwipeableViewsIfNeeded];
             });
         }
         return nil;
     }];
}

- (void)refreshStylesForPost:(GNPost*)post {
    NSString *postType = post.postType;
    [self setViewControllerClass:postType];
    
    if(self.showSelectedPost) {
        [self setBackButton];
    }else {
        //[self setMenuButtonWithColor:post.TextColor];
        //[self setOtherProfileOptionsBarButtonWithColor:post.TextColor];
    }
    
    [self showAddButton];
}

- (void)downloadSelectedPost {
    
    AWSDynamoDBScanExpression *postScan = [AWSDynamoDBScanExpression new];
    AWSDynamoDBCondition *condition = [AWSDynamoDBCondition new];
    AWSDynamoDBAttributeValue *attribute = [AWSDynamoDBAttributeValue new];
    
    attribute.S = self.selectedPostID;
    condition.attributeValueList = @[attribute];
    condition.comparisonOperator = AWSDynamoDBComparisonOperatorEQ;
    postScan.scanFilter = @{@"PostID":condition};
    
    [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] scan:[GNPost class]
                                                            expression:postScan]
     continueWithBlock:^id(BFTask *task) {
         if (task.error) {
             NSLog(@"The request failed. Error: [%@]", task.error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD showErrorWithStatus:task.error.localizedDescription];
             });
         }
         if (task.exception) {
             NSLog(@"The request failed. Exception: [%@]", task.exception);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD showErrorWithStatus:@"Failed. Exception occured"];
             });
         }
         if (task.result) {
             AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
             for (GNPost *post in paginatedOutput.items) {
                 //Do something with book.
                 [self.itemsArray addObject:post];
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [loadingView setHidden:YES];
                 [self.swipeableView loadNextSwipeableViewsIfNeeded];
             });
         }
         return nil;
     }];
}

- (void)downloadLatestPosts {
    AWSDynamoDBScanExpression *postScan = [AWSDynamoDBScanExpression new];
    //  AWSDynamoDBCondition *condition = [AWSDynamoDBCondition new];
    //  AWSDynamoDBAttributeValue *attribute = [AWSDynamoDBAttributeValue new];
    //  attribute.N = @"8";
    //  condition.attributeValueList = @[attribute];
    //  condition.comparisonOperator = AWSDynamoDBComparisonOperatorEQ;
    //  postScan.scanFilter = @{@"Type":condition};
    [[[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] scan:[GNPost class]
                                                            expression:postScan]
     continueWithBlock:^id(BFTask *task) {
         if (task.error) {
             NSLog(@"The request failed. Error: [%@]", task.error);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD showErrorWithStatus:task.error.localizedDescription];
             });
         }
         if (task.exception) {
             NSLog(@"The request failed. Exception: [%@]", task.exception);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [SVProgressHUD showErrorWithStatus:@"Failed. Exception occured"];
             });
         }
         if (task.result) {
             AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
             for (GNPost *post in paginatedOutput.items) {
                 //Do something with book.
                 [self.itemsArray addObject:post];
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [loadingView setHidden:YES];
                 [self.swipeableView loadNextSwipeableViewsIfNeeded];
             });
             [[NSNotificationCenter defaultCenter] removeObserver:self];
             [self showAddButton];
         }
         return nil;
     }];
}

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if (self.currentPostIndex < self.itemsArray.count) {
        UIView *view;
        GNPost *post = self.itemsArray[self.currentPostIndex];
        switch (post.Type.integerValue) {
            case PostTypeGoNo:
                view = [self goOrNoView:swipeableView];
                break;
            case PostTypeMultiPic:
                view = [self multiPicView:swipeableView];
                break;
            case PostTypeMultiAnswer:
                view = [self multiAnswerView:swipeableView];
                break;
            case PostTypeRatePlace:
                view = [self ratePlaceView:swipeableView];
                break;
            default:
                break;
        }
        return view;
    }
    return nil;
}

#pragma mark - UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    GNPost *post = self.itemsArray[self.currentPostIndex];
    if (post.Type.integerValue == PostTypeRatePlace) {
        return 1;
    }
    switch (collectionView.tag) {
        case TAG_CollectionView_MultiAnswer: {
            NSInteger numberOfAnswers = 0;
            numberOfAnswers = (post.Answer1) ? numberOfAnswers + 1 : numberOfAnswers;
            numberOfAnswers = (post.Answer2) ? numberOfAnswers + 1 : numberOfAnswers;
            numberOfAnswers = (post.Answer3) ? numberOfAnswers + 1 : numberOfAnswers;
            UIPageControl *pageControl = [(FeedViewMultiAnswer *) collectionView.superview pageControl];
            pageControl.numberOfPages = numberOfAnswers;
            return numberOfAnswers;
            break;
        }
        case TAG_CollectionView_MultiPic: {
            NSArray *photos = [(FeedViewMultiPic *) collectionView.superview photos];
            UIPageControl *pageControl = [(FeedViewMultiPic *) collectionView.superview pageControl];
            pageControl.numberOfPages = photos.count;
            return photos.count;
            break;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Setup cell identifier
    GNPost *post = self.itemsArray[self.currentPostIndex];
    static NSString *cellIdentifier = @"cvCell";
    CVCell *cell = (CVCell *) [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    switch (collectionView.tag) {
        case TAG_CollectionView_MultiAnswer: {
            [cell.titleLabel setText:[post AnswerAtIndex:indexPath.item]];
            break;
        }
        case TAG_CollectionView_RatePlace: {
            [cell.titleLabel setText:post.PlaceDescription];
            break;
        }
        case TAG_CollectionView_MultiPic: {
            XHCustomImageView *imageView = [[(FeedViewMultiPic *) collectionView.superview photos] objectAtIndex:indexPath.item];
            XHCustomImageView *oldViewWithImage;
            for (XHCustomImageView *view in cell.contentView.subviews) {
                //        if ([view isKindOfClass:[XHCustomImageView class]] && !view.image) {
                [view removeFromSuperview];
                //        } else if ([view isKindOfClass:[XHCustomImageView class]]) {
                //          oldViewWithImage = view;
                //        }
            }
            //      if (oldViewWithImage) {
            //        oldViewWithImage.image = imageView.image;
            //      } else {
            [cell.contentView addSubview:imageView];
            //      }
            break;
        }
    }

    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UICollectionView *collectionView = (UICollectionView *) scrollView;
    CGRect visibleRect = (CGRect) {.origin = collectionView.contentOffset, .size = collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [collectionView indexPathForItemAtPoint:visiblePoint];
    GNPost *post = self.itemsArray[self.currentPostIndex];
    post.DefaultIndex = @(visibleIndexPath.item);
    UIPageControl *pageControl = [(FeedViewMultiAnswer *) collectionView.superview pageControl];
    pageControl.currentPage = visibleIndexPath.item;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //  UICollectionView * collectionView = (UICollectionView *)scrollView;
    //  NSIndexPath * visibleIndexPath = [[collectionView indexPathsForVisibleItems] firstObject];
    //  GNPost * post = self.itemsArray[self.currentPostIndex];
    //  post.DefaultIndex = [NSNumber numberWithInteger:visibleIndexPath.item];
    //  UIPageControl * pageControl = [(FeedViewMultiAnswer *)collectionView.superview pageControl];
    //  pageControl.currentPage = visibleIndexPath.item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return;
    GNPost *post = self.itemsArray[self.currentPostIndex];
    if (post.Type.integerValue != PostTypeMultiPic) {
        return;
    }
    NSArray *photos = [(FeedViewMultiPic *) collectionView.superview photos];
    XHImageViewer *imageViewer = [[XHImageViewer alloc]
            initWithImageViewerWillDismissWithSelectedViewBlock:
                    ^(XHImageViewer *imageViewer, UIImageView *selectedView) {
                        NSInteger index = [photos indexOfObject:selectedView];
                        post.DefaultIndex = [NSNumber numberWithInteger:index];
                        //                                   [self.swipeableView discardAllSwipeableViews];
                        //                                   [self.swipeableView loadNextSwipeableViewsIfNeeded];
                    }
                                didDismissWithSelectedViewBlock:^(XHImageViewer *imageViewer,
                                        UIImageView *selectedView) {
                                    [selectedView removeFromSuperview];
                                    NSInteger index = [photos indexOfObject:selectedView];
                                    [collectionView reloadData];
                                    [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                                }
                                      didChangeToImageViewBlock:^(XHImageViewer *imageViewer,
                                              UIImageView *selectedView) {
                                          NSInteger index = [photos indexOfObject:selectedView];
                                          [self.bottomToolBar.btnCenter setTitle:[NSString stringWithFormat:@"%ld/%lu", index + 1, (unsigned long) photos.count] forState:UIControlStateNormal];
                                      }];
    imageViewer.delegate = self;
    imageViewer.disableTouchDismiss = NO;
    [imageViewer showWithImageViews:photos
                       selectedView:photos[post.DefaultIndex.integerValue]];

    NSInteger index = post.DefaultIndex.integerValue;
    [self.bottomToolBar.btnCenter setTitle:[NSString stringWithFormat:@"%ld/%lu", index + 1, (unsigned long) photos.count] forState:UIControlStateNormal];
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    switch (direction) {
        case ZLSwipeableViewDirectionLeft:
        case ZLSwipeableViewDirectionRight:
            if (![[ApplicationData sharedInstance] currentUser]) {
                // Login Required
                [self btnLoginSignUpTapped:nil];
                break;
            } else {
                [self ratePost:self.itemsArray[self.currentPostIndex] direction:direction];
            }
            // Delete Current Object & Move to Next Object
//            [self.swipeableView discardAllSwipeableViews];
            [self.itemsArray removeObjectAtIndex:self.currentPostIndex];
            [self.swipeableView loadNextSwipeableViewsIfNeeded]; // Load Next Image
            break;

        case ZLSwipeableViewDirectionUp:
            // Move To Next Object
//            [self.swipeableView discardAllSwipeableViews];
            self.currentPostIndex++;
            [self.swipeableView loadNextSwipeableViewsIfNeeded];
            break;

        case ZLSwipeableViewDirectionDown:
            if (self.currentPostIndex == 0) {
                NSLog(@"This is the first object");
//                [self.swipeableView discardAllSwipeableViews];
                [self.swipeableView loadNextSwipeableViewsIfNeeded];
            } else {
                self.currentPostIndex--;
//                [self.swipeableView discardAllSwipeableViews];
                [self.swipeableView loadNextSwipeableViewsIfNeeded];
            }
            break;

        default:
            break;
    }
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view {
    FeedViewGoOrNo *feedView = view.subviews[0];
    feedView.noLabel.alpha = 0.0f;
    feedView.yesLabel.alpha = 0.0f;
}

//
//- (void)swipeableView:(ZLSwipeableView *)swipeableView
//  didStartSwipingView:(UIView *)view
//           atLocation:(CGPoint)location {
//  NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
//}
//
- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    //  NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f", location.x, location.y, translation.x, translation.y);
    //swipe right
    FeedViewGoOrNo *feedView = view.subviews[0];
    if (translation.x >= 0) {
        float scale = translation.x / 100.0;
        feedView.yesLabel.transform = CGAffineTransformMakeScale(scale, scale);
        feedView.noLabel.alpha = 0.0f;
    }
        //swipe left
    else if (translation.x < 0) {
        float scale = -translation.x / 100.0;
        feedView.noLabel.transform = CGAffineTransformMakeScale(scale, scale);
        feedView.yesLabel.alpha = 0.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == 0) ? 200 : 100;
}

- (IBAction)btnLoginSignUpTapped:(UIButton *)sender {
    [self showLoginPopoverWithDelegate:self completion:nil];
}

#pragma FeedViewGoOrNoDelegate

- (void)feedViewClickedImage:(FeedViewGoOrNo *)view {

}

#pragma mark - XHImageViewerDelegate

- (UIView *)customBottomToolBarOfImageViewer:(XHImageViewer *)imageViewer {
    return self.bottomToolBar;
}

//// This method simulates previously blank photos loading their images after some time.
//- (void)updateImagesOnPhotosViewController:(NYTPhotosViewController *)photosViewController afterDelayWithPhotos:(NSArray *)photos {
//  CGFloat updateImageDelay = 5.0;
//  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(updateImageDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    for (GNPhoto *photo in photos) {
//      if (!photo.image) {
//        // Photo credit: Nic Lehoux
//        photo.image = [UIImage imageNamed:@"NYTimesBuilding"];
//        [photosViewController updateImageForPhoto:photo];
//      }
//    }
//  });
//}

//#pragma mark - IDMPhotoBrowser Delegate
//
//- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)pageIndex
//{
//  id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
//  NSLog(@"Did show photoBrowser with photo index: %d, photo caption: %@", pageIndex, photo.caption);
//}
//
//- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser willDismissAtPageIndex:(NSUInteger)pageIndex
//{
//  id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
//  NSLog(@"Will dismiss photoBrowser with photo index: %d, photo caption: %@", pageIndex, photo.caption);
//}
//
//- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)pageIndex
//{
//  id <IDMPhoto> photo = [photoBrowser photoAtIndex:pageIndex];
//  NSLog(@"Did dismiss photoBrowser with photo index: %d, photo caption: %@", pageIndex, photo.caption);
//}
//
//- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex
//{
//  id <IDMPhoto> photo = [photoBrowser photoAtIndex:photoIndex];
//  NSLog(@"Did dismiss actionSheet with photo index: %d, photo caption: %@", photoIndex, photo.caption);
//
//  NSString *title = [NSString stringWithFormat:@"Option %d", buttonIndex+1];
////  [UIAlertView showAlertViewWithTitle:title];
//}

#pragma mark - Private (Move these method to category)
#pragma mark Current Post View

- (UIView *)goOrNoView:(ZLSwipeableView *)swipeableView {
    UIView *view = [[UIView alloc] initWithFrame:swipeableView.bounds];
    FeedViewGoOrNo *contentView =
            [[[NSBundle mainBundle] loadNibNamed:@"FeedViewGoOrNo"
                                           owner:self
                                         options:nil] objectAtIndex:0];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:contentView];
    // This is important:
    // https://github.com/zhxnlai/ZLSwipeableView/issues/9
    NSDictionary *metrics = @{
            @"height" : @(view.bounds.size.height),
            @"width" : @(view.bounds.size.width)
    };
    NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
    [view addConstraints:
            [NSLayoutConstraint
                    constraintsWithVisualFormat:@"H:|[contentView(width)]"
                                        options:0
                                        metrics:metrics
                                          views:views]];
    [view addConstraints:[NSLayoutConstraint
            constraintsWithVisualFormat:
                    @"V:|[contentView(height)]"
                                options:0
                                metrics:metrics
                                  views:views]];

    //Configure the view
    GNPost *post = self.itemsArray[self.currentPostIndex];
    NSString *question = (post.QuestionID.integerValue >= 0) ? [[[ApplicationData sharedInstance] questions][post.QuestionID.integerValue] description] : post.CustomQuestion;
    contentView.lblQuestion.text = question;
    [contentView.imageViewPic setImageWithURL:[NSURL URLWithString:CognitoS3ImagePath(post.DefaultImage)] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    NSString *dateTime = [[NSDate dateWithTimeIntervalSince1970:post.Date.doubleValue] timeAgo];
    [contentView.btnTime setTitle:[NSString stringWithFormat:@"  %@", dateTime] forState:UIControlStateNormal];
    [self refreshStylesForPost:post];
//    [self setNavigationBackgroundColor:post.BackgroundColor titleColor:post.TextColor];
//    [self setMenuButtonWithColor:post.TextColor];
    [self setTitle:post.NavigationTitle];
    [self setToolbarItems:[self postToolBarItems]];
    contentView.delegate = self;
    CGFloat borderWidth = 1.0f;
    contentView.frame = CGRectInset(contentView.frame, -borderWidth, -borderWidth);
    contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentView.layer.borderWidth = borderWidth;
    return view;
}

- (UIView *)multiPicView:(ZLSwipeableView *)swipeableView {
    UIView *view = [[UIView alloc] initWithFrame:swipeableView.bounds];
    FeedViewMultiPic *contentView =
            [[[NSBundle mainBundle] loadNibNamed:@"FeedViewMultiPic"
                                           owner:self
                                         options:nil] objectAtIndex:0];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:contentView];
    // This is important:
    // https://github.com/zhxnlai/ZLSwipeableView/issues/9
    NSDictionary *metrics = @{
            @"height" : @(view.bounds.size.height),
            @"width" : @(view.bounds.size.width)
    };
    NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
    [view addConstraints:
            [NSLayoutConstraint
                    constraintsWithVisualFormat:@"H:|[contentView(width)]"
                                        options:0
                                        metrics:metrics
                                          views:views]];
    [view addConstraints:[NSLayoutConstraint
            constraintsWithVisualFormat:
                    @"V:|[contentView(height)]"
                                options:0
                                metrics:metrics
                                  views:views]];

    //Configure the view
    GNPost *post = self.itemsArray[self.currentPostIndex];
    contentView.collectionView.tag = TAG_CollectionView_MultiPic;
    [contentView.collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
    // Create an array to store XHCustomImageView objects
    XHCustomImageView *photo;
    NSMutableArray *photos = [NSMutableArray new];
    NSString *imageName = [post valueForKey:[NSString stringWithFormat:@"S3Image%d", 0]];
    for (int i = 0; imageName != nil; i++) {
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        CGRect frame = CGRectMake(0.0, 0.0, width, width);
        photo = [[XHCustomImageView alloc] initWithFrame:frame];
        photo.contentMode = UIViewContentModeScaleAspectFill;
        photo.imageUrl = CognitoS3ImagePath(imageName);
        photo.imageThumbnailUrl = photo.imageUrl;
        [photo loadWithURL:[NSURL URLWithString:photo.imageUrl] placeholer:nil showActivityIndicatorView:NO];
        [photos addObject:photo];
        imageName = (i >= 4) ? nil : [post valueForKey:[NSString stringWithFormat:@"S3Image%d", i + 1]];
    }
    contentView.photos = photos;
    contentView.collectionView.dataSource = self;
    contentView.collectionView.delegate = self;
    [contentView.collectionView reloadData];
    [self performSelector:@selector(scrollToDefaultIndex:) withObject:contentView.collectionView afterDelay:0.1];
    NSString *question = (post.QuestionID.integerValue >= 0) ? [[[ApplicationData sharedInstance] questions][post.QuestionID.integerValue] description] : post.CustomQuestion;
    contentView.lblQuestion.text = question;
    NSString *dateTime = [[NSDate dateWithTimeIntervalSince1970:post.Date.doubleValue] timeAgo];
    [contentView.btnTime setTitle:[NSString stringWithFormat:@"  %@", dateTime] forState:UIControlStateNormal];
    [self refreshStylesForPost:post];
//    [self setNavigationBackgroundColor:post.BackgroundColor titleColor:post.TextColor];
//    [self setMenuButtonWithColor:post.TextColor];
    [self setTitle:post.NavigationTitle];
    [self setToolbarItems:[self postToolBarItems]];
    contentView.delegate = self;
    CGFloat borderWidth = 1.0f;
    contentView.frame = CGRectInset(contentView.frame, -borderWidth, -borderWidth);
    contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentView.layer.borderWidth = borderWidth;
    return view;
}

- (void)scrollToDefaultIndex:(UICollectionView *)collectionView {
    GNPost *post = self.itemsArray[self.currentPostIndex];
    [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:post.DefaultIndex.integerValue inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (UIView *)multiAnswerView:(ZLSwipeableView *)swipeableView {
    UIView *view = [[UIView alloc] initWithFrame:swipeableView.bounds];
    FeedViewMultiAnswer *contentView =
            [[NSBundle mainBundle] loadNibNamed:@"FeedViewMultiAnswer"
                                          owner:self
                                        options:nil][0];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:contentView];
    // This is important:
    // https://github.com/zhxnlai/ZLSwipeableView/issues/9
    NSDictionary *metrics = @{
            @"height" : @(view.bounds.size.height),
            @"width" : @(view.bounds.size.width)
    };
    NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
    [view addConstraints:
            [NSLayoutConstraint
                    constraintsWithVisualFormat:@"H:|[contentView(width)]"
                                        options:0
                                        metrics:metrics
                                          views:views]];
    [view addConstraints:[NSLayoutConstraint
            constraintsWithVisualFormat:
                    @"V:|[contentView(height)]"
                                options:0
                                metrics:metrics
                                  views:views]];

    //Configure the view
    GNPost *post = self.itemsArray[self.currentPostIndex];
    [contentView.collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
    contentView.collectionView.tag = TAG_CollectionView_MultiAnswer;
    contentView.collectionView.dataSource = self;
    contentView.collectionView.delegate = self;
    [contentView.collectionView reloadData];
    NSString *question = (post.QuestionID.integerValue >= 0) ? [[[ApplicationData sharedInstance] questions][post.QuestionID.integerValue] description] : post.CustomQuestion;
    contentView.lblQuestion.text = question;
    [contentView.imageViewPic setImageWithURL:[NSURL URLWithString:CognitoS3ImagePath(post.DefaultImage)] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    NSString *dateTime = [[NSDate dateWithTimeIntervalSince1970:post.Date.doubleValue] timeAgo];
    [contentView.btnTime setTitle:[NSString stringWithFormat:@"  %@", dateTime] forState:UIControlStateNormal];
    [self refreshStylesForPost:post];
//    [self setNavigationBackgroundColor:post.BackgroundColor titleColor:post.TextColor];
//    [self setMenuButtonWithColor:post.TextColor];
    [self setTitle:post.NavigationTitle];
    [self setToolbarItems:[self postToolBarItems]];
    contentView.delegate = self;
    CGFloat borderWidth = 1.0f;
    contentView.frame = CGRectInset(contentView.frame, -borderWidth, -borderWidth);
    contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentView.layer.borderWidth = borderWidth;
    return view;
}

- (UIView *)ratePlaceView:(ZLSwipeableView *)swipeableView {
    UIView *view = [[UIView alloc] initWithFrame:swipeableView.bounds];
    FeedViewRatePlace *contentView =
            [[NSBundle mainBundle] loadNibNamed:@"FeedViewRatePlace"
                                          owner:self
                                        options:nil][0];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:contentView];
    // This is important:
    // https://github.com/zhxnlai/ZLSwipeableView/issues/9
    NSDictionary *metrics = @{
            @"height" : @(view.bounds.size.height),
            @"width" : @(view.bounds.size.width)
    };
    NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
    [view addConstraints:
            [NSLayoutConstraint
                    constraintsWithVisualFormat:@"H:|[contentView(width)]"
                                        options:0
                                        metrics:metrics
                                          views:views]];
    [view addConstraints:[NSLayoutConstraint
            constraintsWithVisualFormat:
                    @"V:|[contentView(height)]"
                                options:0
                                metrics:metrics
                                  views:views]];

    //Configure the view
    GNPost *post = self.itemsArray[self.currentPostIndex];
    [contentView.collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
    contentView.collectionView.tag = TAG_CollectionView_RatePlace;
    contentView.collectionView.dataSource = self;
    contentView.collectionView.delegate = self;
    [contentView.collectionView reloadData];

    //Show Place Location
    contentView.mapView.delegate = self;
    for (id <MKAnnotation> annotation in contentView.mapView.annotations) {
        [contentView.mapView removeAnnotation:annotation];
    }
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = post.Latitude.doubleValue;
    coordinate.longitude = post.Longitude.doubleValue;
    UIPlacePickerAnnotation *annotation = [[UIPlacePickerAnnotation alloc] initWithCoordinate:coordinate];
    [contentView.mapView addAnnotation:annotation];
    CLLocationCoordinate2D zoomLocation = annotation.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [contentView.mapView regionThatFits:viewRegion];
    [contentView.mapView setRegion:adjustedRegion animated:YES];

    NSString *question = (post.QuestionID.integerValue >= 0) ? [[[ApplicationData sharedInstance] questions][post.QuestionID.integerValue] description] : post.CustomQuestion;
    contentView.lblQuestion.text = question;
    //  [contentView.imageViewPic setImageWithURL:[NSURL URLWithString:CognitoS3ImagePath(post.DefaultImage)] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    NSString *dateTime = [[NSDate dateWithTimeIntervalSince1970:post.Date.doubleValue] timeAgo];
    [contentView.btnTime setTitle:[NSString stringWithFormat:@"  %@", dateTime] forState:UIControlStateNormal];
    [self refreshStylesForPost:post];
//    [self setNavigationBackgroundColor:post.BackgroundColor titleColor:post.TextColor];
//    [self setMenuButtonWithColor:post.TextColor];
    [self setTitle:post.NavigationTitle];
    [self setToolbarItems:[self postToolBarItems]];
    contentView.delegate = self;
    CGFloat borderWidth = 1.0f;
    contentView.frame = CGRectInset(contentView.frame, -borderWidth, -borderWidth);
    contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentView.layer.borderWidth = borderWidth;
    return view;
}

#pragma mark MapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    static NSString *identifier = @"Location";
    if ([annotation isKindOfClass:[UIPlacePickerAnnotation class]]) {

        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }

        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        //    annotationView.image=[UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins

        return annotationView;
    }

    return nil;
}

#pragma mark Rate Post

- (void)ratePost:(GNPost *)post direction:(ZLSwipeableViewDirection)direction {
    switch (post.Type.integerValue) {
        case PostTypeGoNo:
        case PostTypeRatePlace:
            [self rateGoNo:post direction:direction];
            break;

        case PostTypeMultiPic:
            [self rateMultiPic:post direction:direction];
            break;

        case PostTypeMultiAnswer:
            [self rateMultiAnswer:post direction:direction];
            break;
        default:
            break;
    }
}

- (void)rateGoNo:(GNPost *)post direction:(ZLSwipeableViewDirection)direction {
    if (direction == ZLSwipeableViewDirectionRight) {
        // Webservice - Go
        GNRating *rating = [GNRating new];
        rating.UserID = [[ApplicationData sharedInstance] currentUser].UserID;
        rating.PostID = [post PostID];
        rating.RatingID = [[NSUUID UUID] UUIDString];
        rating.RatingStatus = RatingStatusMake(RatingStatusGo);
        [[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:rating];
        
        if (self.showSelectedPost) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } else {
        // Webservice - No
        GNRating *rating = [GNRating new];
        rating.UserID = [[ApplicationData sharedInstance] currentUser].UserID;
        rating.PostID = [post PostID];
        rating.RatingID = [[NSUUID UUID] UUIDString];
        rating.RatingStatus = RatingStatusMake(RatingStatusNo);
        [[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:rating];
        if (self.showSelectedPost) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)rateMultiPic:(GNPost *)post direction:(ZLSwipeableViewDirection)direction {
    // Webservice - Rate Multi-pic
    GNRating *rating = [GNRating new];
    rating.UserID = [[ApplicationData sharedInstance] currentUser].UserID;
    rating.PostID = [post PostID];
    rating.RatingID = [[NSUUID UUID] UUIDString];
    rating.RatingStatus = RatingStatusMake(post.PostRatingStatus);
    [[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:rating];
    if (self.showSelectedPost) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rateMultiAnswer:(GNPost *)post direction:(ZLSwipeableViewDirection)direction {
    // Webservice - Rate Multi-pic
    GNRating *rating = [GNRating new];
    rating.UserID = [[ApplicationData sharedInstance] currentUser].UserID;
    rating.PostID = [post PostID];
    rating.RatingID = [[NSUUID UUID] UUIDString];
    rating.RatingStatus = RatingStatusMake(post.PostRatingStatus);
    [[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:rating];
    
    if (self.showSelectedPost) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ToolBarItems

- (NSArray *)postToolBarItems {
    GNPost *post = self.itemsArray[self.currentPostIndex];
    NSArray *items = nil;
    switch ((PostType) post.Type.integerValue) {
        case PostTypeGoNo:
            items = [self goOrNoToolBarItems];
            break;
        case PostTypeMultiPic:
            items = [self multiImageToolBarItems];
            break;
        case PostTypeMultiAnswer:
            items = [self multiImageToolBarItems];
            break;
        case PostTypeRatePlace:
            items = [self goOrNoToolBarItems];
            break;
        default:
            break;
    }
    return items;
}

- (NSArray *)goOrNoToolBarItems {
    CGRect screenFrame = self.navigationController.toolbar.frame;

    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width / 2 - 20, screenFrame.size.height)];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width / 2 - 20, screenFrame.size.height)];
    UIImage *image2 = [[UIImage imageNamed:@"btn-no"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button2 setImage:image2 forState:UIControlStateNormal];
    [button2 setTitle:@" No" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 addTarget:self.swipeableView action:@selector(swipeTopViewToLeft) forControlEvents:UIControlEventTouchUpInside];
//    button2.tintColor = [UIColor blackColor];
    [view2 addSubview:button2];

    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(screenFrame.size.width / 2 + 20, 0, screenFrame.size.width / 2, screenFrame.size.height)];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width / 2 - 20, screenFrame.size.height)];
    UIImage *image1 = [[UIImage imageNamed:@"btn-go"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button1 setImage:image1 forState:UIControlStateNormal];
    [button1 setTitle:@" Go" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self.swipeableView action:@selector(swipeTopViewToRight) forControlEvents:UIControlEventTouchUpInside];
//    button1.tintColor = [UIColor blackColor];
    [view1 addSubview:button1];

    NSArray *items = @[[[UIBarButtonItem alloc] initWithCustomView:view2], [[UIBarButtonItem alloc] initWithCustomView:view1]];
    return items;

}

- (NSArray *)multiImageToolBarItems {
    CGRect screenFrame = self.navigationController.toolbar.frame;

    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width - 20, screenFrame.size.height)];
    UIButton *button2 = [[UIButton alloc] initWithFrame:view2.frame];
    [button2 setImage:[UIImage imageNamed:@"btn-thatsit"] forState:UIControlStateNormal];
    [button2 setTitle:@" That's it" forState:UIControlStateNormal];
    [button2 addTarget:self.swipeableView action:@selector(swipeTopViewToRight) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:button2];

    NSArray *items = @[[[UIBarButtonItem alloc] initWithCustomView:view2]];
    return items;

}

- (void) adjustMenuButtons {
    
    double radianConstant = 0.0174;
    
    UIButton *settings      = (UIButton *) [menuView viewWithTag:1];
    UIButton *notifications = (UIButton *) [menuView viewWithTag:2];
    UIButton *rulings       = (UIButton *) [menuView viewWithTag:3];
    UIButton *statistics    = (UIButton *) [menuView viewWithTag:4];
    UIButton *profile       = (UIButton *) [menuView viewWithTag:5];
    
    [settings       setTransform:CGAffineTransformMakeRotation(15 * radianConstant)];
    [notifications  setTransform:CGAffineTransformMakeRotation(85 * radianConstant)];
    [rulings        setTransform:CGAffineTransformMakeRotation(160 * radianConstant)];
    [statistics     setTransform:CGAffineTransformMakeRotation(230 * radianConstant)];
    [profile        setTransform:CGAffineTransformMakeRotation(300 * radianConstant)];
    
    
//    CGRect frame = menuView.frame;
//    frame.origin.x = -200;
//    menuView.frame = frame;
}

-(void) toggleMenu:(BOOL) show {
    
/*    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[menuView]];
    [self.animator addBehavior:gravityBehavior];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[menuView]];
    [collisionBehavior setTranslatesReferenceBoundsIntoBoundary:YES];
    [self.animator addBehavior:collisionBehavior];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[menuView]];
    [itemBehavior setElasticity:3];
    [self.animator addBehavior:itemBehavior];*/
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (menuView.frame.origin.x < 0) {
            CGRect frame = menuView.frame;
            frame.origin.x = 0;
            menuView.frame = frame;
        }
        else {
            CGRect frame = menuView.frame;
            frame.origin.x = -200;
            menuView.frame = frame;
        }
        
    }];

}

- (IBAction)menuButtonTapped:(id)sender {
    
    [self toggleMenu:YES];
}


-(IBAction)settingsButtonPressed:(id)sender {
    
    SettingsViewController *settingsViewObj = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsViewObj animated:YES];

}

-(IBAction)profileButtonPressed:(id)sender {
    
    if ([[ApplicationData sharedInstance] currentUser] == nil) {
        
        [self showLoginPopoverWithDelegate:self completion:nil];
        return;
    }
    
    if ([ApplicationData sharedInstance].currentUser.UserType.integerValue == UserTypeAnonymous) {
        
        [RMUniversalAlert showAlertInViewController:self
                                          withTitle:@"Info"
                                            message:@"Only registered users can view their profiles"
                                  cancelButtonTitle:@"Ok"
                             destructiveButtonTitle:nil
                                  otherButtonTitles:nil
                                           tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex) {
                                               
                                               
                                           }];
        return;
    }
    
    ProfileViewController *profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self.navigationController pushViewController:profileView animated:YES];
}


-(IBAction)rulingsButtonPressed:(id)sender {
    
    StatisticsRulingViewController *ruling = [self.storyboard instantiateViewControllerWithIdentifier:@"StatisticsRulingViewController"];
    ruling.isStat = NO;
    [self.navigationController pushViewController:ruling animated:YES];
}

-(IBAction)statisticsButtonPressed:(id)sender {
    
    StatisticsRulingViewController *stats = [self.storyboard instantiateViewControllerWithIdentifier:@"StatisticsRulingViewController"];
    stats.isStat = YES;
    [self.navigationController pushViewController:stats animated:YES];
}

-(IBAction)notificatonsButtonPressed:(id)sender {
    
    NotificationsViewController *notifications = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationsViewController"];
    [self.navigationController pushViewController:notifications animated:YES];
}

@end
