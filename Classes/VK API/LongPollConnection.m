//
//  LongPollConnection.m
//  Vkmsg
//
//  Created by Rostislav Kobizsky on 3/29/12.
//  Copyright (c) 2012 Injoit Ltd. All rights reserved.
//

#import "LongPollConnection.h"
#import "Definitions.h"

#define peer_id 2000000000;

@implementation LongPollConnection

static LongPollConnection *instance = nil;

@synthesize lastUpDate;

- (void) dealloc {
    [lastUpDate release];

    [super dealloc];
}

+ (LongPollConnection *)shared {
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
        lastUpDate = [[NSDate alloc] init];

        [VKService messagesGetLongPollServer:self];
        
        //mode - параметр, определяющий наличие поля прикреплений в получаемых данных. Значения: 2 - получать прикрепления, 0 - не получать.
        mode = @"0";
    }
    
    return self;
}

// Process flags
+ (void)processFlags:(int)flags collectToArray:(NSMutableArray *)array{
    if(array == nil){
        return;
    }
    
    if(flags <= 0){
        return;
    }
    
    if(flags >= MEDIA){
        [array addObject:[NSString stringWithFormat:@"%d", MEDIA]];
        return [[self class] processFlags:(flags-MEDIA) collectToArray:array];
    }else if(flags >= FIXED){
        [array addObject:[NSString stringWithFormat:@"%d", FIXED]];
        return [[self class] processFlags:(flags-MEDIA) collectToArray:array];
    }else if(flags >= DELETED){
        [array addObject:[NSString stringWithFormat:@"%d", DELETED]];
        return [[self class] processFlags:(flags-DELETED) collectToArray:array];
    }else if(flags >= SPAM){
        [array addObject:[NSString stringWithFormat:@"%d", SPAM]];
        return [[self class] processFlags:(flags-SPAM) collectToArray:array];
    }else if(flags >= FRIENDS){
        [array addObject:[NSString stringWithFormat:@"%d", FRIENDS]];
        return [[self class] processFlags:(flags-FRIENDS) collectToArray:array];
    }else if(flags >= CHAT){
        [array addObject:[NSString stringWithFormat:@"%d", CHAT]];
        return [[self class] processFlags:(flags-CHAT) collectToArray:array];
    }else if(flags >= IMPORTANT){
        [array addObject:[NSString stringWithFormat:@"%d", IMPORTANT]];
        return [[self class] processFlags:(flags-IMPORTANT) collectToArray:array];
    }else if(flags >= REPLIED){
        [array addObject:[NSString stringWithFormat:@"%d", REPLIED]];
        return [[self class] processFlags:(flags-REPLIED) collectToArray:array];
    }else if(flags >= OUTBOX){
        [array addObject:[NSString stringWithFormat:@"%d", OUTBOX]];
        return [[self class] processFlags:(flags-OUTBOX) collectToArray:array];
    }else if(flags >= UNREAD){
        [array addObject:[NSString stringWithFormat:@"%d", UNREAD]];
        return [[self class] processFlags:(flags-UNREAD) collectToArray:array];
    }
}

// lomg pool action
- (void)setConnectionInBackground {
    
    @autoreleasepool {
        NSString *urlString = [NSString stringWithFormat: @"http://%@?act=a_check&key=%@&ts=%@&wait=25&mode=%@",server,key,ts,mode];
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        
        NSURLResponse **response = nil;
        NSError **error = nil;
        
        
        // perform request
        NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
                
        // set body
        NSString *bodyAsString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        
        VKServiceResult *result = [[VKServiceResult alloc] init];

        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        result.body = [parser objectWithString:bodyAsString];
        [bodyAsString release];
        [parser release];
        
        // set errors
        NSMutableArray *errors = [NSMutableArray array];
        id responseErrors = [result.body objectForKey:@"error"];
        
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
        if([result.errors count] > 0 && result.body){
            result.success = NO;
        }else{
            result.success = YES; 
           
        }
        
        
        // return result to delegate 
        [self  performSelectorOnMainThread:@selector(completedWithVKLongPollResult:) withObject:[result autorelease] waitUntilDone:YES];
    }
}


#pragma mark -
#pragma mark Notification Distribution

- (void)notificationDistribution:(NSArray *)updates {

    for (NSMutableArray *update in updates) {

        int uLongPoll = [[update objectAtIndex:0] intValue];
        [update removeObjectAtIndex:0]; 
        
        switch (uLongPoll) {
            case uLongPollMessageDelete:
                [[NSNotificationCenter defaultCenter] postNotificationName:uLPNotificationMessageDelete 
                                                                    object:update];
                break;

            // Add new message
            case uLongPollMessageAddPrivate:{
                // process flags
                NSMutableArray *flags = [NSMutableArray array];
                [[self class] processFlags:[[update objectAtIndex:1] intValue] collectToArray:flags];
                [update replaceObjectAtIndex:1 withObject:flags];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:uLPNotificationMessageAddPrivate 
                                                                    object:update];
            }
                break;
            
            case uLongPollMessageFlagsChange:
                [[NSNotificationCenter defaultCenter] postNotificationName:uLPNotificationMessageFlagsChange 
                                                                    object:update];
                break;
            
            case uLongPollMessageFlagsSet:
                [[NSNotificationCenter defaultCenter] 
                 postNotificationName:uLPNotificationMessageFlagsSet object:update];
                break;
            
            case uLongPollMessageFlagsReset:
                [[NSNotificationCenter defaultCenter] 
                 postNotificationName:uLPNotificationMessageFlagsReset object:update];
                break;
            
            case uLongPollFriendsBecomeOnline:
                [[NSNotificationCenter defaultCenter] 
                 postNotificationName:uLPNotificationFriendsBecomeOnline object:update];
                break;
            
            case uLongPollFriendsBecomeOffline:
                [[NSNotificationCenter defaultCenter] 
                 postNotificationName:uLPNotificationFriendsBecomeOffline object:update];
                break;
            
            case uLongPollDialogsChanges:
                [[NSNotificationCenter defaultCenter] 
                 postNotificationName:uLPNotificationDialogsChanges object:update];
                break;
                
            case uLongPollDialogsTyping:
                [[NSNotificationCenter defaultCenter] 
                 postNotificationName:uLPNotificationDialogsTyping object:update];
                break;
            
            case uLongPollMessagesTyping:
                [[NSNotificationCenter defaultCenter] 
                 postNotificationName:uLPNotificationMessagesTyping object:update];
                break;
            
            default:
                break;
        }
    }
}

// Long Pool result
- (void)completedWithVKLongPollResult: (VKServiceResult *)result {

    if (result.success) { 
        lastUpDate = [NSDate date];

        [ts release];
        ts = [[result.body objectForKey:kLongPollTs] retain];
        
        if ([result.body objectForKey:kLongPollUpdates]) {
            [self notificationDistribution:[result.body objectForKey:kLongPollUpdates]];
        } 
    }
    
    // call again
    [self performSelectorInBackground:@selector(setConnectionInBackground) withObject:nil];
}


#pragma mark -
#pragma mark VKServiceResultDelegate

- (void)completedWithVKResult:(VKServiceResult *)result {
    switch (result.queryType) {
        // get lon gpoll server result
        case VKQueriesTypesMessagesGetLongPollServer:

            if (result.success) {
                
                NSDictionary *responce = [result.body objectForKey:@"response"];
                
				[key release];
				[ts release];
				[server release];
				
                // Set data
                key = [[responce objectForKey:kLongPollKey] retain];
                ts = [[responce objectForKey:kLongPollTs] retain];
                server = [[responce objectForKey:kLongPollServer] retain];
                
                // start long pool loop
                [self performSelectorInBackground:@selector(setConnectionInBackground) withObject:nil];
            }
            
            break;
            
        default:
            break;
    }
}

@end
