//
//  QBRDeleteGameMode.h
//  QuickBlox
//
//  Created by Andrey Kozlov on 4/15/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

@interface QBRDeleteGameMode : QBRatingsServiceQuery {
	NSUInteger gameModeId;
}

@property (nonatomic) NSUInteger gameModeId;

- (id) initWithGameModeID:(NSUInteger)game_mode_id;

@end
