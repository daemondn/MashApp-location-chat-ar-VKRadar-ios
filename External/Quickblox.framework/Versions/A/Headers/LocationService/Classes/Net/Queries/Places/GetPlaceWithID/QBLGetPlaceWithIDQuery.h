//
//  QBLGetPlaceWithIDQuery.h
//  LocationService
//
//  Copyright 2012 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBLGetPlaceWithIDQuery : QBLPlacesQuery {
	NSUInteger placeID;
}
@property (nonatomic) NSUInteger placeID;

- (id)initWithPlaceID:(NSUInteger)placeID;

@end
