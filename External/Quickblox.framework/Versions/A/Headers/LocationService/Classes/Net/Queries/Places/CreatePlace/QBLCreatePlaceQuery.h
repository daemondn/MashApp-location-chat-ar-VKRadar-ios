//
//  QBLCreatePlaceQuery.h
//  LocationService
//
//  Copyright 2012 QuickBlox  team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBLPlace;

@interface QBLCreatePlaceQuery : QBLPlacesQuery {
	QBLPlace *placeData;
}

@property (nonatomic, readonly) QBLPlace *placeData;

-(id)initWithPlaceData:(QBLPlace *)_placeData;

@end