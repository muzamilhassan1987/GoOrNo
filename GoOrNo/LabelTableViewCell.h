//
//  LabelTableViewCell.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 18/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel * label;
@property (nonatomic,strong) IBOutlet UITextView * textView;
@property (nonatomic,strong) IBOutlet UILabel * lblCharactersCount;

@end
