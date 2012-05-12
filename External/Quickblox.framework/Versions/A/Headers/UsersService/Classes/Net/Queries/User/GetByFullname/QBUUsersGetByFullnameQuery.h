//
//  QBUUsersGetByFullnameQuery.h
//  UsersService
//
//  Created by Igor Khomenko on 1/27/12.
//  Copyright (c) 2012 YAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBUUsersGetByFullnameQuery : QBUUserQuery{
    NSString *userFullName;
    PagedRequest *pagedRequest;
}
@property (nonatomic, readonly) NSString *userFullName;
@property (nonatomic, readonly) PagedRequest *pagedRequest;

- (id)initWithUserFullName:(NSString *)_userFullName;
- (id)initWithUserFullName:(NSString *)_userFullName pagedRequest:(PagedRequest *)_pagedRequest;

@end
