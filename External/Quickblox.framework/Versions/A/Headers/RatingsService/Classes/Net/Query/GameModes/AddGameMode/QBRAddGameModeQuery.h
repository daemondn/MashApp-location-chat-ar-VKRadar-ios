//
//  QBRAddGameModeQuery.h
//  QuickBlox
//
//  Created by Andrey Kozlov on 4/15/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

@interface QBRAddGameModeQuery : QBRatingsServiceQuery {
    NSUInteger appId; 
    NSString* title;
}

@property (nonatomic, assign) NSUInteger appId; 
@property (nonatomic, retain) NSString* title;

- (id) initWithAppID:(NSUInteger)app_id title:(NSString*)_title;

@end
