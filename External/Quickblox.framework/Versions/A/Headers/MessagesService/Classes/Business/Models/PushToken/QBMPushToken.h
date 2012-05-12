//
//  QBMPushToken.h
//  MessagesService
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>

/** QBMPushToken class declaration. */
/** Overview */
/** Class represents push token, that uniquely identifies the application.  (for APNS - it's token, for C2DM - it's registration Id, for MPNS - it's uri). */

@interface QBMPushToken : Entity {
	NSString *clientIdentificationSequence;
	BOOL isEnvironmentDevelopment;
}

/** Identifies client device in 3-rd party service like APNS, C2DM or MPNS.*/
@property(nonatomic, retain) NSString *clientIdentificationSequence;

/** Determine application mode. It allows conveniently separate development and production modes. */
@property(nonatomic) BOOL isEnvironmentDevelopment;

@end