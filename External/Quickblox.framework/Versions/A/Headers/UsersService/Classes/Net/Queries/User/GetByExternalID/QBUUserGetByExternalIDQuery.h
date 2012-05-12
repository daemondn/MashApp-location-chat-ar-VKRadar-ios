//
//  QBUUserGetByExternalIDQuery.h
//  UsersService
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUUserGetByExternalIDQuery : QBUUserQuery {
	NSUInteger externalUserID;
}
@property (nonatomic) NSUInteger externalUserID;

- (id)initWithExternalUserID:(NSUInteger)externalUserID;

@end