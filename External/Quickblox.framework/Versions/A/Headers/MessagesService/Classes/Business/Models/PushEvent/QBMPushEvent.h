//
//  QBMPushEvent.h
//  MessagesService
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBMPushEvent : QBMEvent {
	QBMPushMessage *pushMessage;
}
/** QBMPushEvent class declaration. */
/** Overview */
/** Push event representation */

/** Push message to send to subscribers */
@property (nonatomic,retain) QBMPushMessage *pushMessage;

@end
