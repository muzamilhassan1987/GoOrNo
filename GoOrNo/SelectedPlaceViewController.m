//
//  SelectedPlaceViewController.m
//  GoOrNo
//
//  Created by O16 Labs on 20/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "SelectedPlaceViewController.h"

@implementation SelectedPlaceViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _mapView.delegate = self;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
  
  static NSString *identifier = @"Location";
  if ([annotation isKindOfClass:[UIPlacePickerAnnotation class]]) {
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
      annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    } else {
      annotationView.annotation = annotation;
    }
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
//    annotationView.image=[UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
    
    return annotationView;
  }
  
  return nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self showLocation];
}

// Add new method above refreshTapped
- (void)showLocation {
  
  for (id<MKAnnotation> annotation in _mapView.annotations) {
    [_mapView removeAnnotation:annotation];
  }
  
  UIPlacePickerAnnotation *annotation = [[UIPlacePickerAnnotation alloc] initWithCoordinate:_place.location.coordinate];
  [_mapView addAnnotation:annotation];
  
  // 1
  CLLocationCoordinate2D zoomLocation = annotation.coordinate;
  
  // 2
  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
  // 3
  MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
  // 4
  [_mapView setRegion:adjustedRegion animated:YES];
}

@end
