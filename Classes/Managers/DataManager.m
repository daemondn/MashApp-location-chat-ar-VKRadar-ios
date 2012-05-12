//
//  DataManager.m
//  Vkmsg
//
//  Created by md314 on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define kFirstStartApp [NSString stringWithFormat:@"kFirstStartApp_%@", [DataManager shared].currentUserId]

#define kFavoritiesFriends [NSString stringWithFormat:@"kFavoritiesFriends_%@", [DataManager shared].currentUserId]
#define kFavoritiesFriendsIds [NSString stringWithFormat:@"kFavoritiesFriendsIds_%@", [DataManager shared].currentUserId]

#define kFriendsByPhones [NSString stringWithFormat:@"kFriendsByPhones_%@", [DataManager shared].currentUserId]
#define kLastTimeGetFriendsByPhones [NSString stringWithFormat:@"kLastTimeGetFriendsByPhones_%@", [DataManager shared].currentUserId]


#import "DataManager.h"
#import "AppDelegate.h"
#import "DialogViewController.h"

@implementation DataManager

static DataManager *instance = nil;

@synthesize accessToken, currentUserId, secret, currentUserBody, pushToken;
@synthesize currentQBUser;
@synthesize myFriends;
@synthesize messagesUsers, messagesDialogs;

- (void)dealloc {
    [pushToken release];
    [accessToken release];
    [currentUserId release];
    [secret release];
    [currentUserBody release];
    [currentQBUser release];
    [myFriends release];
    
    [messagesUsers release];
    [messagesDialogs release];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:uLPNotificationMessageAddPrivate 
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLogout object:nil];
    
    [super dealloc];
}

+ (DataManager *)shared {
	@synchronized (self) {
		if (instance == nil){ 
            instance = [[self alloc] init];
        }
	}
	
	return instance;
}

- (id)init {
    self = [super init];
    
    if(self) {
        
        messagesDialogs = [[NSMutableArray alloc] init];
        messagesUsers = [[NSMutableDictionary alloc] init];
        
        // new message did receive
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessage:) name:uLPNotificationMessageAddPrivate object:nil];
        
        // logout
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutDone) name:kNotificationLogout object:nil];
    }
    
    return self;
}


#pragma mark -
#pragma mark First startapp

- (BOOL)isFirstStartApp{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *firstStartApp = [defaults objectForKey:kFirstStartApp];
    if(firstStartApp == nil){
        return YES;
    }
    return  [firstStartApp boolValue];
}

- (void)setFirstStartApp:(BOOL)firstStartApp{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:firstStartApp] forKey:kFirstStartApp];
    [defaults synchronize];
}


#pragma mark -
#pragma mark Favorities friends

-(NSMutableArray *) favoritiesFriends{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoritiesFriends = [defaults objectForKey:kFavoritiesFriends];
    return favoritiesFriends;
}

-(void) removeAllFavoritiesFriends{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kFavoritiesFriends];
    [defaults removeObjectForKey:kFavoritiesFriendsIds];
    [defaults synchronize];
}

-(void) addFavoriteFriends: (NSArray *)friends{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    for(NSDictionary *friend in friends){
        // already exist
        NSMutableArray *favoritiesFriendsIds = [[[defaults objectForKey:kFavoritiesFriendsIds] mutableCopy] autorelease];
        if([favoritiesFriendsIds containsObject:[friend objectForKey:kUid]]){
            continue;
        }
        
        // add friend
        NSMutableArray *favoritiesFriends = [[[defaults objectForKey:kFavoritiesFriends] mutableCopy] autorelease];
        if(favoritiesFriends == nil){
            favoritiesFriends = [[[NSMutableArray alloc] init] autorelease];
            favoritiesFriendsIds = [[[NSMutableArray alloc] init] autorelease];
        }
        [favoritiesFriends addObject:friend];
        [favoritiesFriendsIds addObject:[friend objectForKey:kUid]];
        
        [defaults setObject:favoritiesFriends forKey:kFavoritiesFriends];
        [defaults setObject:favoritiesFriendsIds forKey:kFavoritiesFriendsIds];
        
        [defaults synchronize];
    }
}

-(void) addFavoriteFriend: (NSDictionary *)friend{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // already exist
    NSMutableArray *favoritiesFriendsIds = [[[defaults objectForKey:kFavoritiesFriendsIds] mutableCopy] autorelease];
    if([favoritiesFriendsIds containsObject:[friend objectForKey:kUid]]){
        return;
    }
    
    // add friend
    NSMutableArray *favoritiesFriends = [[[defaults objectForKey:kFavoritiesFriends] mutableCopy] autorelease];
    if(favoritiesFriends == nil){
        favoritiesFriends = [[[NSMutableArray alloc] init] autorelease];
        favoritiesFriendsIds = [[[NSMutableArray alloc] init] autorelease];
    }
    [favoritiesFriends addObject:friend];
    [favoritiesFriendsIds addObject:[friend objectForKey:kUid]];
    
    [defaults setObject:favoritiesFriends forKey:kFavoritiesFriends];
    [defaults setObject:favoritiesFriendsIds forKey:kFavoritiesFriendsIds];
    
    [defaults synchronize];
}

-(void) removeFavoriteFriend: (NSDictionary *)friend{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoritiesFriends = [[defaults objectForKey:kFavoritiesFriends] mutableCopy];
    NSMutableArray *favoritiesFriendsIds = [[defaults objectForKey:kFavoritiesFriendsIds] mutableCopy];
    
    [favoritiesFriends removeObject:friend];
    [favoritiesFriendsIds removeObject:[friend objectForKey:kUid]];
    
    [defaults setObject:favoritiesFriends forKey:kFavoritiesFriends];
    [defaults setObject:favoritiesFriendsIds forKey:kFavoritiesFriendsIds];
    [defaults synchronize];
    
    [favoritiesFriends release];
    [favoritiesFriendsIds release];
}


#pragma mark -
#pragma mark Friends by phones

-(NSArray *) friendsByPhones{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kFriendsByPhones];  
}

-(void) saveFriendsByPhones: (NSArray *)friendsByPhones{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:friendsByPhones forKey:kFriendsByPhones];
    [defaults synchronize];
}

-(NSTimeInterval) lastTimeGetFriendsByPhones{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults doubleForKey:kLastTimeGetFriendsByPhones];
}

-(void) saveLastTimeGetFriendsByPhones: (NSTimeInterval)lastTime{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:lastTime forKey:kLastTimeGetFriendsByPhones];
    [defaults synchronize];
}


#pragma mark -
#pragma mark Credentials

- (void) saveLogin:(NSString*)login andPass:(NSString*)pass{
    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:login forKey:userLogin];
	[defaults setObject:pass forKey:userPass];
	
	[defaults synchronize];
}

- (NSDictionary *)userLoginAndPass{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([defaults objectForKey:userLogin] && [defaults objectForKey:userPass]){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		[dict setObject:[defaults objectForKey:userLogin] forKey:userLogin];
		[dict setObject:[defaults objectForKey:userPass] forKey:userPass];
        return dict;
    }
    
    return nil;
}

- (void) clearLoginAndPass{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults removeObjectForKey:userLogin];
	[defaults removeObjectForKey:userPass];
    
	[defaults synchronize];
}


#pragma mark  
#pragma mark Messages

- (void)didReceiveNewMessage:(NSNotification *)notification {
	NSArray *param = (NSArray *)[notification object];
    NSArray *flags = [param objectAtIndex:1];
    
    // get message body
    [VKService messagesGetById:[[param objectAtIndex:0] intValue] delegate:self context:flags];
}

- (void)logoutDone{
    [[DataManager shared].messagesDialogs removeAllObjects];
    [[DataManager shared].messagesUsers removeAllObjects];
}


#pragma mark  
#pragma mark VKServiceResultDelegate

- (void) completedWithVKResult:(VKServiceResult *)result context:(id)context{
    switch (result.queryType) {
            
        // get message by ID result
        case VKQueriesTypesMessagesGetById: 
            if(result.success){
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                DialogViewController *messagesViewController = (DialogViewController *)[[[[appDelegate.viewController viewControllers] objectAtIndex:1] viewControllers] objectAtIndex:0];
                
                NSDictionary *message =  [[[result.body objectForKey:kResponse] objectForKey:kExecuteMessageMessage] objectAtIndex:1];
                NSDictionary *user =  [[[result.body objectForKey:kResponse] objectForKey:kExecuteMessageUser] objectAtIndex:0];
                
                int newMessageChatId = [[message objectForKey:kMessageChatId] intValue];
                int newMessageUserId = [[user objectForKey:kUid] intValue];
                
                // chat message
                BOOL exist = NO;
                if(newMessageChatId > 0){
                    int index = 0;
                    for(NSDictionary *chat in messagesDialogs){
                        if([[chat objectForKey:kMessageChatId] intValue] == newMessageChatId){
                            
                            // chat exist
                            [messagesDialogs replaceObjectAtIndex:index withObject:message];
                            [messagesViewController.tableView reloadData];
                            
                            // new message from person
                            if(![context containsObject:[NSString stringWithFormat:@"%d", OUTBOX]]){
                                [NotificationManager notifyNewMessageDidReceive];
                            }
                            
                            exist = YES;
                            break;
                        }
                        ++index;
                    }
                
                // dialog
                }else{
                    int index = 0;
                    for(NSDictionary *chat in messagesDialogs){
                        if(![chat objectForKey:kMessageChatId] && [[chat objectForKey:kMessageUid] intValue] == newMessageUserId){
                            
                            // dialog exist
                            [messagesDialogs replaceObjectAtIndex:index withObject:message];
                            [messagesViewController.tableView reloadData];
                            
                            // new message from person
                            if(![context containsObject:[NSString stringWithFormat:@"%d", OUTBOX]]){
                                [NotificationManager notifyNewMessageDidReceive];
                            }
                            
                            exist = YES;
                            break;
                        }
                        ++index;
                    }
                }
                
                if(!exist){
                    // get users info
                    [VKService usersProfilesWithIds:[message objectForKey:kMessageUid] delegate:self context:[NSArray arrayWithObjects:message, context, nil]];
                }
            }
            break;

            
        // get users profiles result
        case VKQueriesTypesUsersGet:
            if(result.success){
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                DialogViewController *messagesViewController = (DialogViewController *)[[[[appDelegate.viewController viewControllers] objectAtIndex:1] viewControllers] objectAtIndex:0];
                
                NSDictionary *message = [context objectAtIndex:0];
                NSArray *flags = [context objectAtIndex:1];
                
                for (NSDictionary *user in [result.body objectForKey:kResponse]) {
                    [messagesUsers setObject:user forKey: [[user objectForKey: kUserUid] description]];
                }
                
                // new message
                [messagesDialogs insertObject:message atIndex:0];
                [messagesViewController.tableView reloadData];
                
                // new message from person
                if(![flags containsObject:[NSString stringWithFormat:@"%d", OUTBOX]]){
                    [NotificationManager notifyNewMessageDidReceive];
                }
            }
            
            break;
            
        default:
            break;
            
    }
}  


@end
