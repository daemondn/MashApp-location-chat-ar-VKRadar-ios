//
//  QBChatService.h
//  QBChatService
//

//  Copyright 2012 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QBChatServiceDelegate.h"
#import "QBChatMessage.h"

/**
 QBChatServiceError enum defines following connection error codes:
 QBChatServiceErrorConnectionRefused - Connection with server is not available
 QBChatServiceErrorConnectionClosed  - Chat service suddenly became unavailable
 QBChatServiceErrorConnectionTimeout - Connection with server timed out
 */
typedef enum QBChatServiceError {
    QBChatServiceErrorConnectionRefused,
    QBChatServiceErrorConnectionClosed,
    QBChatServiceErrorConnectionTimeout
} QBChatServiceError;

@interface QBChatService : NSObject {
@private
    id<QBChatServiceDelegate> delegate;
    QBUUser * currentUser;
}

/**
 Get QBChatService singleton
 
 @return QBChatService Chat service singleton
 */
+ (QBChatService *)instance;

/**
 Init QBChatService instance
 
 @return QBChatService Chat service singleton
 */
- (id)init;

/**
 Free QBChatService from memory
 
 @return Nothing
 */
- (void)dealloc;

/**
 Authorize on QBChatService
 
 @param user QBUUser structure represents users login
 @return NO if user was logged in before method call, YES if user was not logged in
 */
- (BOOL)login:(QBUUser *)user;

/**
 Check if current user logged into QBChatService
 
 @return YES if user is logged in, NO otherwise
 */
- (BOOL)isLoggedIn;

/**
 Logout current user from QBChatService
 
 @return YES if user was logged in before method call, NO if user was not logged in
 */
- (BOOL)logout;

/**
 Send message
 
 @param message QBChatMessage structure which contains message text and recipient id
 @return YES if user was logged in before method call, NO if user was not logged in
 */
- (BOOL)sendMessage:(QBChatMessage *)message;

/**
 QBChatService delegate for callbacks
 */
@property (nonatomic, retain) id<QBChatServiceDelegate> delegate;

/**
 User who is currently logged into QBChatService
 */
@property (nonatomic, retain, readonly) QBUUser * currentUser;

@end
