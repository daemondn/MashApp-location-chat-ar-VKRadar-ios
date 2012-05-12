//
//  MapViewController.h
//  Vkmsg
//
//  Created by Igor Khomenko on 3/27/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapMarkerView.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)pointsUpdated;

@end
