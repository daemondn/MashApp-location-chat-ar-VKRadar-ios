//
//  ContactDetailsViewController.m
//  Vkmsg
//
//  Created by Alexey on 22.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactDetailsViewController.h"
#import "MessageViewController.h"

@interface ContactDetailsViewController ()

@end

@implementation ContactDetailsViewController

@synthesize parentController;

@synthesize nameLabel, phoneNumber, iPhoneNumber, photo, sendMessageOrInvite;
@synthesize isContactInVK, addToFavorites;
@synthesize vkUser;

-(void)send:(id)sender
{
    if (((UIButton*)sender).tag == 2)
	{
		NSString *body = [[NSString alloc] initWithFormat:NSLocalizedString(@"Hello! I want to invite you to the VK social network! I'm already there and wait for you.", nil)];
        
		[self sendSMS:body recipientList:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@", phoneNumber.text],[NSString stringWithFormat:@"%@", iPhoneNumber.text], nil]];
        
		[body release];
	}else {
		/* Send message */
        [self.navigationController popViewControllerAnimated:NO]; // remove this view controller
    
        // Start Dialog with friend
        MessageViewController *messagesViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
        messagesViewController.isNewConversation = YES;
        [messagesViewController setUserOpponent:vkUser];
        [self.parentController.navigationController pushViewController:messagesViewController animated:YES];
        [messagesViewController release];
	}
}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
	MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
	if([MFMessageComposeViewController canSendText]){
		controller.body = bodyOfMessage;    
		controller.recipients = recipients;
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
        [UIApplication sharedApplication].statusBarHidden = YES;
	}    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[self dismissModalViewControllerAnimated:YES];
    
    if(result == MessageComposeResultSent){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VK", nil) 
                                                        message:NSLocalizedString(@"Message was sent successfully", nil)
                                                       delegate:nil 
                                              cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if (result == MessageComposeResultFailed){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) 
                                                        message:NSLocalizedString(@"Unable to send a message", nil)
                                                       delegate:nil 
                                              cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)addToFavorites:(id)sender
{
    // add to favorities
    [[DataManager shared] addFavoriteFriend:vkUser];
    addToFavorites.selected = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        addToFavorites.alpha = 0;
    }];
}

// set if person in VK
- (void)setIsContactInVK:(BOOL)_isContactInVK{
    isContactInVK = _isContactInVK;
}

-(void)dealloc
{
    [vkUser release];
    [parentController release];
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

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
            self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    self.sendMessageOrInvite = nil;
    self.phoneNumber = nil;
    self.iPhoneNumber = nil;
    self.nameLabel = nil;
    self.photo =  nil;
    self.addToFavorites = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

@end
