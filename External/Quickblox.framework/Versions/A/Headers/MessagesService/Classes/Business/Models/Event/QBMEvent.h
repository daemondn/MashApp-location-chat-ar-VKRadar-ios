//
//  QBMEvent.h
//  MessagesService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>

/** QBMEvent class declaration. */
/** Overview: Base class of all events.
    Normally, you use concerte subsclasses, like QBMPushEvent.
 */

@interface QBMEvent : Entity {
	enum QBMEventType type;
    enum QBMEventNotificationType notificationType;
	NSMutableDictionary *message;
    BOOL isEnvironmentDevelopment;
    NSString *usersIDs;
}

/** Event type */
@property (nonatomic) QBMEventType type;

/** Event message */
@property (nonatomic,retain) NSMutableDictionary *message;

/** Environment of the notification */
@property (nonatomic) BOOL isEnvironmentDevelopment;

/** Recipients ids */
@property (nonatomic,retain) NSString *usersIDs;

- (void)prepareMessage;


#pragma mark -
#pragma mark Converters

+ (enum QBMEventType)eventTypeFromString:(NSString*)eventType;
+ (NSString*)eventTypeToString:(enum QBMEventType)eventType;

+ (NSString*)messageToString:(NSDictionary*)message;
+ (NSDictionary*)messageFromString:(NSString*)message;

@end
