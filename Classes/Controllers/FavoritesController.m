//
//  FavoritesController.m
//  Vkmsg
//
//  Created by md314 on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define cellHeight 48.0

#import "FavoritesController.h"
#import "ContactsController.h"
#import "FriendsViewController.h"

@interface FavoritesController ()

@end

@implementation FavoritesController

@synthesize favoritiesTableView = _favoritiesTableView;
@synthesize inviteFriendsContainer = _inviteFriendsContainer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [favoritiesFriends release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_inviteFriendsContainer setImage:[UIImage imageFromResource:@"BackgroundPart.png"]];

    // shadow
    UIImageView *bottomShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 6)];
    [bottomShadow setImage:[UIImage imageFromResource:@"bottomShadow.png"]];
    [_inviteFriendsContainer addSubview:bottomShadow];
    [bottomShadow release];
    
    // setup navbars
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonDidPress:)]; 
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
}

- (void)viewDidUnload
{
    self.favoritiesTableView = nil;
    self.inviteFriendsContainer = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // get favorities friends
    favoritiesFriends = [[[DataManager shared] favoritiesFriends] mutableCopy];
    [_favoritiesTableView reloadData];
    
    // set table frame
    int tableHeight = cellHeight * [favoritiesFriends count];
    CGRect tableFrame = _favoritiesTableView.frame;
    if(tableHeight > 240){
        tableFrame.size.height = 240;
    }else{
        tableFrame.size.height = tableHeight;
        _favoritiesTableView.showsVerticalScrollIndicator = NO;
    }
    [_favoritiesTableView setFrame:tableFrame];
    
    // set ivites frame controller
    [_inviteFriendsContainer setFrame:CGRectMake(0, tableFrame.origin.y+tableFrame.size.height, 320, 415-tableFrame.size.height)];
    
    
    
    
    if(_favoritiesTableView.editing){
        return;
    }
    
    //show/hide Edit button
    if([favoritiesFriends count] > 0){
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonDidPress:)]; 
        self.navigationItem.leftBarButtonItem = editButton;
        [editButton release];
    }else{
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_favoritiesTableView flashScrollIndicators];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)inviteFriendButtonDidPress :(id)sender{
    ContactsController *contactViewController = (ContactsController *)[[[self.tabBarController viewControllers] objectAtIndex:3] topViewController];
    
    // show local contacts
    [contactViewController.segmentControl setSelectedSegmentIndex:0];
    [contactViewController segmentChange:contactViewController.segmentControl];
    [contactViewController.localContactsController.view setFrame:CGRectMake(0, 0, 320, 480)];
    
    [[self tabBarController] setSelectedIndex:3];
}

- (void)editButtonDidPress :(id)sender{
    
    if([_favoritiesTableView isEditing]){
        [_favoritiesTableView setEditing:NO animated:YES]; 
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonDidPress:)]; 
        self.navigationItem.rightBarButtonItem = addButton;
        [addButton release];
    
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonDidPress:)]; 
        self.navigationItem.leftBarButtonItem = editButton;
        [editButton release];
        
        // refresh defaults
        [[DataManager shared] removeAllFavoritiesFriends];
        if([favoritiesFriends count] > 0){
            [[DataManager shared] addFavoriteFriends:favoritiesFriends];
        }
        
    }else{
        [_favoritiesTableView setEditing:YES animated:YES];
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editButtonDidPress:)]; 
        self.navigationItem.leftBarButtonItem = editButton;
        [editButton release];
        
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)addButtonDidPress :(id)sender{
    
    // show friends
    FriendsViewController *friendsViewController = [[FriendsViewController alloc] init];
    friendsViewController.tableView.allowsMultipleSelection = YES;
    friendsViewController.openedFromFavoritesController = YES;
    [self.navigationController pushViewController:friendsViewController animated:YES];
    [friendsViewController release];
}

// Start dialog with friend
- (void)startDialogWithFriend:(NSDictionary *)friend{
    
    // Start Dialog with friend
    MessageViewController *messagesViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    [messagesViewController setUserOpponent:friend];
    messagesViewController.isNewConversation = YES;
    [self.navigationController pushViewController:messagesViewController animated:YES];
    [messagesViewController release];
}


#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [favoritiesFriends count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseIdentifier = @"favoritiesFriendsCell";
    
    // create cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    // set friend name
    cell.textLabel.text = [[favoritiesFriends objectAtIndex:[indexPath row]] objectForKey:kUserFirstName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *selectedUser = [favoritiesFriends objectAtIndex:[indexPath row]];
    
    // Start Dialog with friend
    [self startDialogWithFriend:selectedUser];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *selectedUser = [favoritiesFriends objectAtIndex:[indexPath row]];
    
    // Start Dialog with friend
    [self startDialogWithFriend:selectedUser];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    
    [favoritiesFriends exchangeObjectAtIndex:[fromIndexPath row] withObjectAtIndex:[toIndexPath row]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [favoritiesFriends removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath]
						 withRowAnimation: UITableViewRowAnimationFade];
    }
}

@end
