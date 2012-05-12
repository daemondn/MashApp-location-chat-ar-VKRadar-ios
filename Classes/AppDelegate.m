//
//  AppDelegate.m
//  Vkmsg
//
//  Created by md314 on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize loginController = _loginController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [_loginController release];
    [super dealloc];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSMutableString *tokenString = [NSMutableString stringWithString:[deviceToken description]];  
    
    [tokenString replaceOccurrencesOfString:@"<"  
                                 withString:@""  
                                    options:0  
                                      range:NSMakeRange(0, tokenString.length)];  
    [tokenString replaceOccurrencesOfString:@">"  
                                 withString:@""  
                                    options:0  
                                      range:NSMakeRange(0, tokenString.length)];
    [tokenString replaceOccurrencesOfString:@" "  
                                 withString:@""  
                                    options:0  
                                      range:NSMakeRange(0, tokenString.length)];     

    // save push token
    [DataManager shared].pushToken = tokenString;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
	[UIApplication sharedApplication].statusBarHidden = YES;
    
    // Register for Push Notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | 
                                                                           UIRemoteNotificationTypeBadge | 
                                                                           UIRemoteNotificationTypeSound)];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    [self showLoginScreen:NO];

    return YES;
}

- (void)showLoginScreen:(BOOL)afterLogout{
    // show login controller
    self.loginController.isShowedFromLogoutScreen = afterLogout;
    [self.viewController presentModalViewController:self.loginController animated:afterLogout];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    DLog(@"didReceiveRemoteNotification userInfo=%@", userInfo);
    
    if([NotificationManager isPushNotificationsEnabled]){
        /*
        // Receive push notifications
        NSString *message = [[userInfo objectForKey:QBMPushMessageApsKey] objectForKey:QBMPushMessageAlertKey];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You have received a push notification", nil) 
                                                        message:message  
                                                       delegate:nil 
                                              cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
         */
    }
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [FlurryAnalytics startSession:@"QKP3F2YKS7KIJ1E771TE"];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
