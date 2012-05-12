//
//  QBLocationService.h
//  LocationService
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>

/** QBLocationService class delcaration */
/** Overview */
/** This is a hub class for all Location related operations */

@interface QBLocationService : BaseService {
    
}

#pragma mark -
#pragma mark Post GeoData

/** 
 Post geo data 
 
 @param data An instance of QBLGeoData
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBGeoDataResult class.    
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation. 
 */
+ (NSObject<Cancelable> *)postGeoData:(QBLGeoData *)data delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)postGeoData:(QBLGeoData *)data delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Find GeoData

/** 
 Search geo data
 
 @param geoDataRequest Search request
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBGeoDataSearchResult class.    
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation. 
 */
+ (NSObject<Cancelable> *)findGeoData:(QBLGeoDataSearchRequest *)geoDataRequest delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)findGeoData:(QBLGeoDataSearchRequest *)geoDataRequest delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Delete GeoData

/** 
 Delete geo data
 
 @param deleteRequest Delete request
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation. Upon finish of the request, result will be an instance of QBGeoDataResult class.  
 */
+ (NSObject<Cancelable> *)deleteGeoDataWithRequest:(QBLGeoDataDeleteRequest *)deleteRequest delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)deleteGeoDataWithRequest:(QBLGeoDataDeleteRequest *)deleteRequest delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Create Place

/** 
 Create place
 
 @param data An instance of QBLPlace
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBLPlaceResult class.    
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation. 
 */
+ (NSObject<Cancelable> *)createPlace:(QBLPlace *)place delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)createPlace:(QBLPlace *)place delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Update Place

/** 
 Update place
 
 @param data An instance of QBLPlace
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBLPlaceResult class.    
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation. 
 */
+ (NSObject<Cancelable> *)updatePlace:(QBLPlace *)place delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)updatePlace:(QBLPlace *)place delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Get Places

/** 
 Get all places
 
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBLPlacePagedResult class.    
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation. 
 */
+ (NSObject<Cancelable> *)getPlacesWithDelegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getPlacesWithDelegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Get Places with paged result

/** 
 Get places with paged request
 
 @param pagedRequest Paged request
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBLPlacePagedResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation. 
 */
+ (NSObject<Cancelable> *)getPlacesWithPagedRequest:(PagedRequest *)pagedRequest delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getPlacesWithPagedRequest:(PagedRequest *)pagedRequest delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Get Place with ID

/** 
 Get place with ID
 
 @param placeID Place ID
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBLPlaceResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation. 
 */
+ (NSObject<Cancelable> *)getPlaceWithID:(NSUInteger)placeID delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getPlaceWithID:(NSUInteger)placeID delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Delete Place with ID

/** 
 Delete place with ID
 
 @param placeID Place ID
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBLPlaceResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation. 
 */
+ (NSObject<Cancelable> *)deletePlaceWithID:(NSUInteger)placeID delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)deletePlaceWithID:(NSUInteger)placeID delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


@end
