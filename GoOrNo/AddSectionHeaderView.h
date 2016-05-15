//
//  AddHeader.h
//  GoOrNo
//
//  Created by O16 Labs on 25/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddSectionHeaderView;

@protocol AddSectionHeaderViewDelegate <NSObject>

@optional
- (void)sectionTapped:(NSInteger)section;

@end

@interface AddSectionHeaderView : UITableViewHeaderFooterView

@property(nonatomic, strong, readonly) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UILabel *lblSectionName;
@property (strong, nonatomic) IBOutlet UIButton *btnSection;
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,weak) id<AddSectionHeaderViewDelegate> delegate;
- (IBAction)btnSectionTapped:(UIButton *)sender;

@end
