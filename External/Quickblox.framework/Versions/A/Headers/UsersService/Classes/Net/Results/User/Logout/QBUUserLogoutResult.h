//
//  QBUUserLogoutResult.h
//  UsersService
//
//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


/** QBUUserLogoutResult class declaration. */
/** Overview */
/** This class is an instance, which will be returned to user after Sign Out. */

@interface QBUUserLogoutResult : Result {

}

@property (nonatomic,readonly) BOOL logoutResult;

@end
