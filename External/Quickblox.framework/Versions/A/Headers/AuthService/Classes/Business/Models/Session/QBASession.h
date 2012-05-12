//
//  QBASession.h
//  AuthService
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBASession : Entity {
	NSString *token;
    NSUInteger appID;
    NSUInteger userID;
    NSUInteger deviceID;
    NSUInteger timestamp;
    NSInteger nonce;
}
@property (nonatomic, retain) NSString *token;
@property (nonatomic, assign) NSUInteger appID;
@property (nonatomic, assign) NSUInteger userID;
@property (nonatomic, assign) NSUInteger deviceID;
@property (nonatomic, assign) NSUInteger timestamp;
@property (nonatomic, assign) NSInteger nonce;

@end
