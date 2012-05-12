//
//  MapViewController.m
//  Vkmsg
//
//  Created by Igor Khomenko on 3/27/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import "MapViewController.h"
#import "MapChatARViewController.h"
#import "UserAnnotation.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView;
@synthesize delegate;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [activityIndicator startAnimating];
    [mapView setUserInteractionEnabled:NO];
	
	MKCoordinateRegion region;
	//Set Zoom level using Span
	MKCoordinateSpan span;  
	region.center=mapView.region.center;
	span.latitudeDelta=150;
	span.longitudeDelta=150;
	region.span=span;
	[mapView setRegion:region animated:TRUE];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.mapView = nil;
    self.activityIndicator = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)pointsUpdated{
    
    [mapView addAnnotations:[((MapChatARViewController *)delegate) mapPoints]];
    
    [activityIndicator stopAnimating];
    [mapView setUserInteractionEnabled:YES];
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id < MKAnnotation >)annotation{
    static NSString *annotationReuseIdentifier = @"MapPinAnnotationIdentifier";
    
    MapMarkerView *marker = (MapMarkerView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:annotationReuseIdentifier];
    if(marker == nil){
        marker = [[[MapMarkerView alloc] initWithAnnotation:annotation 
                                       reuseIdentifier:annotationReuseIdentifier] autorelease];
        
        // set touch action
        marker.target = delegate;
        marker.action = @selector(touchOnMarker:);
    }
	marker.annotation = annotation;
    
	return marker;
}

@end
