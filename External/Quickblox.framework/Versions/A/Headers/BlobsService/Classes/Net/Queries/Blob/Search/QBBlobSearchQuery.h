//
//  BLBlobSearchQuery.h
//  BlobsService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBBlobSearchRequest;
@interface QBBlobSearchQuery : QBBlobQuery {
	QBBlobSearchRequest* searchRequest;
}
@property (nonatomic,readonly) QBBlobSearchRequest* searchRequest;

-(id)initWithRequest:(QBBlobSearchRequest*)searchrequest;

@end
