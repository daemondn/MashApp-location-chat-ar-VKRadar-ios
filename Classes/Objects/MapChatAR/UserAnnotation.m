//
//  UserAnnotation.m
//  Vkmsg
//
//  Created by Igor Khomenko on 3/28/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import "UserAnnotation.h"

@implementation UserAnnotation
@synthesize userPhotoUrl, userName, userStatus, coordinate, vkUserId, geoDataID, createdAt, vkUser;

- (void)dealloc
{
    [userPhotoUrl release];
    [userName release];
    [userStatus release];
    [createdAt release];
    [vkUser release];
    
    [super dealloc];
}

@end
