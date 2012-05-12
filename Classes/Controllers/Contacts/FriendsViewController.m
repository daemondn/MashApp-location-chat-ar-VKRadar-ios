//
//  FriendsViewController.m
//  Vkmsg
//
//  Created by Igor Khomenko on 3/28/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import "FriendsViewController.h"
#import "EditConversationViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

@synthesize searchField = _searchField;
@synthesize tableView = _tableView;
@synthesize openedFromFavoritesController = _openedFromFavoritesController;
@synthesize openedFromMessagesController = _openedFromMessagesController;
@synthesize openedFromEditConversationController = _openedFromEditConversationController;
@synthesize addSelectedContainer = _addSelectedContainer;
@synthesize activityIndicator = _activityIndicator;
@synthesize parentController = _parentController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self == nil){
        return nil;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(_openedFromFavoritesController){
        self.title = NSLocalizedString(@"Friends", nil);
        
        [_searchField setFrame:CGRectMake(0, 0, 320, 44)];
        [_tableView setFrame:CGRectMake(0, 44, 320, 365)];
        [_addSelectedContainer setImage:[UIImage imageFromResource:@"Background.png"]];
        [_addSelectedContainer setHidden:NO];
        // shadow
        UIImageView *bottomShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 6)];
        [bottomShadow setImage:[UIImage imageFromResource:@"bottomShadow.png"]];
        [_addSelectedContainer addSubview:bottomShadow];
        [bottomShadow release];
        
    }else if(_openedFromMessagesController || _openedFromEditConversationController){
        self.title = NSLocalizedString(@"Friends", nil);

        [_searchField setFrame:CGRectMake(0, 0, 320, 44)];
        [_tableView setFrame:CGRectMake(0, 44, 320, 436)];
        [_addSelectedContainer setHidden:YES];
        
    // openet from tab (main way)
    }else{
        [_searchField setFrame:CGRectMake(0, 0, 320, 44)];
        [_tableView setFrame:CGRectMake(0, 44, 320, 362)];
        [_addSelectedContainer setHidden:YES];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFriendsWasAdded) name:kNotificationNewFriendWasAdded object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutDone) name:kNotificationLogout object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // show friends
    if(friends == nil){
        friends = [[NSMutableArray alloc] init];
        sections = [[NSMutableDictionary alloc] init];
        searchArray = [[NSMutableArray alloc] init];
        
        [_tableView reloadData];
        
        // get friends
        if([DataManager shared].myFriends == nil){
            [_activityIndicator startAnimating];
            [VKService friendsGet:[DataManager shared].currentUserId delegate:self];
        }else{
            // show friends in table
            [self showFriends:[DataManager shared].myFriends];
        }
    }
}

- (void)viewDidUnload
{
	self.searchField = nil;
	self.tableView = nil;
	self.addSelectedContainer = nil;
	self.activityIndicator = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLogout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNewFriendWasAdded object:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [friends release];
    [sections release];
    [searchArray release];
    
    [selectedFriendsPathes release];
    [friendsToAddToFavorities release];
    
    [super dealloc];
}

- (void) setOpenedFromFavoritesController:(BOOL)openedFromFavoritesController{
    _openedFromFavoritesController = openedFromFavoritesController;
    if(_openedFromFavoritesController){
        selectedFriendsPathes = [[NSMutableArray alloc] init];
        friendsToAddToFavorities = [[NSMutableArray alloc] init];
    }
}

// logout
- (void)logoutDone{
    [friends release];
    friends = nil;
    [sections release];
    sections = nil;
    [searchArray release];
    searchArray = nil;
}

// new friends was added notification
- (void)newFriendsWasAdded{
    // refresh friends
    [VKService friendsGet:[DataManager shared].currentUserId delegate:self];
}

// Add friends to favorities action
- (IBAction)addSelectedButtonDidPress:(id)sender{
    if([friendsToAddToFavorities count] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VK", nil) 
                                                        message:NSLocalizedString(@"Please select at least one friend", nil)    
                                                       delegate:nil 
                                              cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];

        return;
    }
    
    // add to favorities
    [[DataManager shared] addFavoriteFriends:friendsToAddToFavorities];
    [self.navigationController popViewControllerAnimated:YES];
}

// show friends
- (void)showFriends:(NSArray *)friendsList  {
    
    // we dont have any friends
    if([friendsList count] == 0){
        [_activityIndicator stopAnimating];
        return;
    }
    
    
    // refresh friends
    [friends removeAllObjects];
    [sections removeAllObjects];
    [searchArray removeAllObjects];
    //
    [friends addObjectsFromArray:friendsList];
    
    
    // Loop through the books and create our keys
    for (NSDictionary *dict in friends)
	{      
		NSString *utfFirstName = [NSString stringWithUTF8String:[[dict objectForKey:kUserFirstName] UTF8String]];
        NSString *c = [utfFirstName substringToIndex:1];
		   
		[sections setValue:[[[NSMutableArray alloc] init] autorelease] forKey:c];
    }
   
    // add friends
    for (NSDictionary *dict in friends){
        [[sections objectForKey:[[dict objectForKey:kUserFirstName] substringToIndex:1]] addObject:dict];
    }  
    
    
    // Sort each section
    for (NSString *key in [sections allKeys]){
        [[sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:kUserFirstName ascending:YES]]];
    } 
    
    // add important friends
    int maxImportantFriendsRange = 5;
    if(maxImportantFriendsRange > [friends count]){
        maxImportantFriendsRange = [friends count];
    }
    NSIndexSet *importantFriendsIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, maxImportantFriendsRange)];
    NSMutableArray *importantFriends = [NSMutableArray arrayWithCapacity:5];
    [importantFriends addObjectsFromArray:[friendsList objectsAtIndexes:importantFriendsIndexes]];
    [sections setObject:importantFriends forKey:NSLocalizedString(@"Important", nil)];
    
    
    //
    // add to favorities
    if(!_openedFromFavoritesController){
        [[DataManager shared] addFavoriteFriends:importantFriends];
    }
    
    
    // reload table
    [_tableView reloadData];
    
    [_activityIndicator stopAnimating];
}


#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // searching
    if ([[_searchField text] length] > 0){
		return 1;
    }
    
	return [[sections allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{    
    if([[_searchField text] length] > 0){
		return NSLocalizedString(@"Search Results", nil);
    }

    // sort array & move 'Important' to 1st position
    NSMutableArray *headers = [[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy] autorelease];
    [headers exchangeObjectAtIndex:[headers indexOfObject:NSLocalizedString(@"Important", nil)] withObjectAtIndex:0];
    
    return [headers objectAtIndex:section];
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[_searchField text] length] > 0){
		return [searchArray count];
	}
    
    // sort array & move 'Important' to 1st position
    NSMutableArray *headers = [[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy] autorelease];
    [headers exchangeObjectAtIndex:[headers indexOfObject:NSLocalizedString(@"Important", nil)] withObjectAtIndex:0];
    
    return [[sections valueForKey:[headers objectAtIndex:section]] count];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *uniqueIdentifier = @"FriendsCell";
    
    FriendsTableViewCell  *cell = (FriendsTableViewCell *) [_tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if(!cell){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FriendsTableViewCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects){
            if([currentObject isKindOfClass:[FriendsTableViewCell class]]){
                cell = (FriendsTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    NSDictionary *dict;
    // searching
    if([[_searchField text] length] > 0) {
		dict = [searchArray objectAtIndex:indexPath.row];
 	
    }else {
        // sort array & move 'Important' to 1st position
        NSMutableArray *headers = [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
        [headers exchangeObjectAtIndex:[headers indexOfObject:NSLocalizedString(@"Important", nil)] withObjectAtIndex:0];
        
        dict = [[sections valueForKey:[headers objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        [headers release];
	}
	
	cell.userName.text = [NSString stringWithFormat: @"%@ %@",[dict objectForKey:kUserFirstName],[dict objectForKey:kUserLastName]];
	[cell setAvatarURL:[NSURL URLWithString:[dict objectForKey:kUserPhoto]]];
	 
    
    if(!_openedFromFavoritesController){
        cell.online.hidden = ![[dict objectForKey:kUserOnline] intValue]?YES:NO;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}  

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *user = nil;
	
    // searching
	if([[_searchField text] length] > 0){
		user = [searchArray objectAtIndex:indexPath.row];
        
    }else  { 
        // sort array & move 'Important' to 1st position
        NSMutableArray *headers = [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
        [headers exchangeObjectAtIndex:[headers indexOfObject:NSLocalizedString(@"Important", nil)] withObjectAtIndex:0];
        
        user = [[sections valueForKey:[headers objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        [headers release];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // multiple selection
    if(_openedFromFavoritesController){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [selectedFriendsPathes removeObject:indexPath];
            [friendsToAddToFavorities removeObject:user];
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [selectedFriendsPathes addObject:indexPath];
            [friendsToAddToFavorities addObject:user];
        }
    }else if (_openedFromMessagesController){
        [self.navigationController popViewControllerAnimated:NO]; // remove friends view controller
        
        // Start Dialog with friend
        messagesViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
        messagesViewController.isNewConversation = YES;
        [messagesViewController setUserOpponent:user];
        [self.parentController.navigationController pushViewController:messagesViewController animated:YES];
        [messagesViewController release];
        
    }else if(_openedFromEditConversationController){
        // add Friend to conversation
        ((EditConversationViewController *)_parentController).friendToAdd = user;
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        // Start Dialog with friend
        messagesViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
        messagesViewController.isNewConversation = YES;
        [messagesViewController setUserOpponent:user];
        [self.parentController.navigationController pushViewController:messagesViewController animated:YES];
        [messagesViewController release];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([selectedFriendsPathes containsObject:indexPath]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
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
    [_searchField resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    [theSearchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
	//Remove all objects first.
	[searchArray removeAllObjects];
	
	if([searchText length] > 0) {
        // search friends
		[self searchTableView];
	}
    
	[_tableView reloadData];
}

- (void) searchTableView {
	
	NSString *searchText = _searchField.text;
	
	for (NSDictionary *dict in friends){
        NSMutableArray *patterns = [[NSMutableArray alloc] init];
		[patterns addObject:[dict objectForKey:kUserFirstName]];
		[patterns addObject:[dict objectForKey:kUserLastName]];
        
        for (NSString *sTemp in patterns){
            NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (titleResultsRange.length > 0) {
                [searchArray addObject:dict];
                break;
            }    
        }
        
        [patterns release];
	}
}


#pragma mark -
#pragma mark VKServiceResultDelegate

- (void)completedWithVKResult:(VKServiceResult *)result {
    switch (result.queryType) {
        // get friends result
        case VKQueriesTypesFriendsGet:
            if(result.success){
                
                // save friends
                [DataManager shared].myFriends = [result.body objectForKey:kResponse];

                // show friends in table
                [self showFriends:[result.body objectForKey:kResponse]];
            }
            break;
            
        default:
            break;
    }
}

@end
