//
//  ARMarkerView.m
//  MashApp-location_users-ar-ios
//
//  Created by Igor Khomenko on 3/26/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import "ARMarkerView.h"

#define markerWidth 100
#define markerHeight 65

@implementation ARMarkerView

@synthesize target;
@synthesize action;
@synthesize userStatus, userPhotoView, distanceLabel, userName, userAnnotation;
@synthesize distance;

- (id)initWithGeoPoint:(UserAnnotation *)_userAnnotation{
    	
	CGRect theFrame = CGRectMake(0, 0, markerWidth, markerHeight);
	
	if ((self = [super initWithFrame:theFrame])) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        // save user annotation
        self.userAnnotation = _userAnnotation;
        
        [self setUserInteractionEnabled:YES];
        
        // bg view for user name & status & photo
        //
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, markerWidth, markerHeight-10)];
        container.layer.cornerRadius = 5;
        container.clipsToBounds = YES;
        [container setBackgroundColor:[UIColor clearColor]];
        [self addSubview:container];
        [container release];
        
        
        // add user photo 
        //
		userPhotoView = [[AsyncImageView alloc] initWithFrame: CGRectMake(0, 0, 45, 45)];
		[userPhotoView loadImageFromURL:[NSURL URLWithString:_userAnnotation.userPhotoUrl]];
		[container addSubview: userPhotoView];
        [userPhotoView release];
        
        
        // add userName
        //
        UIImageView *userNameBG = [[UIImageView alloc] init];
        [userNameBG setFrame:CGRectMake(45, 0, 55, 23)];
        [userNameBG setImage:[UIImage imageFromResource:@"radarMarkerName@2x.png"]];
        [container addSubview: userNameBG];
        [userNameBG release];
        //
        userName = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, userNameBG.frame.size.width-3, userNameBG.frame.size.height)];
        [userName setBackgroundColor:[UIColor clearColor]];
        [userName setText:_userAnnotation.userName];
        [userName setFont:[UIFont boldSystemFontOfSize:11]];
        [userName setTextColor:[UIColor whiteColor]];
        [userNameBG addSubview:userName];
        [userName release];
        
        
        // add userStatus
        //
        UIImageView *userStatusBG = [[UIImageView alloc] init];
        [userStatusBG setFrame:CGRectMake(45, 23, 55, 22)];
        [userStatusBG setImage:[UIImage imageFromResource:@"radarMarkerStatus@2x.png"]]; 
        [container addSubview: userStatusBG];
        [userStatusBG release];
        //
        userStatus = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, userStatusBG.frame.size.width-3, userStatusBG.frame.size.height)];
        [userStatus setFont:[UIFont systemFontOfSize:11]];
        [userStatus setText:_userAnnotation.userStatus];
        [userStatus setBackgroundColor:[UIColor clearColor]];
        [userStatus setTextColor:[UIColor whiteColor]];
        [userStatusBG addSubview:userStatus];
        [userStatus release];
        
        
        // add arrow
        //
        UIImageView *arrow = [[UIImageView alloc] init];
        [arrow setImage:[UIImage imageFromResource:@"radarMarkerArrow@2x.png"]];
        [arrow setFrame:CGRectMake(45, 45, 10, 8)];
        [self addSubview: arrow];
        [arrow release];
        
        
        // distance
		distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, markerWidth, 10)];
		[distanceLabel setBackgroundColor:[UIColor clearColor]];
		[distanceLabel setTextColor:[UIColor whiteColor]];
        [distanceLabel setFont:[UIFont systemFontOfSize:11]];
		[distanceLabel setTextAlignment:UITextAlignmentCenter];
        [self addSubview:distanceLabel];
        [distanceLabel release];
	}
	
    return self;
}

- (CLLocationDistance) updateDistance:(CLLocation *)newOriginLocation{
    CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:userAnnotation.coordinate.latitude longitude:userAnnotation.coordinate.longitude];
    CLLocationDistance _distance = [pointLocation distanceFromLocation:newOriginLocation];
    
    distanceLabel.text = [NSString stringWithFormat:@"%.000f km", _distance/1000];

    distance = _distance;
    
    return _distance;
}

- (double)distanceFrom:(CLLocationCoordinate2D)locationA to:(CLLocationCoordinate2D)locationB{
    double R = 6368500.0; // in meters
    
    double lat1 = locationA.latitude*M_PI/180.0;
    double lon1 = locationA.longitude*M_PI/180.0;
    double lat2 = locationB.latitude*M_PI/180.0;
    double lon2 = locationB.longitude*M_PI/180.0;
    
    return acos(sin(lat1) * sin(lat2) + 
                cos(lat1) * cos(lat2) *
                cos(lon2 - lon1)) * R;
}

// touch action
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if([target respondsToSelector:action]){
        [target performSelector:action withObject:self];
    }
}

- (void)dealloc {
    [userAnnotation release];
    [super dealloc];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"distance=%d", distance];
}

@end
