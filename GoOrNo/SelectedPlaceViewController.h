//
//  SelectedPlaceViewController.h
//  GoOrNo
//
//  Created by O16 Labs on 20/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "UIPlacePicker.h"

@interface SelectedPlaceViewController : ViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UIPlace * place;
- (void)showLocation;

@end
