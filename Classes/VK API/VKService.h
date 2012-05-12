//
//  VKService.h
//  Vkmsg
//
//  Created by Igor Khomenko on 3/20/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKServiceResultDelegate.h"
#import "VKServiceResult.h"
#import "LongPollConnection.h"

@interface VKService : NSObject{
    
}


#pragma mark -
#pragma mark User Sign In/Sign Out

// Sign In
+ (void) signInWithUsername:(NSString *) username password:(NSString *) password delegate:(NSObject <VKServiceResultDelegate>*)delegate;

// Sign Up
+ (void) signUpWithPhone:(NSString *) phone firstname:(NSString *) firstname lastname:(NSString *) lastname delegate:(NSObject <VKServiceResultDelegate>*)delegate;

// confirm registration
+ (void) conformRegistrationWithPhone:(NSString *) phone code:(NSString *) code password:(NSString *) password  delegate:(NSObject <VKServiceResultDelegate>*)delegate;

// check phone
+ (void) authCheckPhone: (NSString*) phone delegate:(NSObject <VKServiceResultDelegate>*)delegate;
+ (void) authCheckPhone:(NSString *)phone delegate:(NSObject<VKServiceResultDelegate> *)delegate context:(id) context;


#pragma mark -
#pragma mark Friends

// add friend
+ (void) friendsAdd: (NSString*) userId delegate:(NSObject <VKServiceResultDelegate>*)delegate;
+ (void) friendsAdd: (NSString*) userId delegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id) context;

// delete
+ (void) friendsDelete: (NSString*) userId delegate:(NSObject <VKServiceResultDelegate>*)delegate;

// get friends
+ (void) friendsGet: (NSString *) usersIds delegate:(NSObject <VKServiceResultDelegate>*)delegate;

// get requests
+ (void) friendsGetRequestsWithDelegate: (NSObject <VKServiceResultDelegate>*)delegate;
+ (void) friendsGetRequestsWithDelegate: (NSObject <VKServiceResultDelegate>*)delegate context:(id) context;

// get suggestions
+ (void) friendsGetSuggestionsWithFilter:(NSString *)filter delegate: (NSObject <VKServiceResultDelegate>*)delegate;
+ (void) friendsGetSuggestionsWithFilter:(NSString *)filter delegate: (NSObject <VKServiceResultDelegate>*)delegate context:(id) context;

// import local contacts
+ (void)friendsImportContactNumbers:(NSMutableArray *)phoneNumbers andEmails:(NSMutableArray *)eMails delegate:(NSObject<VKServiceResultDelegate> *)delegate;

// get friends by phone 
+ (void) friendsGetByPhones:(NSArray *)phones delegate: (NSObject <VKServiceResultDelegate>*)delegate;


#pragma mark -
#pragma mark Users profile

// get user profile
+ (void) usersProfilesWithIds:(NSString *) usersIds delegate:(NSObject <VKServiceResultDelegate>*)delegate;
+ (void) usersProfilesWithIds:(NSString *) usersIds delegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id) context;


#pragma mark -
#pragma mark Execute

+ (void) execute:(NSString *) code type:(VKQueriesTypes) queryType delegate:(NSObject <VKServiceResultDelegate>*)delegate;
+ (void) execute:(NSString *) code type:(VKQueriesTypes) queryType delegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id) context;
+ (void) execute:(NSString *) code delegate:(NSObject <VKServiceResultDelegate>*)delegate;
+ (void) execute:(NSString *) code delegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id) context;


#pragma mark -
#pragma mark Update photo

// upload photo
+ (void) userPhotoURLWithDelegate: (NSObject <VKServiceResultDelegate>*)delegate;
+ (void) uploadUserPhoto: (NSData *)photo toServer: (NSString*)server withDelegat: (NSObject <VKServiceResultDelegate>*)delegate;
+ (void) saveProfilePhoto: (id) photo withServer: (NSString*)server withHash: (NSString*)hash andDelegate: (NSObject <VKServiceResultDelegate>*)delegate;


#pragma mark -
#pragma mark Push Notifications

// enable/disable push notifications
+ (void) disablePushNotificationsWithDelegate: (NSObject <VKServiceResultDelegate>*)delegate;
+ (void) enablePushNotificationsWithDelegate: (NSObject <VKServiceResultDelegate>*)delegate;

// set silence mode
+ (void) setSilenceModeForHours: (int)hours withDelegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id)context;


#pragma mark -
#pragma mark Get Dialogs

// get dialogs
+ (void) dialogsWithDelegate: (NSObject <VKServiceResultDelegate>*)delegate;

//delete dialog
+ (void) deleteDialogWithUser:(NSUInteger)uid orChat:(NSUInteger)cid withDelegate: (NSObject <VKServiceResultDelegate>*)delegate;

#pragma mark -
#pragma mark Messages

// get history (user)
+ (void) messagesGetHistoryUser: (NSUInteger) uid delegate:(NSObject <VKServiceResultDelegate>*)delegate;

// get history (chat)
+ (void) messagesGetHistoryChat: (NSUInteger) cid delegate:(NSObject <VKServiceResultDelegate>*)delegate;

+ (void) getMessagesUploadServerWithDelegate:(NSObject <VKServiceResultDelegate>*)delegate;

+ (void) saveMessagePhoto:(id)photo toServer:(NSString*)server withHash:(NSString*)hash andDelegate:(NSObject <VKServiceResultDelegate>*)delegate;

// send message to user
+ (void) messagesSendToUser: (NSUInteger) uid message:(NSString *)message withAttachment:(NSString*)attachment andLocation:(CLLocation *)location delegate:(NSObject <VKServiceResultDelegate>*)delegate;

// send message to chat
+ (void) messagesSendToChat: (NSUInteger) cid message:(NSString *)message withAttachment:(NSString*)attachment andLocation:(CLLocation *)location delegate:(NSObject <VKServiceResultDelegate>*)delegate;


// mark message as read
+ (void) messagesMarkAsRead: (NSUInteger) mid delegate:(NSObject <VKServiceResultDelegate>*)delegate;
+ (void) messagesMarkAsRead: (NSUInteger) mid delegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id) context;


// get message by id
+ (void) messagesGetById: (NSUInteger) mid delegate:(NSObject <VKServiceResultDelegate>*)delegate;
+ (void) messagesGetById: (NSUInteger) mid delegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id)context;


// get chat users/add/remove
+ (void) messagesGetChatUsers: (NSUInteger) cid delegate:(NSObject <VKServiceResultDelegate>*)delegate;
+ (void) messagesAddChatUser: (NSUInteger) cid user:(NSUInteger) uid delegate:(NSObject <VKServiceResultDelegate>*)delegate;
+ (void) messagesRemoveChatUser: (NSUInteger) cid user:(NSUInteger) uid delegate:(NSObject <VKServiceResultDelegate>*)delegate;


// long poll server
+ (void) messagesGetLongPollServer: (NSObject <VKServiceResultDelegate>*)delegate;


#pragma mark -
#pragma mark Core

+ (void) performRequestAsyncWithUrl:(NSString *)urlString request: (NSURLRequest*)request type:(VKQueriesTypes) queryType delegate:(NSObject <VKServiceResultDelegate>*)delegate;
+ (void) performRequestAsyncWithUrl:(NSString *)urlString request: (NSURLRequest*)request type:(VKQueriesTypes) queryType delegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id) context;

+ (void) actionInBackground:(NSArray *)params;

@end
