//
//  QBLUpdatePlaceQuery.h
//  LocationService
//
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBLUpdatePlaceQuery : QBLPlacesQuery {
    QBLPlace *placeData;
}
@property (nonatomic,retain) QBLPlace *placeData;

- (id)initWithPlace:(QBLPlace *)tplaceData;

@end