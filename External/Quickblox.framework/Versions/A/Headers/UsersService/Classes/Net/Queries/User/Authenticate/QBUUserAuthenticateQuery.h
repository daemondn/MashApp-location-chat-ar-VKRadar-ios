//
//  QBUAuthenticateUserQuery.h
//  UsersService
//
//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUUserAuthenticateQuery : QBUUserQuery {
	QBUUser *user;
}
@property (nonatomic, retain) QBUUser *user;

- (id)initWithQBUUser:(QBUUser *)user;

@end