//
//  QBASessionCreationRequest.h
//  AuthService
//
//  Created by Igor Khomenko on 3/13/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBASessionCreationRequest : Request{
    // User auth
	NSString *userLogin;
	NSString *userPassword;
	NSUInteger userOwnerID;
    
    // device
	enum DevicePlatform devicePlatorm;
    NSString *deviceUDID;
}

@property(nonatomic, retain) NSString *userLogin;
@property(nonatomic, retain) NSString *userPassword;
@property(nonatomic, assign) NSUInteger userOwnerID;

// device
@property(nonatomic, assign) enum DevicePlatform devicePlatorm;
@property(nonatomic, retain) NSString *deviceUDID;

@end
