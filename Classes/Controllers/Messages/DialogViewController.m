//
//  DialogViewController.m
//  Vkmsg
//
//  Created by Rostislav Kobizsky on 4/4/12.
//  Copyright (c) 2012 Injoit Ltd. All rights reserved.
//

#import "DialogViewController.h"
#import "FriendsViewController.h"

@interface DialogViewController ()

@end

static NSString *rects[4][4] =  {
    {@"{{0, 0}, {50, 50}}", @"{{0,0},{0,0}}", @"{{0,0},{0,0}}", @"{{0,0},{0,0}}"} , 
    {@"{{0, 0}, {24, 50}}", @"{{26, 0}, {24, 50}}", @"{{0,0},{0,0}}", @"{{0,0},{0,0}}"} , 
    {@"{{0, 0}, {24, 50}}", @"{{26, 0}, {24, 24}}", @"{{26, 26}, {24, 24}}", @"{{0,0},{0,0}}"} , 
    {@"{{0, 0}, {24, 24}}", @"{{24, 0}, {24, 24}}", @"{{0, 24}, {24, 24}}", @"{{24,24},{24,24}}"}
    
};

@implementation DialogViewController

@synthesize searchBar = _searchBar;

- (void) dealloc {
    [searchArray release];
	
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        searchArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}


#pragma mark 
#pragma mark View's cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]] autorelease];
    [self.tableView setBackgroundView:background];
                        
       
    // activity indicator
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(160, 200);
    activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicator];
    [activityIndicator release];
    
    // rign bar item action
    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(chooseFriend);
    
    self.navigationController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutDone) name:kNotificationLogout object:nil];
}

- (void)viewDidUnload
{
    self.searchBar = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLogout object:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	
	[FlurryAnalytics logEvent:@"User visit message tab"];
	
    [self setTitle:NSLocalizedString(@"Messages", nil)];
    
    if(!isInitialized){
        isInitialized = YES;
        
        // get dialogs
        [VKService dialogsWithDelegate:self];
        
        if([[DataManager shared].messagesDialogs count] == 0){
            [activityIndicator startAnimating];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)logoutDone{
    isInitialized = NO;
    [searchArray removeAllObjects];
            [self.tableView reloadData];
}

// shoose friend to start dialog
- (void)chooseFriend{
    // show friends
    FriendsViewController *friendsViewController = [[FriendsViewController alloc] init];
    friendsViewController.parentController = self;
    friendsViewController.openedFromMessagesController = YES;
    [self.navigationController pushViewController:friendsViewController animated:YES];
    [friendsViewController release];
}

// pull down to refresh
- (void)refresh 
{
    // get dialogs
    [VKService dialogsWithDelegate:self];
}

- (void) updateDialogs:(NSDictionary *) responce {
    // stop pull down to refresh
    [self stopLoading];   
    
    
    // if we dont have dialogs (dialogs = 0)
    if(![[responce objectForKey: kExecuteMessageDialogs] isKindOfClass:NSMutableArray.class]){
        return;
    }
    
    
    // clear
    [[DataManager shared].messagesDialogs removeAllObjects];
    
    NSMutableArray *newDialogs = [[responce objectForKey: kExecuteMessageDialogs] mutableCopy];
    [newDialogs removeObjectAtIndex:0];
    
    
    // Not read dialods count 
    int notReadDilogsCount = 0; 
    for(NSDictionary *dialog in newDialogs){
        if ([[dialog objectForKey:kMessageReadState] intValue] == 0 && [[dialog objectForKey:kMessageOut] intValue] == 0 && [[[DataManager shared].currentUserBody objectForKey:kUid] intValue] != [[dialog objectForKey:kMessageFromUid] intValue]) {
            ++notReadDilogsCount;
        }
    }
    if(notReadDilogsCount == 0){
        // set badge
        ((UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:1]).badgeValue = nil;
    }else{
        // set badge
        ((UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:1]).badgeValue = [NSString stringWithFormat:@"%d", notReadDilogsCount];
    }
                
    
    // add new dialogs
    [[DataManager shared].messagesDialogs addObjectsFromArray:newDialogs];
    [newDialogs release];
    
    
    // users
    NSMutableArray *usersAr = [responce objectForKey: kExecuteMessageUsers];    
    for (NSDictionary *user in usersAr) {
        [[DataManager shared].messagesUsers setObject: user forKey: [[user objectForKey: kUserUid] description]];
    }
    //
    NSMutableArray *usersActiveAr = [responce objectForKey: kExecuteMessageChatActiveUsers];
    if([usersActiveAr isKindOfClass:NSMutableArray.class]){
        for (NSDictionary *user in usersActiveAr) {
            [[DataManager shared].messagesUsers setObject: user forKey: [[user objectForKey: kUserUid] description]];
        }
    }
    
    
    
    // reload table
    [self.tableView reloadData];
}

// delete dialog
- (void)deleteDialog:(UIButton *)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VK", nil) 
                                                    message:NSLocalizedString(@"Are you sure you want to delete all messages in this dialog?", nil)    
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
                                          otherButtonTitles:NSLocalizedString(@"Ok", nil), nil];
    alert.tag = sender.tag;
    [alert show];
    [alert release];    
}


#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // searching
    if([[_searchBar text] length] > 0) {
		return [searchArray count];
    }
    return [[DataManager shared].messagesDialogs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get item
    NSDictionary *item; 
    // searching
    if([[_searchBar text] length] > 0) {
        item = [searchArray objectAtIndex:indexPath.row];
    }else {
        item = [[DataManager shared].messagesDialogs objectAtIndex:indexPath.row];
    }
    
    UILabel *dialogTitle;
    UIView *dialogPicture;
    UIImageView *onlineBadge;
    UIImageView* icon;
	UILabel* lastMessage;
	UILabel* date;
	
    // create cell
    static NSString * reuseIdentifier = @"DialogsCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        // add delete button
        UIButton *crossView = [UIButton buttonWithType:UIButtonTypeCustom];
        [crossView setFrame:CGRectMake(0, 0, 20, 20)];
        [crossView addTarget:self action:@selector(deleteDialog:) forControlEvents:UIControlEventTouchUpInside];
        [crossView setImage:[UIImage imageFromResource:@"deleteCross@2x.png"] forState:UIControlStateNormal];
        cell.accessoryView = crossView;
		
		// date label
		date = [[UILabel alloc] init];
		date.tag = 106;
		[date setFont:[UIFont systemFontOfSize:12]];
		[date setTextAlignment:UITextAlignmentCenter];
        [date setTextColor:[UIColor colorWithHexString:@"31587D"]];
        [date setBackgroundColor:[UIColor clearColor]];
		[cell.contentView addSubview:date];
		[date release];
		
		// last message
		lastMessage = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 200, 20)];
		lastMessage.tag = 105;
		[lastMessage setFont:[UIFont systemFontOfSize:15]];
        [lastMessage setTextColor:[UIColor colorWithHexString:@"454545"]];
        [lastMessage setBackgroundColor:[UIColor clearColor]];
		[cell.contentView addSubview:lastMessage];
		[lastMessage release];
		
        // message title
		dialogTitle = [[UILabel alloc] init];
        dialogTitle.tag = 101;
        [dialogTitle setFont:[UIFont boldSystemFontOfSize:15]];
        [dialogTitle setTextColor:[UIColor colorWithHexString:@"527789"]];
        [dialogTitle setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:dialogTitle];
        [dialogTitle release];
		
		// chat icon
		icon = [[UIImageView alloc] initWithFrame:CGRectMake(59, 10, 17, 14)];
		icon.image = [UIImage imageFromResource:@"MessagesGroup@2x.png"];
		[cell.contentView addSubview:icon];
		icon.tag = 104;
		[icon release];
    }else{
        dialogTitle = (UILabel *)[cell.contentView viewWithTag:101];
		
		lastMessage = (UILabel*)[cell.contentView viewWithTag:105];
		
		date = (UILabel*)[cell.contentView viewWithTag:106];
        
        dialogPicture = [cell.contentView viewWithTag:102];
        [dialogPicture removeFromSuperview];
        
        onlineBadge = (UIImageView *)[cell.contentView viewWithTag:103];
        [onlineBadge removeFromSuperview];
		
		icon = (UIImageView*)[cell.contentView viewWithTag:104];
    }
    
    cell.accessoryView.tag = indexPath.row;
    

    // chat cell
    if([item objectForKey: kMessageChatId]) {
        // set dialog title
		
		[icon setHidden:NO];
		
		dialogTitle.frame = CGRectMake(80, 5, 150, 25);
		dialogTitle.text = [[item objectForKey:kMessageTitle] stringByDecodingHTMLEntities];
        
        // users - opponents
        NSArray *listActiveUsersId = [[NSArray alloc] initWithArray: [[item objectForKey: kMessageChatActive] componentsSeparatedByString:@","]];
        
        // show picture
        UIView *chatPic = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        chatPic.tag = 102;
        
        // get 4 first
        int activeUserForIcons = listActiveUsersId.count > 4 ? 4 : listActiveUsersId.count;
        
        for (int i=0; i<activeUserForIcons; i++) {
            
            AsyncImageView *fPic = [[AsyncImageView alloc] init];
            [fPic setFrame:CGRectFromString( rects[activeUserForIcons - 1][i] )];
            
            if ((activeUserForIcons == 2) || (activeUserForIcons == 3 && i == 0)){
                [fPic setTypeCrop:AsyncImageCropLong];
            }
            
            NSString *userPicUrlString = [[[DataManager shared].messagesUsers objectForKey:[listActiveUsersId objectAtIndex:i]] objectForKey:kUserPhoto];  
            fPic.layer.masksToBounds = YES;
            fPic.tag = 101;
            fPic.layer.cornerRadius = 5;
            
            [fPic loadImageFromURL: [NSURL URLWithString: userPicUrlString]];
            
            [chatPic addSubview:fPic];
            [fPic release];
        }
        [listActiveUsersId release];
        [cell.contentView addSubview:chatPic];
        [chatPic release];
        
    // private dialog cell
    } else {

		[icon setHidden:YES];
		
        // user-oponent
        NSDictionary *user = [[DataManager shared].messagesUsers objectForKey: [[item objectForKey: kUserUid] description]];
        
        // title with first_name last_name
		dialogTitle.frame = CGRectMake(60, 5, 170, 25);
        dialogTitle.text = [NSString stringWithFormat:@"%@ %@", 
                            [user objectForKey: kUserFirstName], 
                            [user objectForKey: kUserLastName]
                            ]; 
        
        // photo dialog
        AsyncImageView *dialogPhoto = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        dialogPhoto.layer.masksToBounds = YES;
        dialogPhoto.tag = 102;
        dialogPhoto.layer.cornerRadius = 5;
        [dialogPhoto loadImageFromURL: [NSURL URLWithString:[user objectForKey: kUserPhoto]]];
        [cell.contentView addSubview:dialogPhoto];
        [dialogPhoto release];
        
        // online state
        if( [[user objectForKey:kUserOnline] boolValue]) {
            CGSize textSize = [[dialogTitle text] sizeWithFont:[dialogTitle font]];
            CGFloat strikeWidth = textSize.width + dialogTitle.frame.origin.x + 10;
            CGFloat strikeHeight = dialogTitle.frame.size.height/2 + dialogTitle.frame.origin.y;
            UIImageView *onlinePic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
            onlinePic.tag = 103;
            [onlinePic setImage:[UIImage imageNamed:@"Online.png"]];
            [onlinePic setCenter:CGPointMake(strikeWidth, strikeHeight)];
            [cell.contentView addSubview:onlinePic];
            [onlinePic release];
        }
    }
	
    // set last message
    NSString *messageText = [[item objectForKey:kMessageBody] stringByConvertingHTMLToPlainText];
    [lastMessage setText:[EncodeHelper urldecode:messageText]];
	
    
    // set datetime
	NSDate *time = [NSDate dateWithTimeIntervalSince1970:[[item objectForKey:kDate] integerValue]];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setLocale:[NSLocale currentLocale]];
	
	if ([time timeIntervalSinceNow] > -86400)
	{
		[dateFormat setDateFormat:@"HH:mm"];
		[date setText:[dateFormat stringFromDate:time]];
	} 
	else if (([time timeIntervalSinceNow] < -86400) && ([time timeIntervalSinceNow] > -172800))
	{
		[date setText:NSLocalizedString(@"Yesterday", nil)];
	}
	else if (([time timeIntervalSinceNow] < -172800) && ([time timeIntervalSinceNow] > -518400))
	{
		[dateFormat setDateFormat:@"eee"];
		[date setText:[dateFormat stringFromDate:time]];
	}
	else if (([time timeIntervalSinceNow] < -518400) && ([time timeIntervalSinceNow] > -604800))
	{
		[date setText:NSLocalizedString(@"Week ago", nil)];
	}
	else if ([time timeIntervalSinceNow] < -604800)
	{
		[dateFormat setDateFormat:@"d MMMM"];
		[date setText:[dateFormat stringFromDate:time]];
	}
    [date setFrame:CGRectMake(225, 7, 60, 20)];
	
	[dateFormat release];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // get item
    NSDictionary *item; 
    // searching
    if([[_searchBar text] length] > 0) {
        item = [searchArray objectAtIndex:indexPath.row];
    }else {
        item = [[DataManager shared].messagesDialogs objectAtIndex:indexPath.row];
    }

    
    // set read state
    if ([[item objectForKey:kMessageReadState] intValue] == 0 && [[item objectForKey:kMessageOut] intValue] == 0 && [[[DataManager shared].currentUserBody objectForKey:kUid] intValue] != [[item objectForKey:kMessageFromUid] intValue]) {
        [cell setBackgroundColor:[UIColor colorWithHexString:@"ebf0f5"]];        
    } else {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [self setTitle:NSLocalizedString(@"Back", nil)];

    // get item
    NSMutableDictionary *item; 
    // searching
    if([[_searchBar text] length] > 0) {
        item = [searchArray objectAtIndex:indexPath.row];
    }else {
        item = [[DataManager shared].messagesDialogs objectAtIndex:indexPath.row];
    }
    
    // mark as read
    if ([[item objectForKey:kMessageReadState] intValue] == 0 && [[item objectForKey:kMessageOut] intValue] == 0 && [[[DataManager shared].currentUserBody objectForKey:kUid] intValue] != [[item objectForKey:kMessageFromUid] intValue]) {
        [item setObject:[NSNumber numberWithInt:1] forKey:kMessageReadState];
    }
    
    
    // set user if this is private room
    NSDictionary *user = nil;
    if(![item objectForKey: kMessageChatId]) {
        user = [[DataManager shared].messagesUsers objectForKey: [[item objectForKey: kUserUid] description]];
    }
    
    // show message controller
    MessageViewController *detailViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    [detailViewController setDialog:item];
    [detailViewController setUserOpponent:user];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark -
#pragma mark UISearchBarDelegate

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    // show back view
    if(backView == nil){
        backView = [[ViewTouch alloc] initWithFrame:CGRectMake(0, 45, 320, 175) selector:@selector(touchOnView:) target:self];
        [self.view addSubview:backView];
        [backView release];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [backView removeFromSuperview];
    backView = nil;
}

- (void)touchOnView:(UIView *)view{
    [_searchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    [theSearchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
	//Remove all objects first.
	[searchArray removeAllObjects];
	
	if([searchText length] > 0) {
        // search dialogs
        
        NSString *searchText = _searchBar.text;
        for (NSDictionary *dialog in [DataManager shared].messagesDialogs){
            
            // search environment
            NSString *pattern;
            if([dialog objectForKey: kMessageChatId]) {
                pattern = [[dialog objectForKey:kMessageTitle] stringByDecodingHTMLEntities];
            }else{
                // user-oponent
                NSDictionary *user = [[DataManager shared].messagesUsers objectForKey: [[dialog objectForKey: kUserUid] description]];
                pattern = [NSString stringWithFormat:@"%@ %@", [user objectForKey: kUserFirstName], 
                                                                [user objectForKey: kUserLastName]]; 
            }
            
            NSRange titleResultsRange = [pattern rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResultsRange.length > 0) {
                [searchArray addObject:dialog];
            }
        }
	}
    
   
    
	[self.tableView reloadData];
}



#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{\
    // Delete dialog
    if(buttonIndex == 1){
        // get item
        NSDictionary *item; 
        // searching
        if([[_searchBar text] length] > 0) {
            item = [searchArray objectAtIndex:alertView.tag];
        }else {
            item = [[DataManager shared].messagesDialogs objectAtIndex:alertView.tag];
        }
        
        // delete dialog
        int chatId = [[item objectForKey:kMessageChatId] intValue];
        if(chatId > 0){
            [VKService deleteDialogWithUser:0 orChat:chatId withDelegate:self];
        }else{
            int uid = [[item objectForKey:kUid] intValue];
            [VKService deleteDialogWithUser:uid orChat:0 withDelegate:self];
        }
        
        // clear table
        if([[_searchBar text] length] > 0) {
            [searchArray removeObjectIdenticalTo:item];
        }else{
            [[DataManager shared].messagesDialogs removeObjectIdenticalTo:item];
        }
        NSIndexPath *path = [NSIndexPath indexPathForRow:alertView.tag inSection:0];
        NSArray *paths = [NSArray arrayWithObject:path];
        [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark  
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self == viewController){
        [self.tableView reloadData];
    }
}


#pragma mark  
#pragma mark VKServiceResultDelegate

- (void) completedWithVKResult:(VKServiceResult *)result {
    switch (result.queryType) {
            
        // get dialogs result
        case VKQueriesTyperMessagesGetDialogs:
            if(result.success){
                // update table
                [self updateDialogs:[result.body objectForKey:kResponse]];
                
                [activityIndicator stopAnimating];
            }
            break;
          
        // delete dialog
        case VKQueriesTypesMessagesDeleteDialog:
            
            break;

        default:
            break;
    }
}

@end
