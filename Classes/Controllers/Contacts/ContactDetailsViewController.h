//
//  ContactDetailsViewController.h
//  Vkmsg
//
//  Created by Alexey on 22.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalContactsViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>

@class LocalContactsViewController;

@interface ContactDetailsViewController : UIViewController <MFMessageComposeViewControllerDelegate>
{

}
@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UILabel* phoneNumber;
@property (nonatomic, retain) IBOutlet UILabel* iPhoneNumber;
@property (nonatomic, retain) IBOutlet UIImageView* photo;
@property (nonatomic, retain) IBOutlet UIButton* sendMessageOrInvite;
@property (nonatomic, retain) IBOutlet UIButton* addToFavorites;

@property (nonatomic, retain) NSDictionary* vkUser;
@property (nonatomic, assign) BOOL isContactInVK;

@property (nonatomic, assign) UIViewController *parentController;

- (IBAction)send:(id)sender;
- (IBAction)addToFavorites:(id)sender;
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients;

@end
