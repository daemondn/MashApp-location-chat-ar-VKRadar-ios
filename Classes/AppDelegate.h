//
//  AppDelegate.h
//  VkmsgAppDelegate
//
//  Created by md314 on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) IBOutlet UIWindow *window;
@property (assign, nonatomic) IBOutlet UITabBarController *viewController;
@property (assign, nonatomic) IBOutlet LoginController *loginController;

- (void)showLoginScreen:(BOOL)afterLogout;

@end
