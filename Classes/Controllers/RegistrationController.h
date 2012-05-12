//
//  RegistrationController.h
//  Vkmsg
//
//  Created by md314 on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationController : UIViewController <VKServiceResultDelegate, UIAlertViewDelegate, UITextFieldDelegate>
{
}
@property (nonatomic, retain) IBOutlet UITextField *phoneTextField;
@property (nonatomic, retain) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *lastNameTextField;

@property (nonatomic, retain) IBOutlet UITextField *confirmPhoneTextField;
@property (nonatomic, retain) IBOutlet UITextField *confirmCodeTextField;
@property (nonatomic, retain) IBOutlet UITextField *confirmNewPasswordTextField;
//
@property (nonatomic, retain) IBOutlet UIButton *confirmButton;

-(IBAction)cancelButtonDidPress:(id)sender;
-(IBAction)registrationButtonDidPress:(id)sender;
-(IBAction)confirmButtonDidPress:(id)sender;

@end
