//
//  main.m
//  GoOrNo
//
//  Created by Kumar on 07/04/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <PixateFreestyle/PixateFreestyle.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [PixateFreestyle initializePixateFreestyle];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
