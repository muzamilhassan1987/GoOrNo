//
//  FeedViewRatePlace.h
//  GoOrNo
//
//  Created by O16 Labs on 20/05/2015.
//  Copyright (c) 2015 O16-Labs. All rights reserved.
//

#import "FeedViewMultiAnswer.h"
#import <MapKit/MapKit.h>

@interface FeedViewRatePlace : FeedViewMultiAnswer

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@end
