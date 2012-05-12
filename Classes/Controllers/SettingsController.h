//
//  SettingsController.h
//  Vkmsg
//
//  Created by md314 on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "LoginController.h"
#import "ButtonWithUnderlining.h"

@class LoginController;

@interface SettingsController : UIViewController <UIScrollViewDelegate, VKServiceResultDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    BOOL userInitialized;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scroll;
@property (nonatomic, retain) IBOutlet AsyncImageView* photo;
@property (nonatomic, retain) IBOutlet UILabel* name;
@property (nonatomic, retain) IBOutlet UIView* contentView;
@property (nonatomic, retain) IBOutlet UISwitch* vibrateSwitch;
@property (nonatomic, retain) IBOutlet UISwitch* soundSwitch;
@property (nonatomic, retain) IBOutlet UISwitch* bannerSwitch;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* activityIndicator;

@property (nonatomic, retain) NSString* photoUploadURL;
@property (nonatomic, retain) UIImage* tempImage;


-(IBAction)changePicture:(id)sender;
-(IBAction)doNotDisturbFor8Hours:(id)sender;
-(IBAction)doNotDisturbForHour:(id)sender;
-(IBAction)valueChanged:(UISwitch *)theSwitch;

-(IBAction)links:(id)sender;

-(void)logoutButtonDidPress;

@end
