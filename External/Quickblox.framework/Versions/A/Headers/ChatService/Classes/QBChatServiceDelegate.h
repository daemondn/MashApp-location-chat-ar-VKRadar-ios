//
//  QBChatServiceDelegate.h
//  QBChatService
//

//  Copyright 2012 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QBChatService.h"
#import "QBChatMessage.h"

/**
 QBChatServiceDelegate protocol definition
 This protocol defines methods signatures for callbacks. Implement this protocol in your class and
 set QBChatService.delegate to your implementation instance to receive callbacks from QBChatService
 */
@protocol QBChatServiceDelegate <NSObject>
@optional
/**
 didLogin fired by QBChatService when connection to service established and login is successfull
 */
- (void)didLogin;

/**
 didNotLogin fired when login process did not finished successfully
 */
- (void)didNotLogin;

/**
 didNotSendMessage fired when message cannot be send to offline user
 
 @param message Message passed to sendMessage method into QBChatService
 */
- (void)didNotSendMessage:(QBChatMessage *)message;

/**
 didReceiveMessage fired when new message was received from QBChatService
 
 @param message Message received from QBChatService
 */
- (void)didReceiveMessage:(QBChatMessage *)message;

/**
 didFailWithError fired when connection error occurs
 
 @param error Error code from QBChatServiceError enum
 */
- (void)didFailWithError:(int)error;

@end
