//
//  SettingsController.m
//  Vkmsg
//
//  Created by md314 on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsController.h"
#import "AppDelegate.h"

@interface SettingsController ()

@end

@implementation SettingsController

@synthesize scroll, photo, name, contentView, vibrateSwitch, soundSwitch, bannerSwitch, photoUploadURL, tempImage;
@synthesize activityIndicator;

-(void)dealloc
{
    [photoUploadURL release];
    [tempImage release];
    
    [super dealloc];
}

-(IBAction)links:(id)sender
{
	if (((ButtonWithUnderlining*)sender).tag == 0)
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://injoit.com/"]];
	}
	else 
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://quickblox.com/"]];
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    scroll.contentSize = CGSizeMake(320, 500);
    scroll.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    scroll.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    [scroll addSubview:contentView];
    
    [photo.layer setMasksToBounds:YES];
    [photo.layer setCornerRadius:13];
	
	UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", nil) style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonDidPress)]; 
    self.navigationItem.rightBarButtonItem = logoutButton;
    [logoutButton release];
    
    // set switchers
    soundSwitch.on = [NotificationManager isSoundEnabled];
    vibrateSwitch.on = [NotificationManager isVibrationEnabled];
    bannerSwitch.on = [NotificationManager isPushNotificationsEnabled];
	
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutDone) name:kNotificationLogout object:nil];
}

- (void)viewDidUnload
{
    self.activityIndicator = nil;
    
    self.vibrateSwitch = nil;
    self.soundSwitch = nil;
    self.bannerSwitch = nil;
    self.photo = nil;
    self.name = nil;
    self.contentView = nil;
    self.scroll = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLogout object:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // get Current User info
    if(!userInitialized){
        userInitialized = YES;
        
        if([DataManager shared].currentUserBody == nil){
            [VKService usersProfilesWithIds:[DataManager shared].currentUserId delegate:self];
            
            [activityIndicator startAnimating];
        }else{
            // set name
            name.text = [NSString stringWithFormat:@"%@ %@", [[DataManager shared].currentUserBody objectForKey:kUserFirstName], [[DataManager shared].currentUserBody objectForKey:kUserLastName]]; 
            
            // set image
            [photo loadImageFromURL:[NSURL URLWithString:[[DataManager shared].currentUserBody objectForKey:kUserPhoto]]];
        }
    }
    
     [UIApplication sharedApplication].statusBarHidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// logout
-(void)logoutButtonDidPress
{
    // disable push notification
    [VKService disablePushNotificationsWithDelegate:self];
    
    // cleanup
	[DataManager shared].currentUserId = nil;
    [DataManager shared].currentUserBody = nil;
	[DataManager shared].accessToken = nil;
	[DataManager shared].secret = nil;
    [DataManager shared].currentQBUser = nil;
    [DataManager shared].myFriends = nil;
    
    // clear credentials
	[[DataManager shared] clearLoginAndPass];
    
    // notify
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLogout object:nil];
    
    // show login controller
    [((AppDelegate *)[UIApplication sharedApplication].delegate) showLoginScreen:YES];
}

// logout
- (void)logoutDone{
    userInitialized = NO;
}

-(void)changePicture:(id)sender
{
    UIActionSheet *attachActionSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                                                   delegate:self 
                                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
                                                     destructiveButtonTitle:nil 
                                                          otherButtonTitles:
                                        NSLocalizedString(@"Take a photo", nil), 
                                        NSLocalizedString(@"Choose photo from gallery", nil), nil];
    
    [attachActionSheet showFromTabBar:self.tabBarController.tabBar];
    [attachActionSheet release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // save choosed photo
	UIImage *imageFromPicker = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    imageFromPicker = [UIImage rotateImageFromCamera:imageFromPicker];
    self.tempImage = imageFromPicker;
    
    
    // get url for upload photo
    [VKService userPhotoURLWithDelegate:self];
    
    [activityIndicator startAnimating];
    
    [self dismissModalViewControllerAnimated:YES];
    
        [UIApplication sharedApplication].statusBarHidden = YES;
}

-(void)doNotDisturbFor8Hours:(id)sender
{
    [VKService setSilenceModeForHours:8 withDelegate:self context:@"8"];
}

-(void)doNotDisturbForHour:(id)sender
{
    [VKService setSilenceModeForHours:1 withDelegate:self context:@"1"];
}

-(void)valueChanged:(UISwitch *)theSwitch
{
    switch (theSwitch.tag) {
            
        // Vibration - enable/disable 
        case 1:
            [NotificationManager vibrationEnable:theSwitch.on];
            break;
        
        // Sound - enable/disable 
        case 2:
            [NotificationManager soundEnable:theSwitch.on];
            break;
            
        // Push notifications - enable/disable
        case 3:
            if (theSwitch.on){
                [VKService enablePushNotificationsWithDelegate:self];
            }else {
                [VKService disablePushNotificationsWithDelegate:self];
            }
            
            [NotificationManager pushNotificationsEnable:theSwitch.on];
            
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark VKServiceResultDelegate

-(void)completedWithVKResult:(VKServiceResult *)result
{
	switch (result.queryType) 
	{
        // get User profile result
		case VKQueriesTypesUsersGet:
			if(result.success)
			{
				// save current user body
				[DataManager shared].currentUserBody = [[result.body objectForKey:kResponse] objectAtIndex:0];
				
				// set image
				[photo loadImageFromURL:[NSURL URLWithString:[[DataManager shared].currentUserBody objectForKey:kUserPhoto]]];
				
				// set name
				name.text = [NSString stringWithFormat:@"%@ %@", [[DataManager shared].currentUserBody objectForKey:kUserFirstName], [[DataManager shared].currentUserBody objectForKey:kUserLastName]]; 
                
                
                [activityIndicator stopAnimating];
			}
			break;
			
        // get Url for upload photo (1)
		case VKQueriesTypesPhotoGetUrl:
			if(result.success)
			{
				self.photoUploadURL = [[result.body objectForKey:kResponse] objectForKey:kUploadUrl];
				NSData* imageData = UIImagePNGRepresentation(tempImage);
				
				// upload photo
				[VKService uploadUserPhoto:imageData toServer:photoUploadURL withDelegat:self];
			}
			break;

        // Upload photo result (2)
		case VKQueriesTypesUploadPhoto:
			if(result.success){
				[VKService saveProfilePhoto:[result.body objectForKey:kPhoto] withServer:[result.body objectForKey:kServer] withHash:[result.body objectForKey:kHash] andDelegate:self];
			}
			break;
			
        // Save profile photo (3)
		case VKQueriesTypesSavePhoto:
			if(result.success)
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VK", nil) 
																message:NSLocalizedString(@"Photo has been updated", nil)    
															   delegate:nil 
													  cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
                
                [activityIndicator stopAnimating];
				
				// update local user photo
				[[DataManager shared].currentUserBody setObject:tempImage forKey:kUserPhoto];
				photo.image = tempImage;
				self.tempImage = nil;
			}
			break;
			
		default:
			break;
	}
}

- (void)completedWithVKResult:(VKServiceResult *)result context:(id)context
{
	if (result.queryType == VKQueriesTypesSetSilenceMode)
	{
		if (result.success)
		{
			if ([context isEqualToString:@"1"])
			{
				 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VK", nil) 
																 message:NSLocalizedString(@"You will not be disturbed for an hour", nil)    
																delegate:nil 
													   cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
													   otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
			else if ([context isEqualToString:@"8"])
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VK", nil) 
																message:NSLocalizedString(@"You will not be disturbed for 8 hours", nil)    
															   delegate:nil 
													  cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		}
	}
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0: {// Take a photo 
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VK", nil) 
                                                                    message:NSLocalizedString(@"This source type is not available on this device", nil)   
                                                                   delegate:self 
                                                          cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                                          otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    return;
            }
            
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imgPicker.delegate = self;
            [self presentModalViewController:imgPicker animated:YES];
            [imgPicker release];
            
        }
        break;
            
        case 1: {// choose from gallery
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VK", nil) 
                                                                message:NSLocalizedString(@"This source type is not available on this device", nil)   
                                                               delegate:self 
                                                      cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
            
            
            

            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            imgPicker.delegate = self;
            [self presentModalViewController:imgPicker animated:YES];
            [imgPicker release];
        }
            
        default:
            break;
    }
}


@end
