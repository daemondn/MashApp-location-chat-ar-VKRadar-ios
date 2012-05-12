//
//  BLBlobSearchRequest.h
//  BlobsService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>

/** there can be set all, some or none parameters in the filter */

@interface QBBlobSearchRequest : PagedRequest 
{
@private
	// Filters
	NSUInteger blobID;
	NSDate* created_at;
	NSUInteger userID;
	NSUInteger appID;
	NSArray* contentTypes;
	NSArray* tags;
	
	// Ranges
	NSDate* min_created_at;
	NSDate* max_created_at;
	NSUInteger min_size;
	NSUInteger max_size;
	
	// Sorts
	BOOL sort_asc;
	enum QBBlobSortByKind sort_by;	
}

/** @name Filters */
/** the id of owner */
@property (nonatomic) NSUInteger blobID;

/** Time of creation of instance */
@property (nonatomic, retain) NSDate* created_at;

/** user's ID, if this parameter was set, all instances with blob_owner.user_id = user_id would be returned */
@property (nonatomic) NSUInteger userID;

/** app's ID, if this parameter was set, all instances with blob_owner.app_id = app_id would be returned */
@property (nonatomic) NSUInteger appID;

/** it is possible to set a few types with coma */
@property (nonatomic, retain) NSArray* contentTypes;

/** the list of key words with coma */
@property (nonatomic, retain) NSArray* tags;

/** @name Ranges */
/** the minimal value of created date */
@property (nonatomic, retain) NSDate* min_created_at;

/** the maximal value of created date */
@property (nonatomic, retain) NSDate* max_created_at;

/** the minimal value of size */
@property (nonatomic) NSUInteger min_size;

/** the maximal value of size */
@property (nonatomic) NSUInteger max_size;


/** Sorts */
/** if set to YES, result must be sorted in ascending order */
@property (nonatomic) BOOL sort_asc;

/** if set, result must be sorted */
@property (nonatomic) enum QBBlobSortByKind sort_by;

@property (nonatomic, readonly) NSDictionary* dict;

@end
