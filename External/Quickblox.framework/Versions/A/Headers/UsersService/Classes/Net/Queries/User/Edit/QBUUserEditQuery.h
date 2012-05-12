//
//  QBUUserEditQuery.h
//  UsersService
//
//  Created by Macbook Injoit on 12/12/11.
//  Copyright (c) 2011 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBUUserEditQuery : QBUUserQuery{
    QBUUser *user;
}
@property (nonatomic,retain) QBUUser *user;

- (id)initWithUser:(QBUUser *)tuser;

@end