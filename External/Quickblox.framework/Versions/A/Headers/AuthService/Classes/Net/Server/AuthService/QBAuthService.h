//
//  QBAuthService.h
//  AuthService
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>

/** QBAuthService class declaration. */
/** Overview */
/** This class is the main entry point to work with Quickblox Auth module. */

@interface QBAuthService : BaseService {

}

#pragma mark -
#pragma mark App authorization

/**
 Session Creation
 
 Type of Result - QBAAuthSessionCreationResult.
 
 @param appID 
 @param authKey 
 @param authSecret 
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBAAuthSessionCreationResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+(NSObject<Cancelable> *)authorizeAppId:(NSUInteger)appID key:(NSString *)authKey secret:(NSString *)authSecret delegate:(NSObject<ActionStatusDelegate> *)delegate;
+(NSObject<Cancelable> *)authorizeAppId:(NSUInteger)appID key:(NSString *)authKey secret:(NSString *)authSecret delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark App authorization with extended Request

/**
 Session Creation with extended Request
 
 Type of Result - QBAAuthSessionCreationResult.
 
 @param appID 
 @param authKey 
 @param authSecret 
 @param extendedRequest
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBAAuthSessionCreationResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */

+(NSObject<Cancelable> *)authorizeAppId:(NSUInteger)appID key:(NSString *)authKey secret:(NSString *)authSecret withExtendedRequest:(QBASessionCreationRequest *)extendedRequest delegate:(NSObject<ActionStatusDelegate> *)delegate;
+(NSObject<Cancelable> *)authorizeAppId:(NSUInteger)appID key:(NSString *)authKey secret:(NSString *)authSecret withExtendedRequest:(QBASessionCreationRequest *)extendedRequest delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Delete session

/**
 Session Destroy
 
 Type of Result - QBAAuthResult.
 
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBAAuthResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+(NSObject<Cancelable> *)removeSessionWithDelegate:(NSObject<ActionStatusDelegate> *)delegate;
+(NSObject<Cancelable> *)removeSessionWithDelegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;

@end
