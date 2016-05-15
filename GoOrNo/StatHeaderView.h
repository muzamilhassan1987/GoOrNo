//
//  StatHeaderView.h
//  GoOrNo
//
//  Created by Mavericks Machine on 6/5/15.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAProgressLabel.h"

@interface StatHeaderView : UIView

@property(nonatomic,strong) IBOutlet KAProgressLabel *kLabelYes;
@property(nonatomic,strong) IBOutlet KAProgressLabel *kLabelNo;
@property(nonatomic,strong) IBOutlet UILabel *labelReplyNumber;


@end
