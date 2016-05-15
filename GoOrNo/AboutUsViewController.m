//
//  AboutUsViewController.m
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutUsModel.h"
#import "AboutUsCell.h"

@interface AboutUsViewController () <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableViewAboutUs;
    
    NSMutableArray *aboutUsArray;
}
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"About Us";
    [self setNavigationBackgroundColor:nil titleColor:[UIColor blackColor]];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self setBackButtonWithColor:[UIColor blackColor]];
    
    NSString *contentAboutUs = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"aboutus" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString *tAndC = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"privacypolicy" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString *general = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"general" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString *privacyPolicy = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"privacypolicy" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    
    
    AboutUsModel *aboutUsModel1 = [[AboutUsModel alloc] initWithSectionTitle:@"About Us" text:contentAboutUs];
    AboutUsModel *aboutUsModel2 = [[AboutUsModel alloc] initWithSectionTitle:@"Terms and Conditions" text:tAndC];
    AboutUsModel *aboutUsModel3 = [[AboutUsModel alloc] initWithSectionTitle:@"General" text:general];
    AboutUsModel *aboutUsModel4 = [[AboutUsModel alloc] initWithSectionTitle:@"Privacy Policy" text:privacyPolicy];
    
    aboutUsArray = [NSMutableArray arrayWithObjects:aboutUsModel1,aboutUsModel2,aboutUsModel3,aboutUsModel4, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDatasource and Delegates -
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return aboutUsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    AboutUsModel *aboutUsModel = [aboutUsArray objectAtIndex:section];
    return aboutUsModel.aboutUsSectionTitle;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = NSStringFromClass([AboutUsCell class]);
    AboutUsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)configureCell:(AboutUsCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    AboutUsModel *aboutUsModel = [aboutUsArray objectAtIndex:indexPath.section];
    
    [cell.lblAboutUs setText:aboutUsModel.aboutUsText];
}
- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static AboutUsCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableViewAboutUs dequeueReusableCellWithIdentifier:NSStringFromClass([AboutUsCell class])];
    });
    
    [self configureCell:sizingCell atIndexPath:indexPath];
    
    CGFloat height = [self calculateHeightForConfiguredSizingCell:sizingCell];
    
    if(height < 44.0f) {
        return 44.0f;
    } else {
        return height;
    }
}
- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableViewAboutUs.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1.0f;
    // Add 1.0f for the cell separator height
}
@end
