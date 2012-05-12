//
//  MessageViewController.m
//  Vkmsg
//
//  Created by Rostislav Kobizsky on 4/4/12.
//  Copyright (c) 2012 Injoit Ltd. All rights reserved.
//

#import "MessageViewController.h"
#import "AsyncImageView.h"
#import "EditConversationViewController.h"
#import "ButtonWithUnderlining.h"
#import "SimpleMapAnnotation.h"
#import "FriendsViewController.h"
#import "ContactsController.h"

#define kTabBarHeight 1
#define messageWidth 235
#define attachmentsSize 115

#define dateKey @"date"
#define messKey @"message"

@interface MessageViewController ()

@end

@implementation MessageViewController

@synthesize dialog, userOpponent;
@synthesize footerView;
@synthesize attachView;
@synthesize textField = _textField;
@synthesize tableView = _tableView;
@synthesize activityIndicator = _activityIndicator;
@synthesize sendMessageActivityIndicator = _sendMessageActivityIndicator;
@synthesize isNewConversation;
@synthesize participants;
@synthesize attachment, imageForAttachment, locationForAttachment;
@synthesize paperClip;
@synthesize countOfUserLabel;

- (void)dealloc
{
	[attachment release];
	[imageForAttachment release];
    [locationForAttachment release];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    self.dialog = nil;
    self.userOpponent = nil;
	self.participants = nil;
    
    [messages release];
	[users release];
	
    [messageBGImageRight release];
    [messageBGImageLeft release];

	
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // messages & users
        messages = [[NSMutableArray alloc] init];
        users = [[NSMutableDictionary alloc] init];
        
        // images for clouds 
        messageBGImageLeft = [[[UIImage imageFromResource:@"Grey_Bubble.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:13] retain];
        messageBGImageRight = [[[UIImage imageFromResource:@"Blue_Bubble.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:13] retain];
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone) {
        // Register notification when the keyboard will be show
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        // Register notification when the keyboard will be hide
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
	
    
    // set Long Pool Notifications
    //
    // user's typing message in dialog
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(typingMessage:) name:uLPNotificationDialogsTyping object:nil];
    
    // user's typing message in chat
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(typingMessage:) name:uLPNotificationMessagesTyping object:nil];
    
    // new message did receive
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessage:) name:uLPNotificationMessageAddPrivate object:nil];
    
    // friend become online
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendBecomeOnline:) name:uLPNotificationFriendsBecomeOnline object:nil];
    
    // friend become offline
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendBecomeOffline:) name:uLPNotificationFriendsBecomeOffline object:nil];
    
    
    [_activityIndicator startAnimating];
    
    // chat
    if ([dialog objectForKey:kMessageChatId]) {
        isChat = YES;
        
        [self setTitle:[dialog objectForKey:kMessageTitle]];
		
        // get chat history
        [VKService messagesGetHistoryChat:[[dialog objectForKey:kMessageChatId] intValue] delegate:self];
        
        
        // set right bar button
        //
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
		rightButton.contentMode = UIViewContentModeScaleAspectFit;
        [rightButton addTarget:self action:@selector(rightButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
		//
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dialogsButton.png"]];
		[rightButton addSubview:imageView];
        [imageView release];
        //
		countOfUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, -1, 10, 30)];
		[countOfUserLabel setBackgroundColor:[UIColor clearColor]];
		[countOfUserLabel setTextColor:[UIColor whiteColor]];
		[rightButton addSubview:countOfUserLabel];
        [countOfUserLabel release];
        //
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        [rightButton release];
        self.navigationItem.rightBarButtonItem = anotherButton;
        [anotherButton release];
        
        // private room
    } else {
        isChat = NO;
        
        // get user history
        [VKService messagesGetHistoryUser:[[userOpponent objectForKey:kUid] intValue] delegate:self]; 
        
        // set title
        NSString *title = [userOpponent objectForKey:kUserFirstName]; 
        [self setTitle:title];
        
        
        // set right button with user photo
        UIView *rightButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
        
		AsyncImageView *userPic = [[AsyncImageView alloc] initWithFrame:CGRectMake(60, 0, 30, 30)];
        userPic.useMask = YES;
        [userPic loadImageFromURL:[NSURL URLWithString: [userOpponent objectForKey:kUserPhoto]]];
        
        if( [[userOpponent objectForKey:kUserOnline] intValue] ? YES:NO) { 
            onlineStat = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
            [onlineStat setTextAlignment:UITextAlignmentCenter];
            [onlineStat setBackgroundColor:[UIColor clearColor]];
            [onlineStat setTextColor:[UIColor whiteColor]];
            [onlineStat setFont:[UIFont boldSystemFontOfSize:12]];
            [onlineStat setText:NSLocalizedString(@"Online", nil)];
            [rightButton addSubview:onlineStat];
            [onlineStat release];
        }
        
        [rightButton addSubview:userPic];
        [userPic release];
        
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = anotherButton;
        [anotherButton release];
        
        [rightButton release];
    }

    // paddings for text field
    UIView *leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    UIView *rightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 0)];
    [leftPaddingView setBackgroundColor:[UIColor redColor]];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.leftView = leftPaddingView;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    _textField.rightView = rightPaddingView;
    [leftPaddingView release];
    [rightPaddingView release];
    
    if(isNewConversation){
        [_textField becomeFirstResponder];
    }
}

- (void)viewDidUnload
{
    self.footerView = nil;
    self.attachView = nil;
    self.textField = nil;
    self.tableView = nil;
    self.activityIndicator = nil;
    self.sendMessageActivityIndicator = nil;
    self.paperClip = nil;
    
    // remove observers
	[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardDidShowNotification 
                                                  object:nil]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:uLPNotificationMessagesTyping 
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:uLPNotificationDialogsTyping 
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:uLPNotificationMessageAddPrivate 
                                                  object:nil];

    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark -
#pragma mark Methods

- (void)rightButtonDidPress
{
    [_textField resignFirstResponder];
    
    // show message controller
    EditConversationViewController *editConversationViewController = [[EditConversationViewController alloc] initWithNibName:@"EditConversationViewController" bundle:nil];
    editConversationViewController.messagesViewController = self;
    editConversationViewController.chatID = [[dialog objectForKey:kMessageChatId] intValue];
    [self.navigationController pushViewController:editConversationViewController animated:YES];
    [editConversationViewController release];
}

// Send message
-(IBAction) sendMessageButtonDidPress:(id)sender{
        
    if([_sendMessageActivityIndicator isAnimating]){
        return;
    }

    NSString *text = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([text length] == 0){
        if(!imageForAttachment && !attachment && !locationForAttachment){
            return;
        }
    }
    
    // show wheel
    [_sendMessageActivityIndicator startAnimating];
    // hide clip
    paperClip.hidden = YES;
    [_textField.rightView setFrame:CGRectMake(0, 0, 6, 0)];
    
    
    // upload attachments
    if(imageForAttachment){
        // get message upload server
        [VKService getMessagesUploadServerWithDelegate:self];
        return;
    }
    
    // send message to User
    if(userOpponent){
        [VKService messagesSendToUser:[[userOpponent objectForKey:kUid] intValue] message:text withAttachment:attachment andLocation:locationForAttachment delegate:self];
    
    // to chat
    }else{
         [VKService messagesSendToChat:[[dialog objectForKey:kMessageChatId] intValue] message:text withAttachment:attachment andLocation:locationForAttachment delegate:self];
    }
    
    _textField.text = @"";
}

// Show attach view
-(IBAction) attachButtonDidPress:(id)sender{
    if([_sendMessageActivityIndicator isAnimating]){
        return;
    }
    
    // show action sheet
    
    // not attached yet
	if (imageForAttachment == nil && locationForAttachment == nil){
		UIActionSheet *attachActionSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                                      delegate:self 
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
                                        destructiveButtonTitle:nil 
                                             otherButtonTitles:
                                            NSLocalizedString(@"Take a photo", nil), 
                                            NSLocalizedString(@"Choose photo from gallery", nil),
                                            NSLocalizedString(@"My location", nil), nil];
    
    
		[attachActionSheet showFromTabBar:self.tabBarController.tabBar];
        [attachActionSheet release];
	
    // already attached
    }else {
		UIActionSheet *attachActionSheet = [[UIActionSheet alloc] initWithTitle:nil 
																	   delegate:self 
															  cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
														 destructiveButtonTitle:nil 
															  otherButtonTitles:
                                                            NSLocalizedString(@"Remove attachment", nil), nil];
		
		
		[attachActionSheet showFromTabBar:self.tabBarController.tabBar];
        [attachActionSheet release];
	}
}

// add message to table, return section
- (NSDictionary *)addMessage:(NSDictionary *)_message{
    
    NSMutableDictionary *mutableMessage = [_message mutableCopy];
    
    // date
    NSString *dateInterval = [[mutableMessage objectForKey:kMessageDate] description];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateInterval integerValue]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setLocale:[NSLocale currentLocale]];
	NSString* dateVal;
    [dateFormat setDateFormat:@"d MMMM"];
	dateVal = [dateFormat stringFromDate:date];
	if ([date timeIntervalSinceNow] > -86400)
	{
		dateVal = NSLocalizedString(@"Today", nil);
	}
	else if (([date timeIntervalSinceNow] < -86400) && ([date timeIntervalSinceNow] > -172800))
	{
		dateVal = NSLocalizedString(@"Yesterday", nil);
	}
    [dateFormat release];
    
    
    // add message
    NSDictionary *lastSection = [messages lastObject];
    if(!lastSection) {
        lastSection = [[NSMutableDictionary alloc] init];
        [lastSection setValue: dateVal forKey: dateKey];
        NSMutableArray *messagesInSection = [[NSMutableArray alloc] init];
        [messagesInSection addObject: mutableMessage];
        [lastSection setValue: messagesInSection forKey: messKey];
        [messagesInSection release];
        [messages addObject:lastSection];
        [lastSection release];
    } else {
        if([[[lastSection objectForKey: dateKey] description] isEqualToString: dateVal]) {
            NSMutableArray *messagesInSection = [lastSection objectForKey: messKey];
            [messagesInSection addObject:mutableMessage];
        } else {
            lastSection = [[NSMutableDictionary alloc] init];
            [lastSection setValue: dateVal forKey:dateKey];
            NSMutableArray *messagesInSection = [[NSMutableArray alloc] init];
            [messagesInSection addObject:mutableMessage];
            [lastSection setValue:messagesInSection forKey:messKey];
            [messagesInSection release];
            [messages addObject:lastSection];
            [lastSection release];
        }
    }
    
    [mutableMessage release];
    
    return lastSection;
}

- (void)showLastMessageInTable:(NSDictionary *) sectionData{

    int section = [messages indexOfObject:sectionData];
    int row = [[sectionData objectForKey:messKey] count]-1;
    
    // insert new message to table
    NSIndexPath *newMessagePath = [NSIndexPath indexPathForRow:row inSection:section];
    NSArray *newRows = [[NSArray alloc] initWithObjects:newMessagePath, nil];
    if(section >= _tableView.numberOfSections){
        [_tableView insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationMiddle];
    }else{
        [_tableView insertRowsAtIndexPaths:newRows withRowAnimation:UITableViewRowAnimationMiddle];
    }
    [newRows release];
    
    // scroll table to down
    [self scrollTableDownWithAnimation:YES];
    
    // remove typing indicator
    [self showTypingIndicator:NO];
}

// show message typing indicator
- (void)showTypingIndicator:(BOOL)show{
    if(show){
        if(messageTypingIndicator != nil){
            return;
        }
            
        // create & show  messageTyping view
        messageTypingIndicator = [[UIImageView alloc] initWithImage:[UIImage imageFromResource:@"Typing.png"]];
        [messageTypingIndicator setFrame:CGRectMake(3, 360, 55, 28)];
        messageTypingIndicator.alpha = 0;
        [self.view addSubview:messageTypingIndicator];
        [messageTypingIndicator release];
        
        [UIView animateWithDuration:0.3 animations:^{
            messageTypingIndicator.alpha = 1;
            CGRect tableFrame = _tableView.frame;
            tableFrame.size.height -= 30;
            _tableView.frame = tableFrame;
        }];
        
        [self scrollTableDownWithAnimation:YES];
        

    // hide  messageTyping view
    }else {
        if(messageTypingIndicator == nil){
            return;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            messageTypingIndicator.alpha = 1;
            CGRect tableFrame = _tableView.frame;
            tableFrame.size.height += 30;
            _tableView.frame = tableFrame;
        } completion:^(BOOL finished) {
            [messageTypingIndicator removeFromSuperview];
            messageTypingIndicator = nil;
        }];
    }
}

// scroll table down
- (void)scrollTableDownWithAnimation:(BOOL)animation {

    
    // add new message to table
    int section = [messages count]-1;
    if(section < 0){
        return;
    }
    
    int row = [[[messages lastObject] objectForKey:messKey] count]-1;
    
    
	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:row
												   inSection:section];
	
	[_tableView scrollToRowAtIndexPath:topIndexPath 
					  atScrollPosition:UITableViewScrollPositionMiddle 
							  animated:animation];
}

// set particiopants
- (void)setParticipantsAndUpdateCount:(NSArray *)_participants{
    
    for (NSDictionary *user in _participants) {
        [users setObject: [user retain] forKey: [[user objectForKey: kUserUid] description]];
    }

    //
    // add self 
    [users setObject: [DataManager shared].currentUserBody forKey: [[[DataManager shared].currentUserBody objectForKey: kUserUid] description]];
    
    // set user count
    if(isChat){
        countOfUserLabel.text = [NSString stringWithFormat:@"%i", [[users allKeys] count]];
    }
}

#pragma mark -
#pragma mark Notifications

- (void)typingMessage:(NSNotification *)notification {
	NSArray *param = (NSArray *)[notification object];
    int userID = [[param objectAtIndex:0] intValue];
    int chatOrFlags = [[param objectAtIndex:1] intValue];

    // dialog
    if(chatOrFlags == 1){
        if(isChat){
            return;
        }
        
        int opponentId = [[userOpponent objectForKey:kUid] intValue];
        if(opponentId != userID){
            return;
        }

    // chat
    }else{
        if(!isChat){
            return;
        }
        
        int chatId = [[dialog objectForKey:kMessageChatId] intValue];
        if(chatOrFlags != chatId){
            return;
        }
    }

    // show typing view
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self showTypingIndicator:YES];
    [self performSelector:@selector(showTypingIndicator:) withObject:nil afterDelay:5];

	NSLog(@"Message typing... %@",param);
}

- (void)didReceiveNewMessage:(NSNotification *)notification {
	NSArray *param = (NSArray *)[notification object];
    
    NSArray *flags = [param objectAtIndex:1];
    
    // own message
    if([flags containsObject:[NSString stringWithFormat:@"%d", OUTBOX]]){
        return;
    }
    
    
    // check if this message for this conversation or not
    NSString *fromString = [[param objectAtIndex:2] description];
    NSUInteger fromCheck = 0;
    if([fromString length] > 8){
        fromCheck = [[fromString substringToIndex:8] intValue];
    }
    
    NSUInteger fromID = [[param objectAtIndex:2] unsignedIntValue];
    // chat
    if(fromCheck == 20000000){
        if(!isChat){
            return;
        }
        
        int chatID = [[[[param objectAtIndex:2] description] substringFromIndex:8] intValue];
        if(chatID != [[dialog objectForKey:kMessageChatId] intValue]){
            return;
        }
        NSLog(@"didReceiveNewMessage - CHAT, cid=%d", chatID);
    
    // dialog
    }else{
        if(isChat){
            return;
        }
        
        if(fromID != [[userOpponent objectForKey:kUid] intValue]){
            return;
        }

        NSLog(@"didReceiveNewMessage - DIALOG, from_id=%d", fromID);
    }
        
    // get message body
    [VKService messagesGetById:[[param objectAtIndex:0] intValue] delegate:self];
}

- (void)friendBecomeOnline:(NSNotification *)notification {
    NSArray *param = (NSArray *)[notification object];
    NSLog(@"friendBecomeOnline,  %@", param);
}

- (void)friendBecomeOffline:(NSNotification *)notification {
    NSArray *params = (NSArray *)[notification object];
    NSLog(@"friendBecomeOffline,  %@", params);
    
    /*
    // private dialog
    if(userOpponent){
        NSUInteger userOpponentId = [[userOpponent objectForKey:kUid] intValue];
        
        if([[params objectAtIndex:0] isKindOfClass:NSArray.class]){
            for(NSArray *param in params){
                // opponent become offline
                if(abs([[param objectAtIndex:0] intValue]) == userOpponentId){
                    NSMutableDictionary *user = [userOpponent mutableCopy];
                    [user setObject:[NSNumber numberWithInt:0] forKey:kUserOnline]; 
                    self.userOpponent = user;
                    [user release];
                    [onlineStat removeFromSuperview];
                    break;
                }
            }
        }else{
            // opponent become offline
            int friendID = abs([[params objectAtIndex:0] intValue]);
            if(friendID == userOpponentId){
                NSMutableDictionary *user = [userOpponent mutableCopy];
                [user setObject:[NSNumber numberWithInt:0] forKey:kUserOnline]; 
                self.userOpponent = user;
                [user release];
                [onlineStat removeFromSuperview];
            }
        }
    }*/
}


#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [messages count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[messages objectAtIndex:section] valueForKey:messKey] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSDictionary *section = (NSDictionary *)[messages objectAtIndex:[indexPath section]];
	
    NSMutableDictionary *messageItem = (NSMutableDictionary *)[[section objectForKey:messKey] objectAtIndex:[indexPath row]];
    
    float cellHeight;
    
    // text
    NSString *messageText = [[messageItem objectForKey:kMessageBody] stringByDecodingHTMLEntities];
    //
    CGSize boundingSize = CGSizeMake(messageWidth-20, 10000000);
    CGSize itemTextSize = [messageText sizeWithFont:[UIFont systemFontOfSize:15]
								   constrainedToSize:boundingSize
									   lineBreakMode:UILineBreakModeWordWrap];
    
    // plain text
    cellHeight = itemTextSize.height;
	
    // attachments
    NSArray *attachments = [messageItem objectForKey:kMessageAttachments];
    if(attachments){
        for(NSDictionary *attach in attachments){
            NSString *type = [attach objectForKey:kType];
            
            // photo attach
            if([type isEqualToString:kPhoto]){ //  "src_small" = "http://cs10419.userapi.com/u6816492/13030677/s_5483c206.jpg";
                cellHeight += attachmentsSize;
                
                // audio attach
            }else if([type isEqualToString:kAudio]){ // url = "http://cs4629.vkontakte.ru/u13774611/audio/cf9c76fca1a7.mp3";
                // artist = Slipknot;
                // title = Sulfur;
                cellHeight += 30;
                
                // video attach
            }else if([type isEqualToString:kVideo]){ // "image_small" = "http://cs4655.userapi.com/u71944943/video/s_63b9c74c.jpg";
                cellHeight += attachmentsSize;
                
                // doc attach
            }else if([type isEqualToString:kDoc]){ // url = "http://vk.com/doc6816492_68617372?hash=7c3b6d5e7751b11c77&dl=c348f42ebeede91c19";
                cellHeight += 30;
            }
        }
    }
    
    // geo point
    NSDictionary *geoPoint = [messageItem objectForKey:kGeo]; 
    if(geoPoint != nil){ // coordinates = "49.9934948943 36.230385997";
        // type = point;
        cellHeight += attachmentsSize;
    }
    
    cellHeight += ([attachments count] * 5);//intervals between attachments

    return cellHeight + 28;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // section
	NSDictionary *section = (NSDictionary *)[messages objectAtIndex:[indexPath section]];
    
    
    // message
	NSMutableDictionary *messageItem = (NSMutableDictionary *)[[section objectForKey:messKey] objectAtIndex:[indexPath row]];
    
    // User id
    BOOL isMessageFromHistory = YES;
    NSNumber *uid = [messageItem objectForKey:kMessageFromUid]; // history
    if(uid == nil){ 
        isMessageFromHistory = NO;
        uid = [messageItem objectForKey:kUid]; // new message from long pool
    }
    
    // User
	NSDictionary *user = (NSDictionary *)[users objectForKey:[uid description]];
    if(user == nil){
        user = [DataManager shared].currentUserBody;
    }
    
    // message
    NSString *messageText = [[messageItem objectForKey:kMessageBody] stringByConvertingHTMLToPlainText];

    static NSString *reuseIdentifier = @"MessageCellReuseIdentifier";

    
    // create cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    AsyncImageView *userPhoto;
    UIImageView *messageBGView;
    
    UILabel *userMessage;
    UILabel *datetime;
    UIView *readStatusBG;
    UIView *attachmentsView;
    
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        // read state bg
        readStatusBG = [[UIView alloc] init];
        readStatusBG.tag = 105;
        [readStatusBG setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:readStatusBG];
        [readStatusBG release];
        
        // background cloud
        messageBGView = [[UIImageView alloc] init];
        messageBGView.tag = 102;
        messageBGView.userInteractionEnabled = YES;
        [cell.contentView addSubview:messageBGView];
        [messageBGView release];

        
        // user photo (only in chat)
        if(isChat){
            userPhoto = [[AsyncImageView alloc] init];
            userPhoto.layer.masksToBounds = YES;
            userPhoto.tag = 101;
            userPhoto.layer.cornerRadius = 15;
            [cell.contentView addSubview:userPhoto];
            [userPhoto release];
        }
        
        // user message
        userMessage = [[UILabel alloc] init];
        userMessage.tag = 103;
        [userMessage setFont:[UIFont systemFontOfSize:15]];
        userMessage.numberOfLines = 0;
        [userMessage setBackgroundColor:[UIColor clearColor]];
        [messageBGView addSubview:userMessage];
        [userMessage release];
        
        // datetime
        datetime = [[UILabel alloc] init];
        datetime.tag = 104;
        [datetime setTextAlignment:UITextAlignmentCenter];
        datetime.numberOfLines = 2;
        [datetime setFont:[UIFont systemFontOfSize:14]];
        [datetime setBackgroundColor:[UIColor clearColor]];
        [datetime setTextColor:[UIColor grayColor]];
        [cell.contentView addSubview:datetime];
        [datetime release];
        
        // attachmnets view
        attachmentsView = [[UIView alloc] init];
        attachmentsView.tag = 106;
        [attachmentsView setBackgroundColor:[UIColor clearColor]];
        [messageBGView addSubview:attachmentsView];
        [attachmentsView release];
        
    }else{
        userPhoto = (AsyncImageView *)[cell.contentView viewWithTag:101];
        messageBGView = (UIImageView *)[cell.contentView viewWithTag:102];
        userMessage = (UILabel *)[messageBGView viewWithTag:103];
        datetime = (UILabel *)[cell.contentView viewWithTag:104];
        readStatusBG = (UIView *)[cell.contentView viewWithTag:105];
        attachmentsView = (UIView *)[messageBGView viewWithTag:106];
        for(UIView *view in attachmentsView.subviews){
            [view removeFromSuperview];
        }
    }

    
    // set datetime
    NSString *dateInterval = [[messageItem objectForKey:kMessageDate] description];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateInterval integerValue]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setDateFormat:@"HH:mm"];
    datetime.text = [dateFormat stringFromDate:date]; 
    [dateFormat release];
    
    
    
    // left or rigth cell
    BOOL isLeftCell = NO;
    if(isChat){
        
        if([uid intValue]== previousUserIDInCell){
            isLeftCell = previousLeftCell;
        }else{
            isLeftCell = !previousLeftCell;
        }
        
        // save prev user id
        previousUserIDInCell = [uid unsignedIntValue];
    }else{
        // в from_id/uid будет uid пользователя, с которым вы ведете диалог. Опознать, ваше это сообщение или его, можно с помощью флагов (исходящее - от вас, входящее - от него)
        
        // left - i am
        // right - opponent
        if(isMessageFromHistory){ // history
            if([uid intValue] == [[[DataManager shared].currentUserBody objectForKey:kUid] intValue]){
                isLeftCell = YES;
            }
        }else{ // new message from long pool
            if([[messageItem objectForKey:kMessageOut] intValue] == 1){
                isLeftCell = YES;
            }
        }
    }

    
    // get height
    CGSize boundingSize = CGSizeMake(messageWidth-20, 10000000);
    CGSize itemTextSize = [messageText sizeWithFont:[UIFont systemFontOfSize:15]
                                  constrainedToSize:boundingSize
                                      lineBreakMode:UILineBreakModeWordWrap];
    
    // cell height
    float textHeight = itemTextSize.height + 7;
    float cellHeight = itemTextSize.height;


    
    float messageTextWidth;
    float messageTextHeight;
    
    if(isLeftCell){
        // set message label
        [userMessage setFrame:CGRectMake(15, 6, messageWidth-20, textHeight-10)];
        userMessage.text = messageText;
        [userMessage sizeToFit];
    }else{
        // set message label
        [userMessage setFrame:CGRectMake(10, 6, messageWidth-20, textHeight-10)];
        userMessage.text = messageText; 
        [userMessage sizeToFit];
    }
    messageTextWidth = userMessage.frame.size.width;
    messageTextHeight = userMessage.frame.size.height;
    
    
    
    // attachments
    BOOL isAttacnhmentsExist = NO;
    int previousAttachmentBottomEdge = 0;
    //
    NSArray *attachments = [messageItem objectForKey:kMessageAttachments];
    if(attachments){
        isAttacnhmentsExist = YES;
        for(NSDictionary *attach in attachments){
            NSString *type = [attach objectForKey:kType];
            NSDictionary *attachBody = [attach objectForKey:type];
            
            // photo attach
            if([type isEqualToString:kPhoto]){ //  "src" = "http://cs10419.userapi.com/u6816492/13030677/s_5483c206.jpg";
                cellHeight += attachmentsSize;
                
                AsyncImageView *attachedPhoto = [[AsyncImageView alloc] init];
                [attachedPhoto setFrame:CGRectMake(0, previousAttachmentBottomEdge, attachmentsSize, attachmentsSize)];
                [attachedPhoto loadImageFromURL:[NSURL URLWithString:[attachBody objectForKey:kSrc]]];
                if([attachBody objectForKey:kSrcXXXBig]){
                    attachedPhoto.linkedUrl = [NSURL URLWithString:[attachBody objectForKey:kSrcXXXBig]];
                }else{
                    attachedPhoto.linkedUrl = [NSURL URLWithString:[attachBody objectForKey:kSrcBig]];
                }
                [attachmentsView addSubview:attachedPhoto];
                attachedPhoto.contentMode = UIViewContentModeScaleAspectFit;
                attachedPhoto.tag = 200;
                [attachedPhoto release];
                
                previousAttachmentBottomEdge += (attachmentsSize + 5);
                
            // audio attach
            }else if([type isEqualToString:kAudio]){ // url = "http://cs4629.vkontakte.ru/u13774611/audio/cf9c76fca1a7.mp3";
                // artist = Slipknot;
                // title = Sulfur;
                cellHeight += 30;
                
                NSString *soundName = [NSString stringWithFormat:@"%@ %@", [attachBody objectForKey:kArtist], [attachBody objectForKey:kTitle]];
                
                CGSize size = [soundName sizeWithFont:[UIFont systemFontOfSize:13] 
                                 constrainedToSize:CGSizeMake(attachmentsSize < messageTextWidth ? messageTextWidth-15 : attachmentsSize-15, attachmentsSize)
                                     lineBreakMode:UILineBreakModeWordWrap];
                
                // icon
                UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageFromResource:@"soundIcon@2x.png"]];
                [icon setFrame:CGRectMake(0, previousAttachmentBottomEdge+7, 12, 12)];
                [attachmentsView addSubview:icon];
                [icon release];
                
                
                // link
                ButtonWithUnderlining *audioLinkButton = [[ButtonWithUnderlining alloc] initWithFrame:CGRectMake(15, previousAttachmentBottomEdge, size.width, 25)];
                [audioLinkButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                [audioLinkButton setTitleColor:[UIColor colorWithRed:100.0/255 green:197.0/255 blue:250.0 alpha:1.0] forState:UIControlStateNormal];
                audioLinkButton.backgroundColor = [UIColor clearColor];
                [audioLinkButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [audioLinkButton setTitle:soundName forState:UIControlStateNormal];
                [attachmentsView addSubview:audioLinkButton];
                [audioLinkButton setLinkedUrl:[NSURL URLWithString:[attachBody objectForKey:kUrl]]];
                [audioLinkButton release];
                
                 previousAttachmentBottomEdge += (25 + 5);
                
            // video attach
            }else if([type isEqualToString:kVideo]){ // "image" = "http://cs4655.userapi.com/u71944943/video/s_63b9c74c.jpg";
                // title = "NIGHTWISH - Storytime";
                // vid = 161430487;
                cellHeight += attachmentsSize;
                
                AsyncImageView *attachedVideo = [[AsyncImageView alloc] init];
                [attachedVideo setFrame:CGRectMake(0, previousAttachmentBottomEdge, attachmentsSize, attachmentsSize)];
                [attachedVideo loadImageFromURL:[NSURL URLWithString:[attachBody objectForKey:kImage]]];
                attachedVideo.linkedUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/video%@_%@", VK, [attachBody objectForKey:kOwnerId], [attachBody objectForKey:kVid]]];  
                [attachmentsView addSubview:attachedVideo];
                attachedVideo.tag = 200;
                [attachedVideo release];
                
                UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(attachedVideo.frame.size.width-30, attachedVideo.frame.size.height-17, 30, 15)];
                [durationLabel setBackgroundColor:[UIColor clearColor]];
                [durationLabel setTextColor:[UIColor whiteColor]];
                [durationLabel setFont:[UIFont systemFontOfSize:12]];
                int duration = [[attachBody objectForKey:kDuration] intValue];
                int min = duration/60;
                int sec = duration - 60*min;
                if(sec >= 10){
                    [durationLabel setText:[NSString stringWithFormat:@"%d:%d", min, sec]];
                }else{
                     [durationLabel setText:[NSString stringWithFormat:@"%d:0%d", min, sec]];
                }
                [attachedVideo addSubview:durationLabel];
                [durationLabel release];
                
                previousAttachmentBottomEdge += (attachmentsSize + 5);
                
            // doc attach
            }else if([type isEqualToString:kDoc]){ // url = "http://vk.com/doc6816492_68617372?hash=7c3b6d5e7751b11c77&dl=c348f42ebeede91c19";
                cellHeight += 30;
                
                NSString *docName = [attachBody objectForKey:kTitle];
                
                CGSize size = [docName sizeWithFont:[UIFont systemFontOfSize:13] 
                                    constrainedToSize:CGSizeMake(attachmentsSize < messageTextWidth ? messageTextWidth-15 : attachmentsSize-15, attachmentsSize)
                                        lineBreakMode:UILineBreakModeWordWrap];
                
                // icon
                UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageFromResource:@"docIcon@2x.png"]];
                icon.contentMode = UIViewContentModeCenter;
                [icon setFrame:CGRectMake(0, previousAttachmentBottomEdge+7, 12, 12)];
                [attachmentsView addSubview:icon];
                [icon release];
                
                
                // link
                ButtonWithUnderlining *audioLinkButton = [[ButtonWithUnderlining alloc] initWithFrame:CGRectMake(15, previousAttachmentBottomEdge, size.width, 25)];
                [audioLinkButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                [audioLinkButton setTitleColor:[UIColor colorWithRed:100.0/255 green:197.0/255 blue:250.0 alpha:1.0] forState:UIControlStateNormal];
                audioLinkButton.backgroundColor = [UIColor clearColor];
                [audioLinkButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [audioLinkButton setTitle:docName forState:UIControlStateNormal];
                [attachmentsView addSubview:audioLinkButton];
                [audioLinkButton setLinkedUrl:[NSURL URLWithString:[attachBody objectForKey:kUrl]]];
                [audioLinkButton release];
                
                previousAttachmentBottomEdge += (25 + 5);
            }
        }
    }
    
    // geo point
    NSDictionary *geoPoint = [messageItem objectForKey:kGeo]; 
    if(geoPoint != nil){ // coordinates = "49.9934948943 36.230385997";
                         // type = point;
        NSString *type = [geoPoint objectForKey:kType];
        if([type isEqualToString:kPoint]){
            
            // map
            MKMapView *map = [[MKMapView alloc] initWithFrame:CGRectMake(0, previousAttachmentBottomEdge, attachmentsSize, attachmentsSize)];
            [attachmentsView addSubview:map];
            map.tag = 200;
            [map release];
            NSArray *coordinates = [[geoPoint objectForKey:kCoordinates] componentsSeparatedByString:@" "];
            double lat = [[coordinates objectAtIndex:0] doubleValue];
            double lon = [[coordinates objectAtIndex:1] doubleValue];
            SimpleMapAnnotation *annotation = [[SimpleMapAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon)];
            [map addAnnotation:annotation];
            [annotation release];
            [map setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat, lon), MKCoordinateSpanMake(0.75f, 0.75f)) animated:NO];
            
            isAttacnhmentsExist = YES;
            cellHeight += attachmentsSize;
        } 
    }
    
    cellHeight += ([attachments count] * 5);//intervals between attachments
    
    cellHeight += 28;

    
    // left/right messages
    if(isLeftCell){
        
        if(isAttacnhmentsExist && messageTextWidth < attachmentsSize){ // with attachments
            messageTextWidth = attachmentsSize;
        }
        if(messageTextHeight == 0){
            messageTextHeight = 5;
        }
        
        // set cloud view (left)
        [messageBGView setImage:messageBGImageLeft];
        
        // set user photo
        if(isChat){
            [userPhoto setFrame:CGRectMake(0, cellHeight-32, 30, 30)];
            if([[user objectForKey:kUserPhoto] isKindOfClass:NSString.class]){
                [userPhoto loadImageFromURL:[NSURL URLWithString:[user objectForKey:kUserPhoto]]];
            }else{
                userPhoto.image = [user objectForKey:kUserPhoto];
            }
            
            [messageBGView setFrame:CGRectMake(32, 6, messageTextWidth+25, cellHeight-11)];
        }else{
            [messageBGView setFrame:CGRectMake(0, 6, messageTextWidth+25, cellHeight-11)];
        }
        
        // datetime
        [datetime setFrame:CGRectMake(messageBGView.frame.origin.x+messageBGView.frame.size.width + 2, cellHeight-30, 40, 30)];
        
        // set attachments view frame
        [attachmentsView setFrame: CGRectMake(15, userMessage.frame.origin.y+messageTextHeight, messageTextWidth, cellHeight-messageTextHeight-28)];
        
    }else{

        if(isAttacnhmentsExist && messageTextWidth < attachmentsSize){ // with attachments
            messageTextWidth = attachmentsSize;
        }
        if(messageTextHeight == 0){
            messageTextHeight = 5;
        }
        
        // set cloud view (right)
        [messageBGView setImage:messageBGImageRight];
        
        // set user photo
        if(isChat){
            [userPhoto setFrame:CGRectMake(320-50, cellHeight-32, 30, 30)];
            [userPhoto loadImageFromURL:[NSURL URLWithString:[user objectForKey:kUserPhoto]]];
            
            [messageBGView setFrame:CGRectMake(320-messageTextWidth-77, 6, 
                                  messageTextWidth+25, cellHeight-11)];
        }else{
                
            [messageBGView setFrame:CGRectMake(320-messageTextWidth-44, 6, 
                                               messageTextWidth+25, cellHeight-11)]; 
        }
        
        // datetime
        [datetime setFrame:CGRectMake(messageBGView.frame.origin.x-42, cellHeight-30, 40, 30)];
        
        // set attachments view frame
        [attachmentsView setFrame: CGRectMake(10, userMessage.frame.origin.y+messageTextHeight, messageTextWidth, cellHeight-messageTextHeight-28)];
    }
    
    
    // set read state
    [readStatusBG setFrame:CGRectMake(0, 0, 320, cellHeight)];
    if ([[messageItem objectForKey:kMessageReadState] intValue] == 0 && [[[DataManager shared].currentUserBody objectForKey:kUid] intValue] != [[messageItem objectForKey:kMessageFromUid] intValue]) {
        [readStatusBG  setBackgroundColor:[UIColor colorWithHexString:@"ebf0f5"]]; 
        
        // mark as read
        [VKService messagesMarkAsRead:[[messageItem objectForKey:kMessageMid] intValue] delegate:self context:messageItem];
    } else {
        [readStatusBG  setBackgroundColor:[UIColor clearColor]];
    }
    
    
    // centered attachments view
    for(UIView *attachedView in attachmentsView.subviews){
        if(attachedView.tag != 200){
            continue;
        }
        CGPoint center = attachedView.center;
        center.x = messageBGView.frame.size.width/2-12;
        attachedView.center = center;
    }
    
    
    // save prev cell type
    previousLeftCell = isLeftCell;
    
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [[[messages objectAtIndex:section] objectForKey:dateKey] description];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
	UIMenuController* menu = [UIMenuController sharedMenuController];
	UIMenuItem* copy = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Copy", nil) action:@selector(copyMessage:)];
	UIMenuItem* delete = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Delete", nil) action:@selector(deleteMessage:)];
	menu.menuItems = [NSArray arrayWithObjects:copy,delete, nil];
	menu.arrowDirection = UIMenuControllerArrowDown;
	[menu setTargetRect:[tableView cellForRowAtIndexPath:indexPath].bounds inView:self.view]; // test rect
	[menu setMenuVisible:YES animated:YES];
	
	[copy release];
	[delete release];*/
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // show back view
    if(backView == nil){
        backView = [[ViewTouch alloc] initWithFrame:CGRectMake(0, 0, 320, 154) selector:@selector(touchOnView:) target:self];
        [self.view addSubview:backView];
        [backView release];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [backView removeFromSuperview];
    backView = nil;
}

- (void)touchOnView:(UIView *)view{
    [_textField resignFirstResponder];
}


#pragma mark -
#pragma mark VKServiceResultDelegate

- (void) completedWithVKResult:(VKServiceResult *)result {
    
    switch (result.queryType) {
        // get messages history result
        case VKQueriesTypesMessagesGetHistory: {
            if(result.success){
                NSMutableArray *dialogs = [[result.body objectForKey:kResponse] objectForKey:kExecuteMessageHistory];

                // remove count
                [dialogs removeObjectAtIndex:0];
                
                // count
                int dialogsCount = [dialogs count];
                if(dialogsCount == 0){
                    [_activityIndicator stopAnimating];
                    
                    // just add participants
                    [users setObject:userOpponent forKey: [[userOpponent objectForKey: kUserUid] description]];
                    [users setObject:[DataManager shared].currentUserBody forKey: [[[DataManager shared].currentUserBody objectForKey: kUserUid] description]];
                    
                    participants = [[NSMutableArray alloc] initWithObjects:userOpponent,[DataManager shared].currentUserBody, nil];
                    break;
                }
                
                // chat users ids
                NSString *activeUsers = @"";
            
                // revert iterator
                for (int i = dialogsCount-1; i>=0; i--) {
                    // message
                    NSDictionary *message = [dialogs objectAtIndex:i];
                    
                    
                    // add from user
                    NSString *userUid = [[message objectForKey:kMessageFromUid] description];
                    NSRange textRange = [activeUsers rangeOfString:userUid];
                    if(textRange.location == NSNotFound){					
                        activeUsers = [activeUsers stringByAppendingString:userUid];
                        if (i>0) {
                            activeUsers = [activeUsers stringByAppendingString:@","]; 
                        }
                    }
                    
                    // add message to table
                    [self addMessage:message]; 
                }
                
                // set Partisipants
				self.participants = [[[[result.body objectForKey:kResponse] objectForKey:kExecuteMessageUsers] mutableCopy] autorelease];
                if(!isChat){
                    if(![users objectForKey:[[userOpponent objectForKey:kUid] description]]){
                        [participants addObject:userOpponent];
                    }
                }
                [self setParticipantsAndUpdateCount:participants];
                
                // refresh table
                [_tableView reloadData];
                [self scrollTableDownWithAnimation:NO];
                
                [_activityIndicator stopAnimating];
            }
			
        }
			break;
		 
        // send message result
        case VKQueriesTypesMessagesSend:
            [_sendMessageActivityIndicator stopAnimating];
            if(result.success){
                self.attachment = nil;
                self.locationForAttachment = nil;
                
                NSDictionary *message = [[result.body objectForKey:kResponse] objectAtIndex:1];
                NSDictionary *user = [DataManager shared].currentUserBody;
                
                // set user
                [users setObject:user forKey: [[user objectForKey: kUserUid] description]];
                
                // add own message to table
                [self showLastMessageInTable:[self addMessage:message]];  
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VK", nil) 
                                                                message:NSLocalizedString(@"Message was not sent. Try again later", nil)    
                                                               delegate:nil 
                                                      cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            break;
			
        // get upload server for message result 
		case VKQueriesTypesMessagesGetUploadServer:
            if(result.success){
                // upload photo
				[VKService uploadUserPhoto:imageForAttachment 
								  toServer:[[result.body objectForKey:kResponse] objectForKey:kUploadUrl] 
							   withDelegat:self];
            }
            break;
			
        // upload photo result
		case VKQueriesTypesUploadPhoto:
			if (result.success){
                // save message photo
				[VKService saveMessagePhoto:[result.body objectForKey:kPhoto]
                                   toServer:[result.body objectForKey:kServer] 
                                   withHash:[result.body objectForKey:kHash] 
                                andDelegate:self];
			}
			break;
			
        // save photo result
		case VKQueriesTypesSavePhoto:
			if (result.success){
                [_sendMessageActivityIndicator stopAnimating];
                self.imageForAttachment = nil;
                
                // save attachment link
				self.attachment = [NSString stringWithString:[[[result.body objectForKey:kResponse] objectAtIndex:0] 
                                                              objectForKey:kId]];

                // send message
                [self sendMessageButtonDidPress:nil];
			}
			break;
            
        // get message by ID result
        case VKQueriesTypesMessagesGetById: 
            if(result.success){
                NSDictionary *message = [[[result.body objectForKey:kResponse] objectForKey:kExecuteMessageMessage] objectAtIndex:1];
                NSDictionary *user = [[[result.body objectForKey:kResponse] objectForKey:kExecuteMessageUser] objectAtIndex:0];

                // set user
                [users setObject:user forKey: [[user objectForKey: kUserUid] description]];
                
                // add message to table
                [self showLastMessageInTable:[self addMessage:message]];  
            }
            break;

        default:
            break;
    } 
}

- (void) completedWithVKResult:(VKServiceResult *)result context:(id)context{
    switch (result.queryType) {

        // mark message as read result
        case VKQueriesTypesMessagesMarkAsRead:
            if(result.success){
                
                [context setObject:[NSNumber numberWithInt:1] forKey:kMessageReadState];
                [_tableView reloadData];
                
                // set application badge
                int newBadgeValue = [UIApplication sharedApplication].applicationIconBadgeNumber - 1;
                if(newBadgeValue < 0){
                    newBadgeValue = 0;
                }
                [UIApplication sharedApplication].applicationIconBadgeNumber = newBadgeValue;

                //
                // set messages badge
                  UITabBarController *tabBarController = ((UIViewController *)[self.navigationController.viewControllers objectAtIndex:0]).tabBarController;
                int badge = [((UITabBarItem *)[tabBarController.tabBar.items objectAtIndex:1]).badgeValue intValue];
                --badge;
                if(badge <= 0){
                    // set badge
                    ((UITabBarItem *)[tabBarController.tabBar.items objectAtIndex:1]).badgeValue = nil;
                }else{
                    // set badge
                    ((UITabBarItem *)[tabBarController.tabBar.items objectAtIndex:1]).badgeValue = [NSString stringWithFormat:@"%d", badge];
                }
            }
            break;

        default:
            break;
    }
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0: // Take a photo / remove attachment
            
            // remove attachments
            if(imageForAttachment || locationForAttachment){ 
                self.imageForAttachment = nil;
                self.locationForAttachment = nil;
                
                // hide clip
                paperClip.hidden = YES;
                [_textField.rightView setFrame:CGRectMake(0, 0, 6, 0)];
                
            // take photo from camera
            }else{
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
            
        case 1: {// choose from gallery/cancel

            if(imageForAttachment || locationForAttachment){ //cancel
                break;
            }
            
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
            
            break;
        case 2:{ // my location
            self.locationForAttachment = [QBLLocationDataSource instance].currentLocation;
            
            // show clip
            paperClip.hidden = NO;
            [_textField.rightView setFrame:CGRectMake(0, 0, 20, 0)];
        }
            
            break;
        case 3: // add participant
            break;
            
        case 4: // cancel
            break;
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // save photo for attacment
	UIImage *imageFromPicker = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    imageFromPicker = [UIImage rotateImageFromCamera:imageFromPicker];
    
    self.imageForAttachment = UIImagePNGRepresentation(imageFromPicker);

    
    // show clip
    paperClip.hidden = NO;
    [_textField.rightView setFrame:CGRectMake(0, 0, 20, 0)];
	
	[self dismissModalViewControllerAnimated:YES];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
}


#pragma mark - 
#pragma mark Keyboard 

-(void) keyboardWillShow:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.tableView.frame;
        frame.size.height = 386-keyboardBounds.size.height;
        self.tableView.frame = frame;
        
        [footerView setFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame), 
                                        footerView.frame.size.width, footerView.frame.size.height)];
        
        [self scrollTableDownWithAnimation:YES];
    }];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.tableView.frame;
        frame.size.height = 386;
        self.tableView.frame = frame;
        
        [footerView setFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(frame), 
                                        footerView.frame.size.width, footerView.frame.size.height)];
        
        [self scrollTableDownWithAnimation:YES];
    }];
}

@end
