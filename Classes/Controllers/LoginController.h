//
//  LoginController.h
//  Vkmsg
//
//  Created by md314 on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegistrationController.h"

@class RegistrationController;

@interface LoginController : UIViewController <VKServiceResultDelegate, UITextFieldDelegate, ActionStatusDelegate> {
}
@property (nonatomic, retain) IBOutlet UITextField *phoneTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UIButton *signInButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIButton *regButton;
@property (nonatomic, retain) IBOutlet UIView* splashScreen;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* splashActivityIndicator;
@property (nonatomic, assign) BOOL isShowedFromLogoutScreen;

- (IBAction)signInButtonDidPress:(id)sender;
- (IBAction)registrationButtonDidPress:(id)sender;

- (void) removeSplash;
- (void) animationDidStop;

@end
