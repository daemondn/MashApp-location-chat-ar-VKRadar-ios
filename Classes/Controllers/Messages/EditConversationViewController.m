//
//  EditConversationViewController.m
//  Vkmsg
//
//  Created by Igor Khomenko on 4/12/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import "EditConversationViewController.h"
#import "FriendsViewController.h"

@interface EditConversationViewController ()

@end

@implementation EditConversationViewController

@synthesize usersTableView, chatID;
@synthesize friendToAdd;
@synthesize messagesViewController;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [chatUsers release];
    [friendToAdd release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"Participants", nil);
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonDidPress)]; 
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
    
    // get chat users
    [VKService messagesGetChatUsers:chatID delegate:self];
    [activityIndicator startAnimating];
}

- (void)viewDidUnload
{
    self.usersTableView = nil;
    self.activityIndicator = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(chatUsers){
        messagesViewController.countOfUserLabel.text = [NSString stringWithFormat:@"%i", [chatUsers count]];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // add friend to conversation
    if(friendToAdd){
        [chatUsers addObject:friendToAdd];
        [usersTableView reloadData];
        
        // add chat user
        [VKService messagesAddChatUser:chatID user:[[friendToAdd objectForKey:kUid] intValue] delegate:self];
    }
}

// Edit conversation
- (void)editButtonDidPress{
    
    [usersTableView setEditing:YES animated:YES];
    
    // setup navbars
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonDidPress)]; 
    self.navigationItem.leftBarButtonItem = addButton;
    [addButton release];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidPress)]; 
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
}

// Add people to conversation
- (void)addButtonDidPress{
    // show friends
    FriendsViewController *friendsViewController = [[FriendsViewController alloc] init];
    friendsViewController.parentController = self;
    friendsViewController.openedFromEditConversationController = YES;
    [self.navigationController pushViewController:friendsViewController animated:YES];
    [friendsViewController release];
}

// Add people to conversation
- (void)doneButtonDidPress{
    [usersTableView setEditing:NO animated:YES];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonDidPress)]; 
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
    
}


#pragma mark -
#pragma mark UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [chatUsers count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseIdentifier = @"editconversationFriendsCell";
    
    NSDictionary *user = [chatUsers objectAtIndex:[indexPath row]];
    
    // create cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    // set friend name
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [user objectForKey:kUserFirstName], [user objectForKey:kUserLastName]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // remove user from chat
    if (editingStyle == UITableViewCellEditingStyleDelete){
        NSDictionary *user = [chatUsers objectAtIndex:[indexPath row]];
        
        // remove user
        [VKService messagesRemoveChatUser:chatID user:[[user objectForKey:kUid] intValue] delegate:self];
        
        [chatUsers removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath]
						 withRowAnimation: UITableViewRowAnimationFade];
    }
}


#pragma mark -
#pragma mark VKServiceResultDelegate

-(void)completedWithVKResult:(VKServiceResult *)result{
    switch (result.queryType) {
            
        // get chat users result
        case VKQueriesTypesMessagesGetChatUsers:
            if(result.success){
                chatUsers = [[result.body objectForKey:kResponse] mutableCopy];
                [usersTableView reloadData];
                
                [activityIndicator stopAnimating];
            }
            break;
        
        // add user to chat result
        case VKQueriesTypesMessagesAddChatUser:
            break;
            
        // remove user from chat result
        case VKQueriesTypesMessagesRemoveChatUser:
            break;
            
        default:
            break;
    }
}


@end
