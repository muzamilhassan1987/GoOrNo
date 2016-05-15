//
//  UserMultiAnswersViewController.m
//  GoOrNo
//
//  Created by Mavericks Machine on 6/6/15.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "UserMultiAnswersViewController.h"
#import "MultiUserTableViewCell.h"

@interface UserMultiAnswersViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *multiuserTableView;

@end

@implementation UserMultiAnswersViewController


#pragma mark - Private Methods

-(void)setViewContent{
    [self setTitle:@"Statistics"];
    [self setBackButton];
    
    [self setViewData];
}

-(void)setViewData{
    [self.labelAnswerDetail setText:[self.selectedPost AnswerAtIndex:self.selectedIndex]];
    if ([self.selectedPost.Type intValue] == PostTypeMultiPic){
        [self.MapImageView setImageWithURL:[NSURL URLWithString:CognitoS3ImagePath(self.selectedPost.S3Image0)] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.viewAnswer setHidden:YES];
    }
}

#pragma mark - UITableViewDatasource and Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MultiUserTableViewCell *cell = [self.multiuserTableView dequeueReusableCellWithIdentifier:@"MultiUserCell" forIndexPath:indexPath];
    
    switch ([self.selectedPost.Type intValue]) {
        case PostTypeMultiPic:
            
            break;
        case PostTypeMultiAnswer:
            
            break;
            
        default:
            break;
    }
    
    [cell setCellData:[self.allRatings objectAtIndex:indexPath.row] withUsers:[self.allUsers objectAtIndex:indexPath.row] index:(int)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
