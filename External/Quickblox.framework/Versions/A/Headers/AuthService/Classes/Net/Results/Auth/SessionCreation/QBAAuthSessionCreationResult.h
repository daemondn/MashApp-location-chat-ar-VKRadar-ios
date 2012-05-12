//
//  QBAAuthSessionCreationResult.h
//  AuthService
//
//  Created by Igor Khomenko on 2/6/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBAAuthSessionCreationResult : QBAAuthResult{
    
}

@property (nonatomic, readonly) QBASession *session;
@property (nonatomic, readonly) NSString *token;


@end
