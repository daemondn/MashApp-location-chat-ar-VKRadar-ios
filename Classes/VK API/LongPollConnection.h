//
//  LongPollConnection.h
//  Vkmsg
//
//  Created by Rostislav Kobizsky on 3/29/12.
//  Copyright (c) 2012 Injoit Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LongPollConnection : NSObject <VKServiceResultDelegate>
{
    NSString *mode;
	NSString *key;
	NSString *ts;
	NSString *server;
    
    NSDate *lastUpDate;
}

@property (nonatomic, retain) NSDate *lastUpDate;

+ (LongPollConnection *)shared;
+ (void)processFlags:(int)flags collectToArray:(NSMutableArray *)array;

@end
