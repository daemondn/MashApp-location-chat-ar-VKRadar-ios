//
//  DataManager.h
//  Vkmsg
//
//  Created by md314 on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define userLogin @"userLogin"
#define userPass @"userPass"

#import "VKServiceResultDelegate.h"


@interface DataManager : NSObject <VKServiceResultDelegate>{
}

+ (DataManager *) shared;

@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSString *secret;
@property (nonatomic, retain) NSString *pushToken;

// current User
@property (nonatomic, retain) NSString *currentUserId;
@property (nonatomic, retain) NSMutableDictionary *currentUserBody;
@property (nonatomic, retain) QBUUser *currentQBUser;

// friends
@property (nonatomic, retain) NSArray *myFriends;


// Messages
@property (nonatomic, assign) NSMutableDictionary *messagesUsers;
@property (nonatomic, assign) NSMutableArray *messagesDialogs;


#pragma mark -
#pragma mark First startapp

- (BOOL)isFirstStartApp;
- (void)setFirstStartApp:(BOOL)firstStartApp;


#pragma mark -
#pragma mark Favorities friends

-(NSMutableArray *) favoritiesFriends;
-(void) addFavoriteFriends: (NSArray *)friends;
-(void) removeAllFavoritiesFriends;
-(void) addFavoriteFriend: (NSDictionary *)_friend;
-(void) removeFavoriteFriend: (NSDictionary *)_friend;


#pragma mark -
#pragma mark Friends by phones

-(NSArray *) friendsByPhones;
-(void) saveFriendsByPhones: (NSArray *)friendsByPhones;
-(NSTimeInterval) lastTimeGetFriendsByPhones;
-(void) saveLastTimeGetFriendsByPhones: (NSTimeInterval)lastTime;


#pragma mark -
#pragma mark Credentials

- (void) saveLogin:(NSString*)login andPass:(NSString*)pass;
- (NSDictionary *) userLoginAndPass;
- (void) clearLoginAndPass;

@end
