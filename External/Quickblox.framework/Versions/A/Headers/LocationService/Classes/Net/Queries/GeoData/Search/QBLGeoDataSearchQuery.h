//
//  QBLGeoDataSearchQuery.h
//  LocationService
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBLGeoDataSearchQuery : QBLGeoDataQuery {
	QBLGeoDataSearchRequest *searchRequest;
}
@property (nonatomic,readonly) QBLGeoDataSearchRequest *searchRequest;

-(id)initWithRequest:(QBLGeoDataSearchRequest *)_searchrequest;

@end