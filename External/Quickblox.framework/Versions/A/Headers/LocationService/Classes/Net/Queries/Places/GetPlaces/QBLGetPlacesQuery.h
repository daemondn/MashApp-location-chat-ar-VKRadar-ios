//
//  QBLGetPlacesQuery.h
//  LocationService
//
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBLGetPlacesQuery : QBLPlacesQuery {
	PagedRequest *pagedRequest;
}
@property (nonatomic, readonly) PagedRequest *pagedRequest;

-(id)initWithRequest:(PagedRequest *)_pagedRequest;

@end
