//
//  EditProfileViewController.m
//  GoOrNo
//
//  Created by O16 Labs on 14/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "EditProfileViewController.h"
#import "EditProfileCell.h"


@interface EditProfileViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *fields;
    NSMutableDictionary *values;
    UITextField *activeTextField;
}
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Profile";
    [self setNavigationBackgroundColor:nil titleColor:[UIColor blackColor]];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self setBackButtonWithColor:[UIColor blackColor]];
    [self addSaveButtonInNavigationBar];
    
    fields = @[@"Mobile",
               @"Email",
               @"City",
               @"Delete City"];
    
    values = [NSMutableDictionary dictionaryWithDictionary:
              @{@"Mobile" : [self textForProperty:[[ApplicationData sharedInstance] currentUser].Phone],
                @"Email" : [self textForProperty:[[ApplicationData sharedInstance] currentUser].Email],
                @"City" : [self textForProperty:[[ApplicationData sharedInstance] currentUser].City]}];
}

-(NSString *) textForProperty:(NSString *) property {
    
    return property.length == 0 ? @"-" : property;
}

-(void) saveButtonPressed:(id) sender {
    
    [activeTextField resignFirstResponder];
    
    [self performSelector:@selector(saveAndGoBack) withObject:nil afterDelay:0.5];
}

-(void) saveAndGoBack {
    
    [[[ApplicationData sharedInstance] currentUser] setPhone:values[@"Mobile"]];
    [[[ApplicationData sharedInstance] currentUser] setCity:values[@"City"]];
    
    [[[AmazonClientManager sharedInstance] dynamoDbObjectMapper] save:[[ApplicationData sharedInstance] currentUser]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView delegate & datasource

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [fields count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EditProfileCell *cell = (EditProfileCell *) [tableView dequeueReusableCellWithIdentifier:@"EditCell"
                                                            forIndexPath:indexPath];
    
    [cell.label setText:fields[indexPath.row]];
    [cell.valueField setText:values[fields[indexPath.row]]];
    [cell.valueField setTag:indexPath.row];
    cell.valueField.delegate = self;
    
    if(indexPath.row == 1) [cell.valueField setEnabled:NO];
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}

#pragma mark UITextField delegate

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    activeTextField = textField;
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    
    [values setObject:textField.text forKey:fields[textField.tag]];
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
