//
//  QBLGeoData.h
//  LocationService
//

//  Copyright 2011 Quickblox team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBLGeoDataSearchRequest;

/** QBLGeoData class declaration  */
/** Overview:*/
/** This class represents geo information. You can store user locations on server, and then retrieve them using filters and search. See QBLocationService  */

@interface QBLGeoData : Entity {
@private
	CLLocationDegrees latitude;
	CLLocationDegrees longitude;
	NSDate *created_at;
    NSUInteger userID;
	QBUUser *user;
    NSUInteger appID;
	NSString *status;
}
/** Latitude */
@property (nonatomic) CLLocationDegrees latitude;

/** Longitude */
@property (nonatomic) CLLocationDegrees longitude;

/** Date of creation */
@property (nonatomic, retain) NSDate *created_at;

/** User identifier */
@property (nonatomic, assign) NSUInteger userID;

/** User */
@property (nonatomic, retain) QBUUser *user;

/** Application identitider */
@property (nonatomic, assign) NSUInteger appID;

/** Status message */
@property (nonatomic, retain) NSString *status;

/** Obtain current geo data 
 @return QBLGeoData initialized with current location
 */
+ (QBLGeoData *)currentGeoData;

/** Obtain current geo data location
 @return CLLocation initialized with current geo data latitude & longitude
 */
- (CLLocation *) location;

@end