//
//  QBLLocationDataSource.h
//  LocationService
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBLLocationDataSource : NSObject<CLLocationManagerDelegate> {
	CLLocation *currentLocation;
	CLLocationManager* locationManager;
    
    SEL callbackSelectorForLocationUpdate;
    id callbackTargetForLocationUpdate;
}
@property (nonatomic,readonly) CLLocation* currentLocation;
@property (nonatomic,readonly) CLLocationManager* locationManager;
@property (nonatomic,readonly) BOOL locationAvailable;

+(QBLLocationDataSource *)instance;

- (void)setCallbackSelectorForLocationUpdate:(SEL)selector forTarget:(id)target;

@end