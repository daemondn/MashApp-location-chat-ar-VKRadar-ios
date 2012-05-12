//
//  VKServiceResult.m
//  Vkmsg
//
//  Created by Igor Khomenko on 3/20/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import "VKServiceResult.h"

@implementation VKServiceResult
@synthesize success, body, errors, queryType;

- (void)dealloc
{
    [body release];
    [errors release];
    [super dealloc];
}

@end
