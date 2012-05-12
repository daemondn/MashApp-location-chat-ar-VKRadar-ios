//
//  QBChatMessage.h
//  QBChatService
//

//  Copyright 2012 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 QBChatMessage structure. Contains all needed field for peer-to-peer chat.
 Please set only text and recipient_id values since ID and sender_id
 are setted automatically by QBChatService
 */
@interface QBChatMessage : NSObject {
    NSUInteger   ID;
    NSString   * text;
    NSUInteger   recipient_id;
    NSUInteger   sender_id;
}

/**
 QBChatMessage initializer
 
 @return QBChatMessage instance
 */
- (id)init;

/**
 Unique identifier of message (sequential number)
 */
@property (nonatomic, assign) NSUInteger ID;

/**
 Message text
 */
@property (nonatomic, retain) NSString * text;

/**
 Message receiver ID
 */
@property (nonatomic, assign) NSUInteger recipient_id;

/**
 Message sender ID
 */
@property (nonatomic, assign) NSUInteger sender_id;

@end
