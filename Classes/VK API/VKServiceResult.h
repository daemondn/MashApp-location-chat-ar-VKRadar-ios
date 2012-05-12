//
//  VKServiceResult.h
//  Vkmsg
//
//  Created by Igor Khomenko on 3/20/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definitions.h"

@interface VKServiceResult : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, retain) NSDictionary *body;
@property (nonatomic, retain) NSArray *errors;
@property (nonatomic) VKQueriesTypes queryType;
 

@end
