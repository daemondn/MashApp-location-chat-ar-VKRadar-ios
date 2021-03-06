//
//  QBUUserCreateQuery.h
//  UsersService
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUUserCreateQuery : QBUUserQuery {
	QBUUser *user;
}
@property (nonatomic,retain) QBUUser *user;

- (id)initWithUser:(QBUUser *)_user;

@end
