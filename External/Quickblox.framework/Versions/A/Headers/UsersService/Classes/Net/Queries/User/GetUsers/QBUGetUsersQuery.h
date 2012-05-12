//
//  QBUGetUsersQuery.h
//  UsersService
//
//  Created by Igor Khomenko on 1/27/12.
//  Copyright (c) 2012 YAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBUGetUsersQuery : QBUUserQuery{
	PagedRequest *pagedRequest;
}
@property (nonatomic, readonly) PagedRequest *pagedRequest;

-(id)initWithRequest:(PagedRequest *)_pagedRequest;

@end
