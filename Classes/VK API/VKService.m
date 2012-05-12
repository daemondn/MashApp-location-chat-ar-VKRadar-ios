//
//  VKService.m
//  Vkmsg
//
//  Created by Igor Khomenko on 3/20/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import "VKService.h"
#import "NSObject+performer.h"

#define VK_API_endpoint @"api.vk.com"
#define useHTTP NO

@implementation VKService


#pragma mark -
#pragma mark User Sign In/Sign Up

// Sign In
+ (void) signInWithUsername:(NSString *) username password:(NSString *) password delegate:(NSObject <VKServiceResultDelegate>*)delegate{
    
    NSString *scope = @"friends,photos,audio,video,docs,notes,wall,groups,messages,notifications";
    if(useHTTP){
        scope = [scope stringByAppendingString:@",nohttps"];
    }
    
    // url
    NSString *urlString = [NSString stringWithFormat:@"%@://%@/oauth/token?grant_type=%@&client_id=%@&client_secret=%@&username=%@&password=%@&scope=%@",
                           @"https",
                           VK_API_endpoint, 
                           @"password",
                           CLIENT_ID,
                           CLIENT_SECRET,
                           username,
                           password,
                           scope];
    
    // performe query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesAuthSignIn delegate:delegate];
}

// Sign Up
+ (void) signUpWithPhone:(NSString *) phone firstname:(NSString *) firstname lastname:(NSString *) lastname delegate:(NSObject <VKServiceResultDelegate>*)delegate{
    
    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?phone=%@&first_name=%@&last_name=%@&client_id=%@&client_secret=%@",
                           vkAPIMethodNameAuthSignUp,
                           phone,
                           firstname,
                           lastname,
                           CLIENT_ID,
                           CLIENT_SECRET];
    // performe query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesAuthSignUp delegate:delegate];
}

// Confirm registration
+ (void) conformRegistrationWithPhone:(NSString *) phone code:(NSString *) code password:(NSString *) password delegate:(NSObject <VKServiceResultDelegate>*)delegate{

    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?phone=%@&code=%@&password=%@&client_id=%@&client_secret=%@",
                           vkAPIMethodNameAuthConfirm,
                           phone,
                           code,
                           password,
                           CLIENT_ID,
                           CLIENT_SECRET];
    
    // performe query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesAuthConfirm delegate:delegate];
}

// Check phone
+ (void)authCheckPhone:(NSString *)phone delegate:(NSObject<VKServiceResultDelegate> *)delegate{
    [[self class] authCheckPhone:phone delegate:delegate context:nil];
}
+ (void)authCheckPhone:(NSString *)phone delegate:(NSObject<VKServiceResultDelegate> *)delegate context:(id) context{
    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?phone=%@&client_id=%@&client_secret=%@",
                           vkAPIMethodNameAuthCheckPhone,
                           phone,
                           CLIENT_ID,
                           CLIENT_SECRET];
    
    // perform query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesAuthCheckPhone delegate:delegate context:context];
}



#pragma mark -
#pragma mark Friends

// add friend
+(void)friendsAdd:(NSString *)userId delegate:(NSObject<VKServiceResultDelegate> *)delegate{
    [[self class] friendsAdd:userId delegate:delegate context:nil];
}
+ (void) friendsAdd: (NSString*) userId delegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id) context{
    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?uid=%@&access_token=%@",
                           vkAPIMethodNameFriendsAdd,
                           userId,
                           [DataManager shared].accessToken];
    
    // perform query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesFriendsAdd delegate:delegate context:context];
}

// delete friend
+ (void) friendsDelete:(NSString *)userId delegate:(NSObject<VKServiceResultDelegate> *)delegate
{
    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?uid=%@&access_token=%@",
                           vkAPIMethodNameFriendsDelete,
                           userId,
                           [DataManager shared].accessToken];
    
    // perform query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesFriendsDelete delegate:delegate];
}

// get friends
+ (void) friendsGet: (NSString *) usersIds delegate:(NSObject <VKServiceResultDelegate>*)delegate{
    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?uid=%@&fields=%@&order=hints&access_token=%@",
                           vkAPIMethodNameFriendsGet,
                           usersIds,
                           @"uid,first_name,last_name,photo",
                           [DataManager shared].accessToken];
    
    // perform query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesFriendsGet delegate:delegate];
    
}

// get requests
+ (void)friendsGetRequestsWithDelegate:(NSObject<VKServiceResultDelegate> *)delegate
{
    [[self class] friendsGetRequestsWithDelegate:delegate context:nil];
}
+ (void) friendsGetRequestsWithDelegate: (NSObject <VKServiceResultDelegate>*)delegate context:(id) context{
    NSString *queryBody = @"return API.users.get({\"uids\":API.friends.getRequests(), \"fields\":\"uid,first_name,last_name,photo\"});";
    
    // perform query
    [[self class] execute:queryBody type:VKQueriesTypesFriendsGetRequests delegate:delegate context:context];
}

// get suggestions
+ (void) friendsGetSuggestionsWithFilter:(NSString *)filter delegate: (NSObject <VKServiceResultDelegate>*)delegate
{
     [[self class] friendsGetSuggestionsWithFilter:filter delegate:delegate context:nil];
}
+ (void) friendsGetSuggestionsWithFilter:(NSString *)filter delegate: (NSObject <VKServiceResultDelegate>*)delegate context:(id) context{
    
    NSString *queryBody;
    if(filter){
        queryBody = [NSString stringWithFormat:@"return API.users.get({\"uids\":API.friends.getSuggestions({\"filter\":\"%@\"})@.uid, \"fields\":\"uid,first_name,last_name,photo\"});", filter];
    }else{
        queryBody = @"return API.users.get({\"uids\":API.friends.getSuggestions()@.uid, \"fields\":\"uid,first_name,last_name,photo\"});";
    }
    
    // perform query
    [[self class] execute:queryBody type:VKQueriesTypesFriendsGetSuggestions delegate:delegate context:context];
}

// import local contacts
+ (void)friendsImportContactNumbers:(NSMutableArray *)phoneNumbers andEmails:(NSMutableArray *)eMails delegate:(NSObject<VKServiceResultDelegate> *)delegate
{
    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?contacts=%@%@&access_token=%@",
                           vkAPIMethodNameAccountImportContacts,
                         [EncodeHelper urlencode:[phoneNumbers stringComaSeparatedValue]], [EncodeHelper urlencode:[eMails stringComaSeparatedValue]],
                           [DataManager shared].accessToken];
    
    // perform query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesImportContacts delegate:delegate];
}

// get friends by phone 
+ (void) friendsGetByPhones:(NSArray *)phones delegate: (NSObject <VKServiceResultDelegate>*)delegate{
    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?phones=%@&fields=%@&access_token=%@",
                           vkAPIMethodNameFriendsGetByPhones,
                           [phones stringComaSeparatedValue],
                           @"photo",
                           [DataManager shared].accessToken];
    
    // perform query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesFriendsGetByPhones delegate:delegate];
}


#pragma mark -
#pragma mark Users profile

// get user profile
+ (void) usersProfilesWithIds:(NSString *) usersIds delegate:(NSObject <VKServiceResultDelegate>*)delegate{
    [[self class] usersProfilesWithIds:usersIds delegate:delegate context:nil];
}
+ (void) usersProfilesWithIds:(NSString *) usersIds delegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id) context{
    
    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?uids=%@&fields=%@&access_token=%@",
                           vkAPIMethodNameUsersGet,
                           usersIds,
                           @"uid,first_name,last_name,photo,online",
                           [DataManager shared].accessToken];
    
    // perform query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesUsersGet delegate:delegate context:context];
}


#pragma mark -
#pragma mark Execute

+ (void) execute:(NSString *) code delegate:(NSObject <VKServiceResultDelegate>*)delegate{
     [[self class] execute:code type:VKQueriesTypesExecute delegate:delegate context:nil];
}

+ (void) execute:(NSString *) code delegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id) context{
    [[self class] execute:code type:VKQueriesTypesExecute delegate:delegate context:context];
}

+ (void) execute:(NSString *) code type:(VKQueriesTypes) queryType delegate:(NSObject <VKServiceResultDelegate>*)delegate{
    [[self class] execute:code type:queryType delegate:delegate context:nil];
}

+ (void) execute:(NSString *) code type:(VKQueriesTypes) queryType delegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id) context{
    
    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?code=%@&access_token=%@", vkAPIMethodNameExecute, code, [DataManager shared].accessToken];
    
    
    
    // perform query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:queryType delegate:delegate context:context];
}


#pragma mark -
#pragma mark Push Notifications

// enable/disable push notifications
+ (void) disablePushNotificationsWithDelegate: (NSObject <VKServiceResultDelegate>*)delegate
{
    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?access_token=%@&token=%@",vkAPIMethodDisablePushNotifications,[DataManager shared].accessToken, [DataManager shared].pushToken];

    // perform query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTyperDisablePushNotifications delegate:delegate];
}
+ (void) enablePushNotificationsWithDelegate: (NSObject <VKServiceResultDelegate>*)delegate
{
    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?access_token=%@&token=%@",vkAPIMethodEnablePushNotifications,[DataManager shared].accessToken, [DataManager shared].pushToken];
    
    // perform query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTyperEnablePushNotifications delegate:delegate];
}

// set silence mode
+ (void) setSilenceModeForHours: (int)hours withDelegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id)context
{
    // url
    int time = hours*3600;
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?access_token=%@&token=%@&time=%i",vkAPIMethodSetSilenceMode,[DataManager shared].accessToken, [DataManager shared].pushToken, time];
    
    // perform query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesSetSilenceMode delegate:delegate context:context];
}


#pragma mark -
#pragma mark Update photo

// upload photo
+ (void) userPhotoURLWithDelegate: (NSObject <VKServiceResultDelegate>*)delegate
{
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?access_token=%@",
                           vkAPIMethodPhotosGetProfileUploadServer, [DataManager shared].accessToken];
    // performe query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesPhotoGetUrl delegate:delegate];
}
//
+ (void) uploadUserPhoto: (NSData*)photo toServer: (NSString *)server withDelegat: (NSObject <VKServiceResultDelegate>*)delegate
{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:server] 
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                                                       timeoutInterval:30.0]; 
    // set POST method
    [request setHTTPMethod:@"POST"]; 
    
    // UTF-8
    [request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = [(NSString*)CFUUIDCreateString(nil, uuid) autorelease];
    CFRelease(uuid);
    NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;  boundary=%@", stringBoundary];
    
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:photo];        
    [body appendData:[[NSString stringWithFormat:@"%@",endItemBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add body to NSMutableRequest
    [request setHTTPBody:body];
	
    [[self class] performRequestAsyncWithUrl:nil request:request type:VKQueriesTypesUploadPhoto delegate:delegate];
}
//
+ (void)saveProfilePhoto:(id)photo withServer:(NSString *)server withHash:(NSString *)hash andDelegate:(NSObject<VKServiceResultDelegate> *)delegate
{
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?access_token=%@&server=%@&photo=%@&hash=%@",
                           vkAPIMethodPhotosSaveProfilePhoto,[DataManager shared].accessToken,server,photo,hash];
    // performe query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesSavePhoto delegate:delegate];
}

+ (void)saveMessagePhoto:(id)photo toServer:(NSString *)server withHash:(NSString *)hash andDelegate:(NSObject<VKServiceResultDelegate> *)delegate
{
	NSString *urlString = [NSString stringWithFormat:@"/method/%@?access_token=%@&server=%@&photo=%@&hash=%@",
                           vkAPIMethodPhotosSaveMessagePhoto,[DataManager shared].accessToken,server,photo,hash];
	NSLog(@"%@",urlString);
    // performe query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesSavePhoto delegate:delegate];
}


#pragma mark -
#pragma mark Dialogs

// get dialogs
+ (void) dialogsWithDelegate: (NSObject <VKServiceResultDelegate>*)delegate{
    NSString *code = [NSString stringWithFormat:@"var dialogs = API.%@({\"count\":\"30\"}); var usersDialog = API.%@({\"uids\":dialogs@.%@, \"fields\":\"%@,%@\"}); var usersChat = API.%@({\"uids\":dialogs@.%@, \"fields\":\"%@,%@\"}); return {\"%@\" : dialogs, \"%@\" : usersDialog, \"%@\" : usersChat};", 
                      vkAPIMethodMessagesGetDialog, 
                      vkAPIMethodNameUsersGet, kMessageUid, kUserPhoto, kUserOnline, 
                      vkAPIMethodNameUsersGet, kMessageChatActive, kUserPhoto, kUserOnline, 
                      kExecuteMessageDialogs, kExecuteMessageUsers, kExecuteMessageChatActiveUsers];
  
    
    // perform query
    [[self class] execute:code type:VKQueriesTyperMessagesGetDialogs delegate:delegate];
}

// delete dialog
+ (void) deleteDialogWithUser:(NSUInteger)uid orChat:(NSUInteger)cid withDelegate: (NSObject <VKServiceResultDelegate>*)delegate{
	NSString *urlString = @"";
    if(uid > 0){
        urlString = [NSString stringWithFormat:@"/method/%@?uid=%d&access_token=%@",
                           vkAPIMethodMessagesDeleteDialog, uid, [DataManager shared].accessToken];
    }else if (cid > 0){
        urlString = [NSString stringWithFormat:@"/method/%@?chat_id=%d&access_token=%@",
                     vkAPIMethodMessagesDeleteDialog, cid, [DataManager shared].accessToken];
    }

    // performe query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesMessagesDeleteDialog delegate:delegate];
}

#pragma mark -
#pragma mark Messages

// get history (user)
+ (void) messagesGetHistoryUser: (NSUInteger) uid delegate:(NSObject <VKServiceResultDelegate>*)delegate
{
    NSString *code = [NSString stringWithFormat:@"var history = API.%@({\"uid\":\"%i\", \"count\":\"35\"}); var users = API.%@({\"uids\":history@.%@, \"fields\":\"%@\"}); return {\"%@\" : history, \"%@\" : users};", 
                      vkAPIMethodNameMessagesGetHistory, uid,
                      vkAPIMethodNameUsersGet, kMessageFromUid, @"uid,first_name,last_name,photo", 
                      kExecuteMessageHistory, kExecuteMessageUsers];
    
    
    // perform query
    [[self class] execute:code type:VKQueriesTypesMessagesGetHistory delegate:delegate];
}

// get history (chat)
+ (void) messagesGetHistoryChat: (NSUInteger) cid delegate:(NSObject <VKServiceResultDelegate>*)delegate
{
    NSString *code = [NSString stringWithFormat:@"var history = API.%@({\"chat_id\":\"%i\", \"count\":\"35\"}); var users = API.%@({\"chat_id\":%i, \"fields\":\"%@\"}); return {\"%@\" : history, \"%@\" : users};", 
                      vkAPIMethodNameMessagesGetHistory, cid, 
                      vkAPIMethodNameMessagesGetChatUsers, cid, @"uid,first_name,last_name,photo", 
                      kExecuteMessageHistory, kExecuteMessageUsers];
    
    // perform query
    [[self class] execute:code type:VKQueriesTypesMessagesGetHistory delegate:delegate];
}


// long pool server
+ (void) messagesGetLongPollServer: (NSObject <VKServiceResultDelegate>*)delegate{
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?access_token=%@", vkAPIMethodNameMessagesGetLongPollServer, [DataManager shared].accessToken];
    
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesMessagesGetLongPollServer delegate:delegate];
}

+ (void) getMessagesUploadServerWithDelegate:(NSObject<VKServiceResultDelegate> *)delegate
{
	NSString *urlString = [NSString stringWithFormat:@"/method/%@?access_token=%@", vkAPIMethodNameMessagesGetUploadServer, [DataManager shared].accessToken];
	
	NSLog(@"%@",urlString);
    
    [[self class] performRequestAsyncWithUrl:urlString request:nil 
										type:VKQueriesTypesMessagesGetUploadServer delegate:delegate];
}

// send message to user
+ (void) messagesSendToUser: (NSUInteger) uid message:(NSString *)message withAttachment:(NSString*)attachment andLocation:(CLLocation *)location delegate:(NSObject <VKServiceResultDelegate>*)delegate{

    // message body
    BOOL messageExist = NO;
    NSMutableString *messageBodyPart1 = [[NSMutableString alloc] init];
    NSMutableString *messageBodyPart2 = [[NSMutableString alloc] init];
    [messageBodyPart1 appendFormat:@"{\"uid\":\"%@\"",[NSString stringWithFormat:@"%i", uid]]; // add uid 
    
    if(message){
        messageExist = YES;
        [messageBodyPart1 appendString:@",\"message\":\""];
        [messageBodyPart2 appendString:@"\""];
    }
    
    if(attachment){
         [messageBodyPart2 appendFormat:@",\"attachment\":\"%@\"", attachment];
    }
    if(location){
        [messageBodyPart2 appendFormat:@",\"lat\":\"%f\",\"long\":\"%f\"", location.coordinate.latitude, location.coordinate.longitude];
    }
    [messageBodyPart2 appendString:@"}"];
    
    
    NSString *resultBody;
    if(messageExist){
        resultBody = [NSString stringWithFormat:@"%@%@%@", [messageBodyPart1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [EncodeHelper urlencode:message], [messageBodyPart2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else{
        resultBody = [NSString stringWithFormat:@"%@%@", [messageBodyPart1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [messageBodyPart2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    NSString *code = [NSString stringWithFormat:@"%@%@(%@)%@%@%@", [@"var newMessageID = API." stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], vkAPIMethodNameMessagesSend, resultBody, [@";return API." stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], vkAPIMethodNameMessagesGetById, [@"({\"mid\":newMessageID});" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [messageBodyPart1 release];
    [messageBodyPart2 release];
    
    // perform query
    [[self class] execute:code type:VKQueriesTypesMessagesSend delegate:delegate]; 
}

// send message to chat
+ (void) messagesSendToChat: (NSUInteger) cid message:(NSString *)message withAttachment:(NSString*)attachment andLocation:(CLLocation *)location delegate:(NSObject <VKServiceResultDelegate>*)delegate{

    // message body
    BOOL messageExist = NO;
    NSMutableString *messageBodyPart1 = [[NSMutableString alloc] init];
    NSMutableString *messageBodyPart2 = [[NSMutableString alloc] init];
    [messageBodyPart1 appendFormat:@"{\"chat_id\":\"%@\"",[NSString stringWithFormat:@"%i", cid]]; // add uid 
    
    if(message){
        messageExist = YES;
        [messageBodyPart1 appendString:@",\"message\":\""];
        [messageBodyPart2 appendString:@"\""];
    }
    
    if(attachment){
        [messageBodyPart2 appendFormat:@",\"attachment\":\"%@\"", attachment];
    }
    if(location){
        [messageBodyPart2 appendFormat:@",\"lat\":\"%f\",\"long\":\"%f\"", location.coordinate.latitude, location.coordinate.longitude];
    }
    [messageBodyPart2 appendString:@"}"];
    
    
    NSString *resultBody;
    if(messageExist){
        resultBody = [NSString stringWithFormat:@"%@%@%@", [messageBodyPart1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [EncodeHelper urlencode:message], [messageBodyPart2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else{
        resultBody = [NSString stringWithFormat:@"%@%@", [messageBodyPart1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [messageBodyPart2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    NSString *code = [NSString stringWithFormat:@"%@%@(%@)%@%@%@", [@"var newMessageID = API." stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], vkAPIMethodNameMessagesSend, resultBody, [@";return API." stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], vkAPIMethodNameMessagesGetById, [@"({\"mid\":newMessageID});" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [messageBodyPart1 release];
    [messageBodyPart2 release];
    
    // perform query
    [[self class] execute:code type:VKQueriesTypesMessagesSend delegate:delegate]; 
}


// mark message as read
+ (void) messagesMarkAsRead: (NSUInteger) mid delegate:(NSObject <VKServiceResultDelegate>*)delegate{
    [[self class] messagesMarkAsRead:mid delegate:delegate context:nil];
}

+ (void) messagesMarkAsRead: (NSUInteger) mid delegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id) context{
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?mids=%@&access_token=%@", 
                           vkAPIMethodNameMessagesMarkAsRead, 
                           [NSString stringWithFormat:@"%i", mid],
                           [DataManager shared].accessToken];
    
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesMessagesMarkAsRead delegate:delegate context:context];
}


// get chat users
+ (void) messagesGetChatUsers: (NSUInteger) cid delegate:(NSObject <VKServiceResultDelegate>*)delegate{
    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?chat_id=%@&fields=%@&access_token=%@",
                           vkAPIMethodNameMessagesGetChatUsers,
                           [NSString stringWithFormat:@"%i", cid],
                           @"uid,first_name,last_name,photo",
                           [DataManager shared].accessToken];
    
    // perform query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesMessagesGetChatUsers delegate:delegate];
}

// add chat user
+ (void) messagesAddChatUser: (NSUInteger) cid user:(NSUInteger) uid delegate:(NSObject <VKServiceResultDelegate>*)delegate{
    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?chat_id=%@&uid=%@&access_token=%@",
                           vkAPIMethodNameMessagesAddChatUser,
                           [NSString stringWithFormat:@"%i", cid],
                           [NSString stringWithFormat:@"%i", uid],
                           [DataManager shared].accessToken];
    
    // perform query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesMessagesAddChatUser delegate:delegate];
}

// remove chat user
+ (void) messagesRemoveChatUser: (NSUInteger) cid user:(NSUInteger) uid delegate:(NSObject <VKServiceResultDelegate>*)delegate{
    
    // url
    NSString *urlString = [NSString stringWithFormat:@"/method/%@?chat_id=%@&uid=%@&access_token=%@",
                           vkAPIMethodNameMessagesRemoveChatUser,
                           [NSString stringWithFormat:@"%i", cid],
                           [NSString stringWithFormat:@"%i", uid],
                           [DataManager shared].accessToken];
    
    // perform query
    [[self class] performRequestAsyncWithUrl:urlString request:nil type:VKQueriesTypesMessagesRemoveChatUser delegate:delegate];
}

// get message by id
+ (void) messagesGetById: (NSUInteger) mid delegate:(NSObject <VKServiceResultDelegate>*)delegate{
    [[self class] messagesGetById:mid delegate:delegate context:nil];
}
+ (void) messagesGetById: (NSUInteger) mid delegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id)context{
    NSString *code = [NSString stringWithFormat:@"var message = API.%@({\"mid\":\"%i\"}); var user = API.%@({\"uid\":message@.uid, \"fields\":\"%@\"}); return {\"%@\" : message, \"%@\" : user};", 
                      vkAPIMethodNameMessagesGetById, mid, 
                      vkAPIMethodNameUsersGet, @"uid,first_name,last_name,photo", 
                      kExecuteMessageMessage, kExecuteMessageUser];
    
    // perform query
    [[self class] execute:code type:VKQueriesTypesMessagesGetById delegate:delegate context:context]; 
}

#pragma mark -
#pragma mark Core

+ (void) performRequestAsyncWithUrl:(NSString *)urlString request: (NSURLRequest*)request type:(VKQueriesTypes) queryType delegate:(NSObject <VKServiceResultDelegate>*)delegate{
    
    [[self class] performRequestAsyncWithUrl:urlString request:request type:queryType delegate:delegate context:nil];
}

+ (void) performRequestAsyncWithUrl:(NSString *)urlString request: (NSURLRequest*)request type:(VKQueriesTypes) queryType delegate:(NSObject <VKServiceResultDelegate>*)delegate context:(id) context{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // url as string
    if(urlString){
        // http - > add sig
        if([DataManager shared].secret){
            NSString *sig = [[NSString stringWithFormat:@"%@%@", urlString, [DataManager shared].secret] MD5String];
            if ((queryType != VKQueriesTypesUploadPhoto) && (queryType != VKQueriesTypesAuthCheckPhone)){
                urlString = [NSString stringWithFormat:@"http://%@%@&sig=%@", VK_API_endpoint, urlString, sig];
            }else {
				urlString = [NSString stringWithFormat:@"https://%@%@", VK_API_endpoint, urlString];
			}
            
        // https
        }else if((VKQueriesTypesAuthSignIn != queryType)&& (queryType != VKQueriesTypesMessagesGetUploadServer)){
            urlString = [NSString stringWithFormat:@"https://%@%@", VK_API_endpoint, urlString];
        }
		if (queryType == VKQueriesTypesMessagesGetUploadServer)
		{
			NSString *sig = [[NSString stringWithFormat:@"%@%@", urlString, [DataManager shared].secret] MD5String];
			urlString = [NSString stringWithFormat:@"https://%@%@&sig=%@", VK_API_endpoint, urlString, sig];
		}
        
        NSURL *url;
        if(queryType == VKQueriesTypesMessagesSend){
            url = [NSURL URLWithString:urlString];

        }else{
            url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        }
       
        request = [NSURLRequest requestWithURL:url];
    }
    
    NSLog(@"performRequestAsyncWithUrl=%@", [[request URL] absoluteString]);
    
    
    NSArray *params = [NSArray arrayWithObjects:request, [NSNumber numberWithInt:queryType], delegate, context, nil];
    [[self class] performSelectorInBackground:@selector(actionInBackground:) withObject:params];
}

+ (void)actionInBackground:(NSArray *)params{
    @autoreleasepool {
        
        NSURLResponse **response = nil;
        NSError **error = nil;
        
        
        NSURLRequest *request = [params objectAtIndex:0];
        VKQueriesTypes queryType = (VKQueriesTypes)[[params objectAtIndex:1] intValue];
        NSObject <VKServiceResultDelegate>* delegate = [params objectAtIndex:2];
        id context = nil;
        if([params count] == 4){
            context = [params objectAtIndex:3];
        }
        
        
        // perform request
        NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
        
        // alloc result
        VKServiceResult *result = [[VKServiceResult alloc] init];
        
        // set body
        NSString *bodyAsString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];

        SBJsonParser *parser = [[SBJsonParser alloc] init];
        result.body = [parser objectWithString:bodyAsString];
        [bodyAsString release];
        [parser release];
        
        // set errors
        NSMutableArray *errors = [NSMutableArray array];
        id responseErrors = [result.body objectForKey:@"error"];
        
        NSLog(@"responseErrors=%@", responseErrors);
        
        if(responseErrors){
            // string
            if([responseErrors isKindOfClass:[NSString class]]){
               [errors addObject:responseErrors];
            // dict
            }else  if([responseErrors isKindOfClass:[NSDictionary class]]){
                [errors addObject:[((NSDictionary *)responseErrors) objectForKey:@"error_msg"]]; 
            }
        }
        if(error){
            [errors addObject:NSLocalizedString(@"System error during request to VK api", nil)]; 
        }
        result.errors = errors;
        
        // set status
        if(([result.errors count] > 0 && result.body) || ([result.errors count] == 0 && [result.body count] == 0)){
            result.success = NO;
        }else{
            if([[result.body objectForKey:kResponse] isKindOfClass:NSNumber.class] && [[result.body objectForKey:kResponse] intValue] == 0){
                result.success = NO;
            }else{
                result.success = YES; 
            }
        }
        
        // set query type
        [result setQueryType:queryType];
        
        NSLog(@"responseResult=%@",result.body);
        
        // return result to delegate 
        if(context){
            //[delegate performSelectorOnMai
            [delegate performSelectorOnMainThread:@selector(completedWithVKResult:context:) withObject:[result autorelease] withObject:context waitUntilDone:YES];
        }else{
            [delegate performSelectorOnMainThread:@selector(completedWithVKResult:) withObject:[result autorelease] waitUntilDone:YES];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

@end
