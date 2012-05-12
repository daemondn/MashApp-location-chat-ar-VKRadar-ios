//
//  QBLGeoDataDeleteQuery.h
//  LocationService
//
//  Created by Igor Khomenko on 2/3/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBLGeoDataDeleteRequest;

@interface QBLGeoDataDeleteQuery : QBLGeoDataQuery{
	QBLGeoDataDeleteRequest *deleteRequest;
}
@property (nonatomic, readonly) QBLGeoDataDeleteRequest *deleteRequest;

-(id)initWithRequest:(QBLGeoDataDeleteRequest *)_deleteRequest;

@end
