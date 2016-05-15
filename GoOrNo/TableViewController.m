//
//  TableViewController.m
//  GoOrNo
//
//  Created by Ayaz Ahmed Memon on 25/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
