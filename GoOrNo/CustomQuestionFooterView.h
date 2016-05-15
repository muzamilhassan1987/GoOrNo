//
//  CustomQuestionFooterView.h
//  GoOrNo
//
//  Created by O16 Labs on 27/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomQuestionFooterView;

@protocol CustomQuestionFooterViewDelegate <NSObject>

@optional
- (void)footerView:(CustomQuestionFooterView *)footerView customQuestionSaved:(NSString *)text;

@end

@interface CustomQuestionFooterView : UITableViewHeaderFooterView<UITextViewDelegate>
{
    
}
@property(nonatomic, strong, readonly) IBOutlet UIView *contentView;
@property (nonatomic,assign) NSInteger section;
@property (strong, nonatomic) IBOutlet UITextView *txtView;
@property (strong, nonatomic) IBOutlet UILabel *lblCharacterCount;
@property (nonatomic,weak) id<CustomQuestionFooterViewDelegate> delegate;
- (IBAction)btnSaveTapped:(UIButton *)sender;

@end
