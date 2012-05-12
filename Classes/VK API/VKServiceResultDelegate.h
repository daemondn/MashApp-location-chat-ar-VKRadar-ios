//
//  VKServiceResultDelegate.h
//  Vkmsg
//
//  Created by Igor Khomenko on 3/20/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import "VKServiceResult.h"

@protocol VKServiceResultDelegate <NSObject>

@optional
-(void)completedWithVKResult:(VKServiceResult *)result;

@optional
-(void)completedWithVKResult:(VKServiceResult *)result context:(id)context;

@end
