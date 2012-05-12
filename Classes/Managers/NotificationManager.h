//
//  NotificationManager.h
//  Vkmsg
//
//  Created by Igor Khomenko on 4/2/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface NotificationManager : NSObject

+ (void)soundEnable:(BOOL)soundEnable;
+ (BOOL)isSoundEnabled;

+ (void)vibrationEnable:(BOOL)vibrationEnable;
+ (BOOL)isVibrationEnabled;

+ (void)pushNotificationsEnable:(BOOL)pushNotificationsEnable;
+ (BOOL)isPushNotificationsEnabled;
+ (BOOL)isPushNotificationsInitialized;

+ (void)playNotificationSound;
+ (void)notifyNewMessageDidReceive;

@end
