//
//  RegistrationController.m
//  Vkmsg
//
//  Created by md314 on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegistrationController.h"

@interface RegistrationController ()

@end

@implementation RegistrationController
@synthesize phoneTextField, firstNameTextField, lastNameTextField;
@synthesize confirmPhoneTextField, confirmCodeTextField, confirmNewPasswordTextField;
@synthesize confirmButton;

-(void)dealloc
{
    [super dealloc];
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
    
    confirmButton.enabled = NO;
    confirmPhoneTextField.enabled = NO;
    confirmCodeTextField.enabled = NO;
    confirmNewPasswordTextField.enabled = NO;
}

- (void)viewDidUnload
{
    self.phoneTextField = nil;
    self.firstNameTextField = nil;
    self.lastNameTextField = nil;
    //
    self.confirmPhoneTextField = nil;
    self.confirmCodeTextField = nil;
    self.confirmNewPasswordTextField = nil;
    //
    self.confirmButton = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelButtonDidPress:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)registrationButtonDidPress:(id)sender{
    // check phone
	[VKService authCheckPhone:phoneTextField.text delegate:self];
}

-(IBAction)confirmButtonDidPress:(id)sender{
    [VKService conformRegistrationWithPhone:confirmPhoneTextField.text code:confirmCodeTextField.text password:confirmNewPasswordTextField.text delegate:self];
    
    // hide keyboard
    if([confirmPhoneTextField isFirstResponder]){
        [self textFieldShouldReturn:confirmPhoneTextField];
    }else if([confirmCodeTextField isFirstResponder]){
        [self textFieldShouldReturn:confirmCodeTextField];
    }else if([confirmNewPasswordTextField isFirstResponder]){
        [self textFieldShouldReturn:confirmNewPasswordTextField];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// registration block
	if (CGRectContainsPoint(CGRectMake(9, 54, 302, 40), [[[touches allObjects] objectAtIndex:0] locationInView:self.view]))
	{
		[phoneTextField becomeFirstResponder];
	} 
	else if (CGRectContainsPoint(CGRectMake(9, 54, 302, 82), [[[touches allObjects] objectAtIndex:0] locationInView:self.view]))
	{
		[firstNameTextField becomeFirstResponder];
	} 
	else if (CGRectContainsPoint(CGRectMake(9, 54, 302, 128), [[[touches allObjects] objectAtIndex:0] locationInView:self.view]))
	{
		[lastNameTextField becomeFirstResponder];
	}
	
	// confirmation block
	if (CGRectContainsPoint(CGRectMake(9, 284, 302, 40), [[[touches allObjects] objectAtIndex:0] locationInView:self.view]))
	{
		[confirmPhoneTextField becomeFirstResponder];
	} 
	else if (CGRectContainsPoint(CGRectMake(9, 284, 302, 82), [[[touches allObjects] objectAtIndex:0] locationInView:self.view]))
	{
		[confirmCodeTextField becomeFirstResponder];
	} 
	else if (CGRectContainsPoint(CGRectMake(9, 284, 302, 128), [[[touches allObjects] objectAtIndex:0] locationInView:self.view]))
	{
		[confirmNewPasswordTextField becomeFirstResponder];
	}
}


#pragma mark -
#pragma mark VKServiceResultDelegate

-(void)completedWithVKResult:(VKServiceResult *)result{
    // sign up
    if(result.queryType == VKQueriesTypesAuthSignUp){
        if(result.success){
			[FlurryAnalytics logEvent:@"User was successfully registered"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Registration was successful", nil) 
                                                            message:NSLocalizedString(@"An SMS with a special code will be sent to the specified phone number. Please, confirm registration using the form below.", nil)  
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            [phoneTextField resignFirstResponder];
            [firstNameTextField resignFirstResponder];
            [lastNameTextField resignFirstResponder];
            
            // enable confirmation
            confirmButton.enabled = YES;
            confirmPhoneTextField.enabled = YES;
            confirmCodeTextField.enabled = YES;
            confirmNewPasswordTextField.enabled = YES;
            
        }else{
            NSString *message = [result.errors stringValue];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errors", nil) 
                                                            message:message  
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                                  otherButtonTitles:nil];
            alert.tag = 102;
            [alert show];
            [alert release];
            
        }
        
    // confirmation
    }else if(result.queryType == VKQueriesTypesAuthConfirm){
        if(result.success){
            [FlurryAnalytics logEvent:@"User has confirmed their registration"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Confirmation was successful", nil) 
                                                            message:NSLocalizedString(@"Please, Sign in now", nil)  
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                                  otherButtonTitles:nil];
            alert.tag = 101;
            [alert show];
            [alert release];
        }else{
            NSString *message = [result.errors stringValue];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errors", nil) 
                                                            message:message  
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                                  otherButtonTitles:nil];
            alert.tag = 102;
            [alert show];
            [alert release];
            
        }
        
    // check phone registration
    }else if (result.queryType == VKQueriesTypesAuthCheckPhone){
		if (result.success){
            // Sign Up
			[VKService signUpWithPhone:phoneTextField.text firstname:firstNameTextField.text lastname:lastNameTextField.text delegate:self];
		}else {
			NSString *message = [result.errors stringValue];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) 
                                                            message:message 
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                                  otherButtonTitles:nil];
            alert.tag = 102;
            [alert show];
            [alert release];
		}
	}
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    if(textField.tag != 101){
        return YES;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y += 215;
        self.view.frame = frame;
    }]; 
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if(textField.tag != 101){
        return;
    }
    
    if( self.view.frame.origin.y < 0){
        return;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y -= 215;
        self.view.frame = frame;
    }]; 
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField == phoneTextField){
        confirmPhoneTextField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    
    return YES;
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{\
    // Registration was successful alert
    if(alertView.tag == 101){
        [self dismissModalViewControllerAnimated:YES];
    }
}


@end
