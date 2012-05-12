//
//  LoginController.m
//  Vkmsg
//
//  Created by md314 on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"
#import "NumberToLetterConverter.h"
#import "LongPollConnection.h"
#import "AppDelegate.h"

@interface LoginController ()

@end

@implementation LoginController

@synthesize phoneTextField = _phoneTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize signInButton = _signInButton;
@synthesize activityIndicator = _activityIndicator;
@synthesize regButton, splashScreen, splashActivityIndicator;
@synthesize isShowedFromLogoutScreen;

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // show splash
    [splashScreen setFrame:CGRectMake(0,0,320,480)];
    [self.view addSubview:splashScreen];
    
    // QuickBlox application authorization
    [QBAuthService authorizeAppId:appID key:authKey secret:authSecret delegate:self];
    //[QBSettings setLogLevel:QBLogLevelNothing];
    [splashActivityIndicator startAnimating];
    
    
    // restore credentials
    NSDictionary *userCredentials = [[DataManager shared] userLoginAndPass];
    if(userCredentials != nil){
        _phoneTextField.text = [userCredentials objectForKey:userLogin];
        _passwordTextField.text = [userCredentials objectForKey:userPass];
    }
}

- (void)viewDidUnload{
    self.phoneTextField = nil;
    self.passwordTextField = nil;
    self.signInButton = nil;
    self.activityIndicator = nil;
    self.splashActivityIndicator = nil;
    self.splashScreen = nil;
    self.regButton = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(isShowedFromLogoutScreen){
        [splashScreen removeFromSuperview];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// registration block
	if (CGRectContainsPoint(CGRectMake(10, 55, 299, 46), [[[touches allObjects] objectAtIndex:0] locationInView:self.view]))
	{
		[_phoneTextField becomeFirstResponder];
	} 
	else if (CGRectContainsPoint(CGRectMake(10, 55, 299, 92), [[[touches allObjects] objectAtIndex:0] locationInView:self.view]))
	{
		[_passwordTextField becomeFirstResponder];
	} 
	
}

// Sign In action
- (IBAction)signInButtonDidPress:(id)sender{
    if ([_activityIndicator isAnimating]){
        return;
    }
    
    // User Sign In
    [VKService signInWithUsername:_phoneTextField.text password:_passwordTextField.text delegate:self];
    
	[_activityIndicator startAnimating];
	
	
}

// Registration action
- (IBAction)registrationButtonDidPress:(id)sender{
    if ([_activityIndicator isAnimating]){
        return;
    }
    
    // show Registration controller
	[self presentModalViewController:[[[RegistrationController alloc] init] autorelease] animated:YES]; 
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -
#pragma mark VKServiceResultDelegate

-(void)completedWithVKResult:(VKServiceResult *)result{
    // User login result
    if(result.queryType == VKQueriesTypesAuthSignIn){
        if(result.success){
            
            // save access_token & user_id & secret
            [DataManager shared].currentUserId = [[result.body objectForKey:kUserId] stringValue];
            [DataManager shared].accessToken = [result.body objectForKey:kAccessToken];
            [DataManager shared].secret = [result.body objectForKey:kSecret];
            
            // try to Sign In QB user
            QBUUser *qbUser = [[QBUUser alloc] init];
            qbUser.ownerID = ownerID;   
            NSString *login = [[NumberToLetterConverter instance] convertNumbersToLetters:[DataManager shared].currentUserId];
            NSString *passwordHash = [NSString stringWithFormat:@"%u", [[DataManager shared].currentUserId hash]];
            qbUser.login = login;
            qbUser.password = passwordHash;
            //
            [QBUsersService authenticateUser:qbUser delegate:self];
            //
            [qbUser release];
            
            
            // get current user profile
            [VKService usersProfilesWithIds:[DataManager shared].currentUserId delegate:self];

        // Errors
        }else{
            NSString *message = [result.errors stringValue];
            if([message isEqualToString:@"invalid_client"]){
                message = NSLocalizedString(@"Username or password is incorrect", nil);
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errors", nil) 
                                                            message:message  
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];

            //"Wrong username or password"
        }
        
        [_activityIndicator stopAnimating];
    
    // Get User info result
    }else if(result.queryType == VKQueriesTypesUsersGet){
        if(result.success){
            // save current user body
            [DataManager shared].currentUserBody = [[result.body objectForKey:kResponse] objectAtIndex:0];
        }
        
    // Enable push notifications result
    }else if (result.queryType == VKQueriesTyperEnablePushNotifications){
        if (result.success){
            [NotificationManager pushNotificationsEnable:YES];
        }
    }
}


#pragma mark -
#pragma mark ActionStatusDelegate QB

-(void)completedWithResult:(Result*)result{
    // QB User Sign In
    if([result isKindOfClass:[QBUUserAuthenticateResult class]]){
		QBUUserAuthenticateResult *res = (QBUUserAuthenticateResult *)result;
		if(res.success){
            // save current QB users
            [DataManager shared].currentQBUser = res.user;
            
            // enable push notifications at first start app
            if (![NotificationManager isPushNotificationsInitialized]){
                [VKService enablePushNotificationsWithDelegate:self];
            }
            
            [_activityIndicator stopAnimating];
            
            // save credentials
            [[DataManager shared] saveLogin:_phoneTextField.text andPass:_passwordTextField.text];

            // show Messages as 1st opened tab
            [((AppDelegate *)[UIApplication sharedApplication].delegate).viewController setSelectedIndex:1];
            
            // hide Login controller & show main screen
			[self dismissModalViewControllerAnimated:YES];
            
            
            // start track location
            [[[QBLLocationDataSource instance] locationManager] startUpdatingLocation];
            
            
            // enable long pool connection
			[LongPollConnection shared];

        }else if(401 == result.status){
            // Register QB user
            QBUUser *user = [[QBUUser alloc] init];
            user.ownerID = ownerID;        
            NSString *login = [[NumberToLetterConverter instance] convertNumbersToLetters:[DataManager shared].currentUserId];
            NSString *passwordHash = [NSString stringWithFormat:@"%u", [[DataManager shared].currentUserId hash]]; 
            user.login = login;
            user.password = passwordHash;
            user.externalUserID = [[DataManager shared].currentUserId intValue];
            
            [QBUsersService createUser:user delegate:self];
            [user release];
        }
    
    // QB create User
    }else if([result isKindOfClass:[QBUUserResult class]]){
		QBUUserResult *res = (QBUUserResult *)result;
        
		if(res.success){
            // auth again
			[FlurryAnalytics logEvent:@"Was created new QB user"];
			
            QBUUser *qbUser = [[QBUUser alloc] init];
            qbUser.ownerID = ownerID;   
            NSString *login = [[NumberToLetterConverter instance] convertNumbersToLetters:[DataManager shared].currentUserId];
            NSString *passwordHash = [NSString stringWithFormat:@"%u", [[DataManager shared].currentUserId hash]];
            qbUser.login = login;
            qbUser.password = passwordHash;
            [QBUsersService authenticateUser:qbUser delegate:self];
            [qbUser release];

        }else{
            NSString *message = [result.errors stringValue];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errors", nil) 
                                                            message:message  
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            [_activityIndicator stopAnimating];
		}
        
    // Application autorization result
	} else if([result isKindOfClass:[QBAAuthSessionCreationResult class]]){
        // success
        if(result.success){
            // credentials not exist
			[FlurryAnalytics logEvent:@"User was successfully authorized"];
			
            if([[DataManager shared] userLoginAndPass] == nil){
                // hide splash
                [self removeSplash];
                
            }else{
                // sign in
                [self signInButtonDidPress:nil];
            }
        }else{
            NSString *message = [result.errors stringValue];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errors", nil) 
                                                            message:message  
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }	
}

// remove splash
- (void)removeSplash{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
	splashScreen.alpha = 0.0f;
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp 
						   forView:splashScreen 
							 cache:NO];
	[UIView commitAnimations];
}

- (void) animationDidStop{
	[splashScreen removeFromSuperview];
}

@end
