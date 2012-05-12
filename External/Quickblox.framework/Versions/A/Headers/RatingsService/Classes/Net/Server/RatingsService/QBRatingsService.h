//
//  QBRatingsService.h
//  QuickBlox
//
//  Created by Andrey Kozlov on 4/13/11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

@interface QBRatingsService : BaseService {
    
}

#pragma mark Add Game Mode

+ (NSObject<Cancelable>*) addGameModeWithAppID:(NSUInteger)appId 
                                         title:(NSString*)title 
                                      delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*) addGameModeWithAppID:(NSUInteger)appId 
                                         title:(NSString*)title 
                                      delegate:(NSObject<ActionStatusDelegate>*)delegate 
                                       context:(void*)context;

#pragma mark Delete Game Mode

+ (NSObject<Cancelable>*) deleteGameModeWithID:(NSUInteger)gameModeId
                                      delegate:(NSObject<ActionStatusDelegate>*)delegate;
+ (NSObject<Cancelable>*) deleteGameModeWithID:(NSUInteger)gameModeId
                                      delegate:(NSObject<ActionStatusDelegate>*)delegate 
                                       context:(void*)context;

#pragma mark
#pragma mark Create Score
#pragma mark

+ (NSObject<Cancelable> *)createScore:(QBRScore *)score delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)createScore:(QBRScore *)score delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;

#pragma mark
#pragma mark Update Score by ID
#pragma mark

+ (NSObject<Cancelable> *)updateScoreByID:(QBRScore *)score delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)updateScoreByID:(QBRScore *)score delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;

#pragma mark
#pragma mark Get Score by ID
#pragma mark

+ (NSObject<Cancelable> *)getScoreByID:(NSUInteger)scoreId delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getScoreByID:(NSUInteger)scoreId delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;

#pragma mark
#pragma mark Get Top N Scores by GameModeID
#pragma mark

+ (NSObject<Cancelable> *)getTopNByGameModeID:(QBRGetTopNByGameModeIDQuery *)query delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getTopNByGameModeID:(QBRGetTopNByGameModeIDQuery *)query delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;

#pragma mark
#pragma mark Get Scores for User
#pragma mark

+ (NSObject<Cancelable> *)getScoresForUser:(QBRGetScoresForUserQuery *)query delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getScoresForUser:(QBRGetScoresForUserQuery *)query delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;

#pragma mark
#pragma mark Get Score by ID
#pragma mark

+ (NSObject<Cancelable> *)deleteScoreByID:(NSUInteger)scoreId delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)deleteScoreByID:(NSUInteger)scoreId delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;

#pragma mark
#pragma mark Get Average Scores for Application
#pragma mark

+ (NSObject<Cancelable> *)getAverageScoresForApplication:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getAverageScoresForApplication:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;

#pragma mark
#pragma mark Get Average Scores by GameModeID
#pragma mark

+ (NSObject<Cancelable> *)getAverageScoresByGameModeID:(NSUInteger)gameModeId delegate:(NSObject<ActionStatusDelegate> *)delegate;
+ (NSObject<Cancelable> *)getAverageScoresByGameModeID:(NSUInteger)gameModeId delegate:(NSObject<ActionStatusDelegate> *)delegate context:(void *)context;

@end
