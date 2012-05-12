//
//  QBUUserLogoutAnswer.h
//  UsersService
//
//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBUUserLogoutAnswer : EntityAnswer {
	BOOL logoutResult;
}
@property (nonatomic,assign) BOOL logoutResult;

@end
