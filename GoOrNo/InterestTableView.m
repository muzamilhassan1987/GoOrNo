//
//  InterestTableView.m
//  GoOrNo
//
//  Created by Asif Ali on 03/06/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "InterestTableView.h"
#import "ApplicationData.h"
#import "GNCategory.h"

@implementation InterestTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50.0;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50.0)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width - 40, 50.0)];
    
    [label setText:[NSString stringWithFormat:@"%d INTERESTS", [[[ApplicationData sharedInstance] categories] count]]];
    [label setFont:[UIFont fontWithName:@"Verdana" size:15.0]];
    [view addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, 1)];
    [line setBackgroundColor:[UIColor darkGrayColor]];
    [view addSubview:line];
    
    return view;
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[ApplicationData sharedInstance] categories] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"interestCell" forIndexPath:indexPath];
    
    GNCategory *category = [[ApplicationData sharedInstance] categories][indexPath.row];
    cell.textLabel.text = category.Name;
    cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:14.0];
    
    if ([_selectedCategories containsObject:category.CategoryID]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    GNCategory *category = [[ApplicationData sharedInstance] categories][indexPath.row];
    
    if (![_selectedCategories containsObject:category.CategoryID]) {

        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [self.delegateController interestDidSelect:category];
}

@end
