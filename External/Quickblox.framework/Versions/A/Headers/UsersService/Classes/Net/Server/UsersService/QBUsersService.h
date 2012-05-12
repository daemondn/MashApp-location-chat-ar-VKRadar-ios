//
//  QBUsersService.h
//  UsersService
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>

/** QBUsersService class declaration. */
/** Overview */
/** This class is the main entry point to work with Quickblox Users module, user data and profiles management. */

@interface QBUsersService : BaseService {

}

#pragma mark -
#pragma mark Authenticate

/**
 User Sign In
 
 Type of Result - QBUUserAuthenticateResult
 
 @param user An instance of QBUUser, describing the user to be authenticated.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserAuthenticateResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)authenticateUser:(QBUUser *)user delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)authenticateUser:(QBUUser *)user delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Logout

/**
 User Sign Out
 
 Type of Result - QBUUserLogoutResult
 
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserLogoutResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)logoutUser:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)logoutUser:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Get all Users for current application

/**
 Retrieve all Users for current application
 
 Type of Result - QBUUserPagedResult
 
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserPagedResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)getUsersWithDelegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getUsersWithDelegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;

/**
 Retrieve all Users for current application
 
 Type of Result - QBUUserPagedResult
 
 @param pagedRequest paged request
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserPagedResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)getUsersWithPagedRequest:(PagedRequest *)pagedRequest delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getUsersWithPagedRequest:(PagedRequest *)pagedRequest delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Create User

/**
 User sign up
 
 Type of Result - QBUUserResult
 
 @param user An instance of QBUUser, describing the user to be created.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)createUser:(QBUUser *)user delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)createUser:(QBUUser *)user delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Get User with ID

/**
 Retrieve User by identifier
 
 Type of Result - QBUUserResult
 
 @param userID ID of user to be retrieved.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)getUserWithID:(NSUInteger)userID delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getUserWithID:(NSUInteger)userID delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Get User with login

/**
 Retrieve User by login
 
 Type of Result - QBUUserResult
 
 @param userLogin Login of user to be retrieved.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)getUserWithLogin:(NSString *)userLogin delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getUserWithLogin:(NSString *)userLogin delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Get User with full name

/**
 Retrieve Users by full name
 
 Type of Result - QBUUserPagedResult
 
 
 @param userFullName Full name of user to be retrieved.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserPagedResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)getUsersWithFullName:(NSString *)userFullName delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getUsersWithFullName:(NSString *)userFullName delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;

/**
 Retrieve Users by full name
 
 Type of Result - QBUUserPagedResult
 
 @param userFullName Full name of user to be retrieved.
 @param pagedRequest paged request
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserPagedResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)getUsersWithFullName:(NSString *)userFullName request:(PagedRequest *)pagedRequest delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getUsersWithFullName:(NSString *)userFullName request:(PagedRequest *)pagedRequest delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Get User with Facebook ID

/**
 Retrieve User by Facebook ID
 
 Type of Result - QBUUserResult
 
 @param userFacebookID Facebook ID of user to be retrieved.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)getUserWithFacebookID:(NSString *)userFacebookID delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getUserWithFacebookID:(NSString *)userFacebookID delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Get User with Twitter ID

/**
 Retrieve User by Twitter ID
 
 Type of Result - QBUUserResult
 
 @param userTwitterID Twitter ID of user to be retrieved.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)getUserWithTwitterID:(NSString *)userTwitterID delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getUserWithTwitterID:(NSString *)userTwitterID delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Get User with email

/**
 Retrieve User by Email
 
 Type of Result - QBUUserResult
 
 @param userEmail Email of user to be retrieved.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)getUserWithEmail:(NSString *)userEmail delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getUserWithEmail:(NSString *)userEmail delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Get User with external ID

/**
 Retrieve User by External identifier
 
 Type of Result - QBUUserResult
 
 @param userExternalID External ID of user to be retrieved.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)getUserWithExternalID:(NSUInteger)userExternalID delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getUserWithExternalID:(NSUInteger)userExternalID delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Edit User

/**
 Update User
 
 Type of Result - QBUUserResult
 
 @param user An instance of QBUUser, describing the user to be edited.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)editUser:(QBUUser *)user delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)editUser:(QBUUser *)user delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Delete User

/**
 Delete User by identifier
 
 Type of Result - QBUUserResult
 
 @param userID ID of user to be removed.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)deleteUserWithID:(NSUInteger)userID delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)deleteUserWithID:(NSUInteger)userID delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;


#pragma mark -
#pragma mark Delete User with external ID

/**
 Delete User by external identifier
 
 Type of Result - QBUUserResult
 
 @param userExternalID External ID of user to be removed.
 @param delegate An object for callback, must adopt ActionStatusDelegate protocol. The delegate is not retained.  Upon finish of the request, result will be an instance of QBUUserResult class.
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (NSObject<Cancelable> *)deleteUserWithExternalID:(NSUInteger)userExternalID delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)deleteUserWithExternalID:(NSUInteger)userExternalID delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;

@end