//
//  BlobDeleteQuery.h
//  BlobsService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBBlobDeleteQuery : QBBlobQuery {
@private
	NSUInteger blobId;
}
@property (nonatomic,readonly) NSUInteger blobId;

-(id)initWithBlobId:(NSUInteger)blobid;

@end
