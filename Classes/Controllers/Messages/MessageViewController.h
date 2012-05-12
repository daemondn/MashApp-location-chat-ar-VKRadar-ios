//
//  MessageViewController.h
//  Vkmsg
//
//  Created by Rostislav Kobizsky on 4/4/12.
//  Copyright (c) 2012 Injoit Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+HTML.h"
#import "ViewTouch.h"

@interface MessageViewController : UIViewController <VKServiceResultDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSMutableArray *messages;
	NSMutableDictionary *users;
        
    BOOL isChat;
    
    // cloud for message view
    UIImage *messageBGImageLeft;
    UIImage *messageBGImageRight;

    // back view fro hide keyboard
    ViewTouch *backView;
    
    NSUInteger previousUserIDInCell;
    BOOL previousLeftCell;
    
    // user online stat
    UILabel *onlineStat;
    
    // message typing indicator
    UIImageView *messageTypingIndicator;
}
@property (nonatomic, retain) NSDictionary *dialog;

@property (nonatomic, retain) NSDictionary *userOpponent;
@property (nonatomic, retain) NSMutableArray *participants;
@property (nonatomic, assign) UILabel* countOfUserLabel;

// attachments
@property (nonatomic, retain) NSData *imageForAttachment;
@property (nonatomic, retain) CLLocation *locationForAttachment;
@property (nonatomic, retain) NSString *attachment;


@property (nonatomic, retain) IBOutlet UIImageView* paperClip;

@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, retain) IBOutlet UIView *attachView;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *sendMessageActivityIndicator;

@property (nonatomic, assign) BOOL isNewConversation;

-(IBAction) sendMessageButtonDidPress:(id)sender;
-(IBAction) attachButtonDidPress:(id)sender;

- (NSDictionary *)addMessage:(NSDictionary *)message;
- (void)showLastMessageInTable:(NSDictionary *) sectionData;

- (void)scrollTableDownWithAnimation:(BOOL)animation;
- (void)showTypingIndicator:(BOOL)show;

- (void)setParticipantsAndUpdateCount:(NSArray *)user;

- (void) copyMessage:(id)sender;

- (void) deleteMessage:(id)sender;

@end
