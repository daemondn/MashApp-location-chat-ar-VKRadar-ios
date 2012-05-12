//
//  FriendRequestsViewController.m
//  Vkmsg
//
//  Created by Igor Khomenko on 3/28/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//
#define kUserApproved @"kUserApproved"

#import "FriendRequestsViewController.h"

@interface FriendRequestsViewController ()

@end

@implementation FriendRequestsViewController

@synthesize tableView = _tableView;
@synthesize requestsUsers;
@synthesize suggestUsers;
@synthesize activityIndicator;


- (void)dealloc
{
    [requestsUsers release];
    [suggestUsers release];
    
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
    if(self == nil){
        return nil;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutDone) name:kNotificationLogout object:nil];
}

- (void)viewDidUnload
{
    self.tableView = nil;
	
	self.requestsUsers = nil;
	self.suggestUsers = nil;
    self.activityIndicator = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLogout object:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(requestsUsers == nil){
        
        requestsUsers = [[NSMutableArray alloc] init];
        suggestUsers = [[NSMutableArray alloc] init];
        
        [_tableView reloadData];
        
        // get Requests
        [VKService friendsGetRequestsWithDelegate:self];
        
        // Suggestions
        [VKService friendsGetSuggestionsWithFilter:nil delegate:self];
        
        [activityIndicator startAnimating];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// logout
- (void)logoutDone{
    [requestsUsers release];
    requestsUsers = nil;
    [suggestUsers release];
    suggestUsers = nil;
}

// add to friend
- (void)addFriend:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[((UIButton *)sender) superview] superview];
    
    NSUInteger section = cell.tag;
    NSUInteger row = ((UIButton *)sender).tag;
    
    NSMutableDictionary *user = nil;
    
    // get user & mark as approved
    if(section == 0 && [requestsUsers count] > 0){
        user = [[requestsUsers objectAtIndex:row] mutableCopy];
        [user setObject:[NSNumber numberWithBool:YES] forKey:kUserApproved];
        [requestsUsers replaceObjectAtIndex:row withObject:user];
    }else{
        user = [[suggestUsers objectAtIndex:row] mutableCopy];
        [user setObject:[NSNumber numberWithBool:YES] forKey:kUserApproved];
        [suggestUsers replaceObjectAtIndex:row withObject:user];
    }
    
    // get uid
    int uid = [[user objectForKey:kUid] intValue];
    
    // change button
    ((UIButton *)sender).enabled = NO;
    
    // remove from table
    NSNumber *uidNumber = [NSNumber numberWithInt:uid];
    
    // accept friend
    [VKService friendsAdd:[NSString stringWithFormat:@"%@", uidNumber] delegate:self];
    
    // reload table
    [_tableView reloadData];
    
    [user release];
}


#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([requestsUsers count] > 0 && [suggestUsers count] > 0){
        if (section == 1){
            return [suggestUsers count];
        }else {
            return [requestsUsers count];
        }
    }else if ([requestsUsers count] > 0){
        return [requestsUsers count];
    }else if ([suggestUsers count] > 0){
        return [suggestUsers count];
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([requestsUsers count] > 0 && [suggestUsers count] > 0){
        switch (section) {
            case 0:
                return NSLocalizedString(@"Friends requests", nil);
            case 1:
                return NSLocalizedString(@"Friends suggestions", nil);
            default:
                return NSLocalizedString(@"", nil);
        }
    }else if ([requestsUsers count] > 0){
        return NSLocalizedString(@"Friends requests", nil);
    }else if ([suggestUsers count] > 0){
        return NSLocalizedString(@"Friends suggestions", nil);
    }else{
        return NSLocalizedString(@"", nil);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([requestsUsers count] > 0 && [suggestUsers count] > 0){
        return 2;
    }else if ([requestsUsers count] > 0 || [suggestUsers count] > 0){
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *uniqueIdentifier = @"RequestsFriendsCell";
    
    // create cell
    FriendsRequestsTableViewCell  *cell = (FriendsRequestsTableViewCell *) [_tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if(!cell){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FriendsRequestsTableViewCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects){
            if([currentObject isKindOfClass:[FriendsRequestsTableViewCell class]]) {
                cell = (FriendsRequestsTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    // 2 sections
    if([requestsUsers count] > 0 && [suggestUsers count] > 0){
        // requests section
        if (indexPath.section == 0){
            NSMutableDictionary *requestedUser = [requestsUsers objectAtIndex:[indexPath row]];
                
            // setup cell
            [self setupCell:cell forUser:requestedUser withIndexPath:indexPath];
            
        // Suggestions sections
        }else {
            NSDictionary *suggestedUser = [suggestUsers objectAtIndex:[indexPath row]];
                // setup cell
            [self setupCell:cell forUser:suggestedUser withIndexPath:indexPath];
            
        }
    }else if ([requestsUsers count] > 0){
        NSMutableDictionary *requestedUser = [requestsUsers objectAtIndex:[indexPath row]];
        
        // setup cell
        [self setupCell:cell forUser:requestedUser withIndexPath:indexPath];
    }else if ([suggestUsers count] > 0){
        NSDictionary *suggestedUser = [suggestUsers objectAtIndex:[indexPath row]];
        
        // setup cell
        [self setupCell:cell forUser:suggestedUser withIndexPath:indexPath];
    }

    return cell;
}

- (void) setupCell:(FriendsRequestsTableViewCell *)cell forUser:(NSDictionary *)user withIndexPath:(NSIndexPath *)indexPath{
    // set photo
    NSURL *avatarURL = [NSURL URLWithString:[user objectForKey:kPhoto]];
    [cell setAvatarURL:avatarURL];
    
    NSNumber *approved = [user objectForKey:kUserApproved];
    
    // set names
    NSString* firstName = [user objectForKey:kUserFirstName];
    NSString* lastName = [user objectForKey:kUserLastName];
    cell.userName.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    
    
    // save section
    cell.tag = indexPath.section;
    
    // setup add button
    if(indexPath.section == 0 && [requestsUsers count] > 0 && (approved == nil || [approved boolValue] == NO)){
        [cell.addButton setFrame:CGRectMake(246, 17, 26, 26)];
    }else{
        [cell.addButton setFrame:CGRectMake(280, 17, 26, 26)];
    }
    
    
    cell.addButton.tag = [indexPath row];;
    if(approved == nil || [approved boolValue] == NO){
        cell.addButton.enabled = YES;
        [cell.addButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.addButton.enabled = NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        // delete from friends
        NSString *uid = [NSString stringWithFormat:@"%@", [[requestsUsers objectAtIndex:[indexPath row]] objectForKey:kUid]];
        [VKService friendsDelete:uid  delegate:self];
        
        
        // update table
        [requestsUsers removeObjectAtIndex:[indexPath row]];
        if([requestsUsers count] == 0){
            [tableView reloadData];
        }else{
            [tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath]
						 withRowAnimation: UITableViewRowAnimationFade];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(([requestsUsers count] > 0 && [suggestUsers count] > 0) || [requestsUsers count] > 0){
        if(indexPath.section == 0){
            NSMutableDictionary *requestedUser = [requestsUsers objectAtIndex:[indexPath row]];
            NSNumber *approved = [requestedUser objectForKey:kUserApproved];
            if(approved == nil || [approved boolValue] == NO){
                return YES;
            }
        }
    }
    
    return NO;
}


#pragma mark -
#pragma mark VKServiceResultDelegate

- (void)completedWithVKResult:(VKServiceResult *)result{

    switch (result.queryType) {
            
        // get Requests result
        case VKQueriesTypesFriendsGetRequests:
            if (result.success){
                id response = [result.body objectForKey:kResponse];
                // check for empty
                if([response isKindOfClass:[NSArray class]]){
                    [requestsUsers addObjectsFromArray:response];
                    [_tableView reloadData];
                }
            }
            break;
        
        // get Suggestions result
        case VKQueriesTypesFriendsGetSuggestions:
            if (result.success){
                id response = [result.body objectForKey:kResponse];
                // check for empty
                if([response isKindOfClass:[NSArray class]]){
                    [suggestUsers addObjectsFromArray:response];  
                    [_tableView setEditing:YES animated:NO];
                    [_tableView reloadData];
                    
                    [activityIndicator stopAnimating];
                }
            }
            break;
        
        // add to friends result
        case VKQueriesTypesFriendsAdd:
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewFriendWasAdded object:nil];
            break;

        // delete from friends result
        case VKQueriesTypesFriendsDelete:
            break;
            
        default:
            break;
    }
}

@end
