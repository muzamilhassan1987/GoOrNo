//
//  AddBaseViewController.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 16/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "AddBaseViewController.h"

#import "LabelTableViewCell.h"
#import "AddSectionHeaderView.h"
#import "CustomQuestionFooterView.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>
#import "ContactsViewController.h"
#import "GNCategory.h"
#import "WebClient.h"

@interface AddBaseViewController ()<CustomQuestionFooterViewDelegate, AddSectionHeaderViewDelegate> {
  NSInteger _openedSection;
  NSInteger _selectedCells[6];
    
}
@end

@implementation AddBaseViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableViewGetData.backgroundColor = [UIColor colorWithRed:232/255. green:232/255. blue:232/255. alpha:1.0];
  [self setBackButton];
  _openedSection = NSNotFound;
  // Do any additional setup after loading the view.
  self.tableViewGetData.dataSource = self;
  self.tableViewGetData.delegate = self;
  UIView * header = self.tableViewGetData.tableHeaderView;
  [header setNeedsLayout];
  [header layoutIfNeeded];
  
  CGFloat width = [[UIScreen mainScreen] bounds].size.width;
  CGRect frame = header.frame;
  frame.size.height = width;
  frame.size.width = width;
  header.frame = frame;
  self.tableViewGetData.tableHeaderView = header;
  self.tableViewGetData.tableFooterView = [UIView new];
  
  [self.tableViewGetData registerNib:[UINib nibWithNibName:@"AddSectionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"headerView"];
  [self.tableViewGetData registerNib:[UINib nibWithNibName:@"CustomQuestionFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"footerView"];
  
  self.pickerData = @[
                      @[@"Public",
                        @"Private"],
                      
                      [[ApplicationData sharedInstance] categories],
                      
                      [[ApplicationData sharedInstance] questions],
                      
                      [[ApplicationData sharedInstance] answers],
                      
                      [[ApplicationData sharedInstance] answers],
                      
                      [[ApplicationData sharedInstance] answers]
                      ];
  
  self.post = [GNPost new];
  self.post.UserID = [[[ApplicationData sharedInstance] currentUser] UserID];
  self.post.PostID = [[NSUUID UUID] UUIDString];
  //  AWSCategory * category = self.pickerData[1][0];
  //  self.post.CategoryID = category.Name;
  self.post.SharingScope = @"Public";
  _selectedCells[0] = 0;
  _selectedCells[1] = -1;
  _selectedCells[2] = -1;
  self.post.CustomQuestion = nil;
  self.post.QuestionID = [NSNumber numberWithInteger:-1];
  _selectedCells[3] = -1;
  self.post.Answer1 = nil;
  self.post.Answer1ID = [NSNumber numberWithInteger:-1];
  _selectedCells[4] = -1;
  self.post.Answer2 = nil;
  self.post.Answer2ID = [NSNumber numberWithInteger:-1];
  _selectedCells[5] = -1;
  self.post.Answer3 = nil;
  self.post.Answer3ID = [NSNumber numberWithInteger:-1];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableViewGetData reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)btnGoTapped:(id)sender {
  // Set Common Attributes Here
  self.post.Date = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
}
- (IBAction)btnNoTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

//- (IBAction)btnSelectQuestionTapped:(id)sender {
//  SelectQuestionViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectQuestionViewController"];
//  controller.delegate = self;
//  [self.navigationController pushViewController:controller animated:YES];
//}
//
//- (void)controller:(SelectQuestionViewController *)controller selectedQuestion:(NSString *)question {
//  [self.btnSelectedQuestion setTitle:question forState:UIControlStateNormal];
//}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  switch (self.post.Type.integerValue) {
    case PostTypeGoNo:
    case PostTypeMultiPic:
      return 3;
      break;
    case PostTypeMultiAnswer:
      return self.pickerData.count;
    case PostTypeRatePlace:
      return self.pickerData.count+1;
      
    default:
      break;
  }
  return (self.post.Type.integerValue == PostTypeMultiAnswer) ? self.pickerData.count : 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForHeaderCellAtSection:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  AddSectionHeaderView * headerView = [self.tableViewGetData dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
  if (headerView == nil) {
    headerView = [[AddSectionHeaderView alloc] initWithReuseIdentifier:@"headerView"];
  }
  
  [self configureSectionHeader:headerView inSection:section];
  
  return headerView;
}
- (void)configureSectionHeader:(AddSectionHeaderView *)headerView inSection:(NSInteger)section {
  headerView.delegate = self;
  headerView.section = section;
  switch (section) {
    case 0:
      headerView.lblSectionName.text = self.pickerData[section][_selectedCells[section]];//self.post.SharingScope;
      break;
    case 1:
//      NSLog(@"cat id: %@ --- %@", !self.post.CategoryID?@"Select Category":self.pickerData[section][_selectedCells[section]],self.post.CategoryID);
      headerView.lblSectionName.text = !self.post.CategoryID ? @"Select Category":[self.pickerData[section][_selectedCells[section]] description];//self.post.CategoryID;
      break;
    case 2:
    {
      headerView.lblSectionName.text = (self.post.CustomQuestion) ? self.post.CustomQuestion : @"Select Question";
      break;
    }
    case 3:
    {
      headerView.lblSectionName.text = (self.post.Answer1) ? self.post.Answer1 : @"Select 1st Answer";
      break;
    }
    case 4:
    {
      headerView.lblSectionName.text = (self.post.Answer2) ? self.post.Answer2 : @"Select 2nd Answer";
      break;
    }
    case 5:
    {
      headerView.lblSectionName.text = (self.post.Answer3) ? self.post.Answer3 : @"Select 3rd Answer";
      break;
    }
    case 6:
    {
      headerView.lblSectionName.text = (self.post.PlaceDescription) ? self.post.PlaceDescription : @"Tell something about this place";
      break;
    }
    default:
      break;
  }
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
  AddSectionHeaderView * headerView = (AddSectionHeaderView *)view;
  if (section == _openedSection) {
    headerView.btnSection.backgroundColor = [UIColor whiteColor];
  } else {
    headerView.btnSection.backgroundColor = [UIColor colorWithRed:232/255. green:232/255. blue:232/255. alpha:1.0];
  }
}
- (void)sectionTapped:(NSInteger)section {
    
//    _openedSection = section;
//    [self.tableViewGetData reloadData];
//    
//    return;
//    
  NSLog(@"Section %ld",(long)section);
  //  _openedSection = (_openedSection == section) ? NSNotFound : section;
  //  [self.tableViewGetData reloadData];
  
  //Zeeshan added this code
  if(section == _openedSection) {
    _openedSection = NSNotFound;
    NSInteger countOfRowsToDelete = [self.tableViewGetData numberOfRowsInSection:section];
    
    if (countOfRowsToDelete > 0) {
      NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
      for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
      }
      [self.tableViewGetData deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableViewGetData reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
  } else {
    NSInteger countOfRowsToInsert = (section>=6) ? 0 : [((NSArray *)self.pickerData[section]) count];
    
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
      [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    NSInteger previousOpenSectionIndex = _openedSection;
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    if(previousOpenSectionIndex != NSNotFound) {
      NSInteger countOfRowsToDelete = [self.tableViewGetData numberOfRowsInSection:previousOpenSectionIndex];
      for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
      }
    }
    
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || section < previousOpenSectionIndex) {
      insertAnimation = UITableViewRowAnimationTop;
      deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
      insertAnimation = UITableViewRowAnimationBottom;
      deleteAnimation = UITableViewRowAnimationTop;
    }
    
    _openedSection = section;
    
    // apply the updates
    [self.tableViewGetData beginUpdates];
    [self.tableViewGetData insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableViewGetData deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableViewGetData endUpdates];
    
    //Ayaz: Reload section to remove the footer view appearance bug
    [self.tableViewGetData reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationTop];
    
    NSInteger lastRowIndex = (section>=6) ? NSNotFound : [(NSArray *)self.pickerData[section] count]-1;
    [self.tableViewGetData scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(lastRowIndex>0)?lastRowIndex:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
  }
}
- (void)footerView:(CustomQuestionFooterView *)footerView customQuestionSaved:(NSString *)text {
  switch (footerView.section) {
    case 2:
      self.post.CustomQuestion = text;
      self.post.QuestionID = [NSNumber numberWithInteger:-1];
      break;
    case 3:
      self.post.Answer1 = text;
      self.post.Answer1ID = [NSNumber numberWithInteger:-1];
      break;
    case 4:
      self.post.Answer2 = text;
      self.post.Answer2ID = [NSNumber numberWithInteger:-1];
      break;
    case 5:
      self.post.Answer3 = text;
      self.post.Answer3ID = [NSNumber numberWithInteger:-1];
      break;
    case 6:
      self.post.PlaceDescription = text;
      break;
    default:
      break;
  }
  if (footerView.section <= 5) {
    _selectedCells[footerView.section]=-1;
  }
  _openedSection = NSNotFound;
  [self.tableViewGetData reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //  BOOL shouldShowCustomQuestion = (self.post.QuestionID.integerValue+1 == ((NSArray *)self.pickerData[2]).count);
  //  return (section==0) ? (shouldShowCustomQuestion ? 4 : 3) : self.post.TotalNumberOfAnswers.integerValue;
  if (_openedSection == section) {
    NSInteger number = (section >=6) ? 0 : [((NSArray *)self.pickerData[section]) count];
    return number;
  }
  return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  LabelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}
- (void)configureCell:(LabelTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  cell.label.text = [self.pickerData[indexPath.section][indexPath.row] description];
  
  if (_selectedCells[indexPath.section] == indexPath.row) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  _selectedCells[indexPath.section] = indexPath.row;
  switch (indexPath.section) {
    case 0:
      self.post.SharingScope = self.pickerData[indexPath.section][indexPath.row];
          if (indexPath.row == 1) {
              ContactsViewController *contacts = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactsViewController"];
              contacts.addPostController = self;
              [self.navigationController pushViewController:contacts animated:YES];
          }
      break;
    case 1:
      self.post.CategoryID = [NSNumber numberWithInteger:indexPath.row];
      break;
    case 2:
      self.post.QuestionID = [NSNumber numberWithInteger:indexPath.row];
      self.post.CustomQuestion = [self.pickerData[indexPath.section][_selectedCells[indexPath.section]] description];
      break;
    case 3:
      self.post.Answer1ID = [NSNumber numberWithInteger:indexPath.row];
      self.post.Answer1 = [self.pickerData[indexPath.section][_selectedCells[indexPath.section]] description];
      break;
    case 4:
      self.post.Answer2ID = [NSNumber numberWithInteger:indexPath.row];
      self.post.Answer2 = [self.pickerData[indexPath.section][_selectedCells[indexPath.section]] description];
      break;
    case 5:
      self.post.Answer3ID = [NSNumber numberWithInteger:indexPath.row];
      self.post.Answer3 = [self.pickerData[indexPath.section][_selectedCells[indexPath.section]] description];
      break;
    default:
      break;
  }
  
  AddSectionHeaderView *headerView = (AddSectionHeaderView *)[self.tableViewGetData headerViewForSection:indexPath.section];
  [self configureSectionHeader:headerView inSection:indexPath.section];
  
  [self sectionTapped:indexPath.section];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  if (section == _openedSection) {
    // Create or dequeue Footer view
    CustomQuestionFooterView * footerView = [self.tableViewGetData dequeueReusableHeaderFooterViewWithIdentifier:@"footerView"];
    if (footerView == nil) {
      footerView = [[CustomQuestionFooterView alloc] initWithReuseIdentifier:@"footerView"];
    }
    // Configure footer view
    footerView.section = section;
    footerView.delegate = self;
    switch (section) {
      case 2:
        footerView.txtView.text = (_selectedCells[section]<0) ? self.post.CustomQuestion : @"";
        footerView.txtView.placeholder = @"type your question here";
        break;
      case 3:
        footerView.txtView.text = (_selectedCells[section]<0) ? self.post.Answer1 : @"";
        footerView.txtView.placeholder = @"type 1st answer";
        break;
      case 4:
        footerView.txtView.text = (_selectedCells[section]<0) ? self.post.Answer2 : @"";
        footerView.txtView.placeholder = @"type 2nd answer";
        break;
      case 5:
        footerView.txtView.text = (_selectedCells[section]<0) ? self.post.Answer3 : @"";
        footerView.txtView.placeholder = @"type 3rd answer";
        break;
      case 6:
        footerView.txtView.text = (self.post.PlaceDescription) ? self.post.PlaceDescription : @"";
        footerView.txtView.placeholder = @"Tell something about this place";
        break;
      default:
        footerView.txtView.text = @"";
        break;
    }
    return footerView;
  }
  return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  CGFloat height = 0.0;
  if (section == _openedSection && section>=2) {
    switch (section) {
      case 3:
      case 4:
      case 5:
        height = (self.post.Type.integerValue == PostTypeMultiAnswer) ? 120.0 : 0.0;
        break;
      default:
        height = 120.0;
        break;
    }
  }
  return height;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
  CGFloat height = 0.0;
  switch (section) {
    case 3:
    case 4:
    case 5:
      height = (self.post.Type.integerValue == PostTypeMultiAnswer) ? 60.0 : 0.0;;
      break;
    default:
      height = 60.0;
      break;
  }
  return height;
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static LabelTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableViewGetData dequeueReusableCellWithIdentifier:@"Cell"];
    });
    
    [self configureCell:sizingCell atIndexPath:indexPath];
    
    CGFloat height = [self calculateHeightForConfiguredSizingCell:sizingCell];
    
    if(height < 44.0f) {
        return 44.0f;
    } else {
        return height;
    }
}
- (CGFloat)heightForHeaderCellAtSection:(NSInteger)section
{
    static AddSectionHeaderView *headerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        headerView = [self.tableViewGetData dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    });
    
    [self configureSectionHeader:headerView inSection:section];
    
    CGFloat height = [self calculateHeightForConfiguredSizingCell:headerView];
    
    NSLog(@"Height: %f",height);
    
    if(height < 60.0f) {
        return 60.0f;// Min height 44.0
    } else {
        return height;
    }
}
- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableViewGetData.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1.0f;
    // Add 1.0f for the cell separator height
}

-(void) contactsPickerDidSelectContacts:(NSDictionary *) users {
    
//    NSMutableArray *userIds = [NSMutableArray new];
//    for (GNUser *user in users) {
//        
//        [userIds addObject:user.UserID];
//    }
    self.post.InvitedUsers = [[users allKeys] componentsJoinedByString:@","];
    self.selectedUsers = [NSDictionary dictionaryWithDictionary:users];
}

-(void) sendNotificationToUsersWithParameters:(NSDictionary *) params {
    
    [[WebClient sharedClient] postPath:@"apns.php" parameters:params showLoading:@"Sending Invitations" success:^(id responseObject) {
       
        NSLog(@"responseObject:%@", responseObject);
    } failure:^(NSError *error) {
        
        
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
