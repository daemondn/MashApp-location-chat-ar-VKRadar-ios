//
//  NotificationManager.m
//  Vkmsg
//
//  Created by Igor Khomenko on 4/2/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import "NotificationManager.h"
#import "AppDelegate.h"

static AVAudioPlayer* audioPlayer;

@implementation NotificationManager

#pragma mark -
#pragma mark Sound

+ (void)soundEnable: (BOOL)soundEnable {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:soundEnable] forKey:kSoundOn];
    [defaults synchronize];
}

+ (BOOL)isSoundEnabled {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *enabled = [defaults objectForKey:kSoundOn];
    if(enabled == nil) {
        return YES;
    }
 
    return  [enabled boolValue];
}


#pragma mark -
#pragma mark Vibration

+ (void) vibrationEnable:(BOOL)vibrationEnable {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:vibrationEnable] forKey:kVibrationOn];
    [defaults synchronize];
}

+ (BOOL) isVibrationEnabled {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *enabled = [defaults objectForKey:kVibrationOn];
    if (enabled == nil) {
        return YES;
    }
 
    return [enabled boolValue];
}


#pragma mark -
#pragma mark Push notifications

+ (void)pushNotificationsEnable:(BOOL)pushNotificationsEnable{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:pushNotificationsEnable] forKey:kPushNotificationsOn];
    [defaults synchronize];
}

+ (BOOL)isPushNotificationsEnabled{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *enabled = [defaults objectForKey:kPushNotificationsOn];
    if(enabled == nil){
        return YES;
    }
    return  [enabled boolValue];
}

+ (BOOL)isPushNotificationsInitialized{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *initialized = [defaults objectForKey:kPushNotificationsOn];
    if(initialized == nil){
        return NO;
    }
    return YES;
}


+ (void)playNotificationSound{
    if([[self class] isSoundEnabled])
	{
        if(audioPlayer == nil){
            //Get the filename of the sound file:
            NSString *path = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"mp3"];
		
            //Get a URL for the sound file
            NSURL *filePath = [NSURL fileURLWithPath:path];
		
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:filePath error:nil];
            audioPlayer.volume = 1.0;
        }
		[audioPlayer play];
    }
    
    if([[self class] isVibrationEnabled]){
        // vibrate
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

+ (void)notifyNewMessageDidReceive{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //
    // set badge
    int badge = [((UITabBarItem *)[appDelegate.viewController.tabBar.items objectAtIndex:1]).badgeValue intValue];
    ++badge;
    ((UITabBarItem *)[appDelegate.viewController.tabBar.items objectAtIndex:1]).badgeValue = [NSString stringWithFormat:@"%d", badge];
    
    // play sound 
    [NotificationManager playNotificationSound];
}

@end
