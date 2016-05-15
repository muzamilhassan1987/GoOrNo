//
//  StatisticsRulingViewController.h
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 09/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ViewController.h"
#import "StatisticsDataSource.h"
#import "RulingDataSource.h"

@interface StatisticsRulingViewController : ViewController<StatCellDelegate>{
    
    __weak IBOutlet UIButton *buttonTime;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) ASCollectionViewDataSource *dataSource;

@property (nonatomic,assign) BOOL isStat;

@end
