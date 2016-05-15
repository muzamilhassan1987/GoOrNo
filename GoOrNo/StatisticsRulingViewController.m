//
//  StatisticsRulingViewController.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 09/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "StatisticsRulingViewController.h"
#import "StatsMainDetailViewController.h"

@interface StatisticsRulingViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
    __weak IBOutlet UIButton *buttonDetail;
    __weak IBOutlet UIView *viewAnswer;
}

@end

@implementation StatisticsRulingViewController

#pragma mark - Private Methods

-(void)setViewData{
    
    
    if (self.isStat) {
        self.title = @"Statistics";
        StatisticsDataSource *localSource = [[StatisticsDataSource alloc] initWithViewController:self];
        self.dataSource = localSource;
    }
    else{
        self.title = @"Ruling";
        self.dataSource = [[RulingDataSource alloc] initWithViewController:self];
    }
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self;
}

#pragma mark - Button Actions

- (IBAction)buttonSharePressed:(id)sender {
    
}

- (IBAction)buttonDetailTapped:(id)sender {
    
}

#pragma mark - UICollectionView

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGSize size = self.view.frame.size;
  return CGSizeMake((size.width-30)/2, 250.0);
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[ApplicationData sharedInstance] currentUser]) {
        [self.dataSource reloadDataSource];
    } else {
        [self showLoginPopoverWithDelegate:self completion:nil];
    }
    if (self.isStat) {
        [self setViewControllerClass:@"PostTypeMultiPic"];
    }
    else{
        [self setViewControllerClass:@"Ruling"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Collection View Cell Delegate Methods

-(void)ShowDetailScreen:(GNPost *)post{
    if (self.isStat){
//        [self.navigationController performSegueWithIdentifier:@"ShowStatMainDetail" sender:post];
        
        StatsMainDetailViewController * SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowStatMainDetail"];
        [SVC setSelectedPost:post];
        [self.navigationController pushViewController:SVC animated:YES];
    }
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"ShowStatMainDetail"]) {
         StatsMainDetailViewController *SVC = segue.destinationViewController;
         SVC.selectedPost = sender;
     }
 }


@end
