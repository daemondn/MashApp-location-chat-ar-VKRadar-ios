//
//  LocalContactsViewController.m
//  Vkmsg
//
//  Created by Igor Khomenko on 3/28/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#define kPersonFirstName @"kFirstName"
#define kPersonSecondName @"kSecondName"
#define kPersonPhones @"kPhones"
#define kPersonPhoto @"kPhoto"
#define kPersoneIsInVK @"kPersoneIsInVK"
#define kPersoneVK @"kPersoneVK"

#import "LocalContactsViewController.h"

@interface LocalContactsViewController ()

@end

@implementation LocalContactsViewController

@synthesize searchField = _searchField;
@synthesize tableView = _tableView;
@synthesize contactDetailsController = _contactDetailsController;
@synthesize parentController = _parentController;
@synthesize activityIndicator = _activityIndicator;

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
	[self.view setFrame:CGRectMake(0, 45, 320, 415)];

    // all people
    people = [[NSMutableArray alloc] init];
    
    // all phones
    phonesDictionary = [[NSMutableDictionary alloc] init];
    
    // search array
    searchArray = [[NSMutableArray alloc] init];
    
	// array contains names' first leters
    sections = [[NSMutableDictionary alloc] init];
    
    // create adrres book ref
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    // get all people
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    // get people count
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
	// get info for all people in address book
    for (int i = 0; i < nPeople; i++) {
        // person
        ABRecordRef rowPerson = CFArrayGetValueAtIndex(allPeople, i);
        
        NSMutableDictionary *person = [[NSMutableDictionary alloc] init];
        
        // set person's names
        NSString *firstName = (NSString *)ABRecordCopyValue(rowPerson, kABPersonFirstNameProperty);
        NSString *secondName = (NSString *)ABRecordCopyValue(rowPerson, kABPersonLastNameProperty);
        if(firstName){
            [person setObject:firstName forKey:kPersonFirstName];
        }
        if(secondName){
            [person setObject:secondName forKey:kPersonSecondName];
        }
        
        // is in VK
        [person setObject:[NSNumber numberWithBool:NO] forKey:kPersoneIsInVK];
        
        // set Phones
        ABMutableMultiValueRef phonelist = ABRecordCopyValue(rowPerson, kABPersonPhoneProperty);
        
        // get all person's phones
        CFIndex numPhones = ABMultiValueGetCount(phonelist);
        NSMutableArray  *phones = [[NSMutableArray alloc] init];
        for (int j=0; j < numPhones; j++) {
            CFTypeRef ABphone = ABMultiValueCopyValueAtIndex(phonelist, j);
            NSString *personPhone = (NSString *)ABphone;
            if ([personPhone length]){
                [phones addObject:personPhone];
                
                // add to phones dictionary
                [phonesDictionary setObject:person forKey:personPhone];
            }
            CFRelease(ABphone);
        }
        // set person's phone
        [person setObject:phones forKey:kPersonPhones];
        [phones release];
        
        
        // set user's photo
        CFDataRef imageData = ABPersonCopyImageData(rowPerson);
        UIImage *photo = [UIImage imageWithData:(NSData *)imageData];
        if(imageData != NULL){
            CFRelease(imageData);
        }
        if (photo == nil){
            photo = [UIImage imageNamed:@"DockContacts.png"];
        }
        [person setObject:photo forKey:kPhoto];
        
        CFRelease(phonelist);
        if(firstName != NULL){
            CFRelease(firstName);
        }
        if(secondName != NULL){
            CFRelease(secondName);
        }
        
        // add person to array
        if(firstName){
            [people addObject:person];
        }
        [person release];
        
        // add person to sections        
        if(firstName){
            NSString *firstLetter = [firstName substringToIndex:1];   
            NSMutableArray *peopleByLetter = [sections objectForKey:firstLetter];
            if(peopleByLetter == nil){
                peopleByLetter = [[NSMutableArray alloc] init];
                [sections setObject:peopleByLetter forKey:firstLetter];
                [peopleByLetter release];
            }
            [peopleByLetter addObject:person];
        }
    }
    
    // Sort each section array
    for (NSString *key in [sections allKeys]){
        [[sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:kPersonFirstName ascending:YES]]];
    } 
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
    
    CFRelease(addressBook);
    CFRelease(allPeople);
    
    return self;
}

- (void)dealloc
{
    [searchArray release];
    [people release];
    [sections release];
    [phonesDictionary release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _contactDetailsController.view.alpha = 1; // load view
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutDone) name:kNotificationLogout object:nil];
}

- (void)viewDidUnload
{
    self.searchField = nil;
    self.tableView = nil;
    
    self.contactDetailsController = nil;
    self.activityIndicator = nil;
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLogout object:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // get friends by phone
#if !(TARGET_IPHONE_SIMULATOR)
    if(!friendsByPhonesInitialized){
        friendsByPhonesInitialized = YES;
        
        NSTimeInterval currentTime = CFAbsoluteTimeGetCurrent();
        if(currentTime - [[DataManager shared] lastTimeGetFriendsByPhones] > 300.0){
            [VKService friendsGetByPhones:[phonesDictionary allKeys] delegate:self];
        }else{
            NSArray *friendsByPhones = [[DataManager shared] friendsByPhones];
            
            // check
            [self checkFriendsByPhones:friendsByPhones];
        }
    }
#endif
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// logout
- (void)logoutDone{
    friendsByPhonesInitialized = NO;
}

// check friends by phones
- (void)checkFriendsByPhones:(NSArray *)friendsByPhones{
    
    BOOL isFound = NO;
    for(NSDictionary *friend in friendsByPhones){
        NSString *phone = [NSString stringWithFormat:@"%@",[friend objectForKey:kPhone]];
        if([[phone substringToIndex:1] isEqualToString:@" "]){
            NSMutableString *mutablePhone = [phone mutableCopy];
            [mutablePhone replaceCharactersInRange:NSMakeRange(0, 1) withString:@"+"];
            phone = [mutablePhone autorelease];
        }
        
        // find person
        NSMutableDictionary *person = [phonesDictionary objectForKey:phone];
        if(person != nil){
            isFound = YES;
            
            // person found - set uid
            [person setObject:[NSNumber numberWithBool:YES] forKey:kPersoneIsInVK];
            [person setObject:friend forKey:kPersoneVK];                         
        }
    }
    
    // refresh table
    if(isFound){
        [_tableView reloadData];
    }
}


#pragma mark -
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // get person
    NSDictionary *person = nil;
    if ([[_searchField text] length] > 0){
        person = [searchArray objectAtIndex:indexPath.row];

    }else{
        person = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] 
                  objectAtIndex:indexPath.row];
    }
    
    
    // set person in VK or NOT
    BOOL isPersonInVK = [[person objectForKey:kPersoneIsInVK] boolValue];
    _contactDetailsController.isContactInVK = isPersonInVK;
	
    // person in VK
	if (isPersonInVK)
	{
		_contactDetailsController.sendMessageOrInvite.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
		_contactDetailsController.sendMessageOrInvite.titleLabel.textAlignment = UITextAlignmentCenter;
		[_contactDetailsController.sendMessageOrInvite setTitle:NSLocalizedString(@"Send message", nil) forState:UIControlStateNormal];
        _contactDetailsController.sendMessageOrInvite.tag = 1;
		_contactDetailsController.addToFavorites.alpha = 1;
        
        // set vk user
        _contactDetailsController.vkUser = [person objectForKey:kPersoneVK];
	}
	else 
	{
		_contactDetailsController.sendMessageOrInvite.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
		_contactDetailsController.sendMessageOrInvite.titleLabel.textAlignment = UITextAlignmentCenter;
		[_contactDetailsController.sendMessageOrInvite setTitle:NSLocalizedString(@"Send invite", nil) forState:UIControlStateNormal];
        _contactDetailsController.sendMessageOrInvite.tag = 2;
		_contactDetailsController.addToFavorites.alpha = 0;
	}

    
    // set name
    NSString *firstName = [person objectForKey:kPersonFirstName];
    NSString *secondName = [person objectForKey:kPersonSecondName];
    if(secondName){
        _contactDetailsController.title = [NSString stringWithFormat:@"%@ %@",firstName, secondName];

    }else{
        _contactDetailsController.title = firstName;
    }
    _contactDetailsController.nameLabel.text = _contactDetailsController.title;
    
    // set photo
    if([person objectForKey:@"photo"] != nil){
		_contactDetailsController.photo.contentMode = UIViewContentModeScaleAspectFit;
        _contactDetailsController.photo.image = [person objectForKey:@"photo"];
    }
    
    // check array for numbers, this array contains none, one or two numbers - phoneNumber, iPhoneNumber
    NSArray *phones = [person objectForKey:kPersonPhones];
    if ([phones count] == 0){
        _contactDetailsController.phoneNumber.text = NSLocalizedString(@"No phone number", nil);
        _contactDetailsController.iPhoneNumber.text = NSLocalizedString(@"No iPhone number", nil);
    }else if ([phones count] == 1){
        _contactDetailsController.phoneNumber.text = [phones objectAtIndex:0];
        _contactDetailsController.iPhoneNumber.text = NSLocalizedString(@"No iPhone number", nil);
    }else if ([phones count] >= 1){
        _contactDetailsController.phoneNumber.text = [phones objectAtIndex:0];
        _contactDetailsController.iPhoneNumber.text = [phones objectAtIndex:1];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    // show controller with details info
    [((UIViewController *)self.parentController).navigationController pushViewController:_contactDetailsController animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if([[_searchField text] length] > 0){
		return nil;
    }
    
    return [[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]; 
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if([[_searchField text] length] > 0){
		return NSLocalizedString(@"Search Results", nil);
    }
    
    return [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] 
            objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[_searchField text] length] > 0){
		return [searchArray count];
	}
    
    return [[sections valueForKey:[[[sections allKeys] 
                                    sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([[_searchField text] length] > 0){
		return 1;
    }
	
    return [[sections allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* SimpleTableIdentifier = @"LocalContactsTableCellIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier] autorelease];
    }
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    // set titles
    NSDictionary *person = nil;
    if ([[_searchField text] length] > 0) {
        person = [searchArray objectAtIndex:row];
    }else{
        person = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] 
                  objectAtIndex:indexPath.row];
    }
    
    // is in VK
    BOOL isInVK = [[person objectForKey:kPersoneIsInVK] boolValue];
    if(isInVK){
        UIImageView *isInVKBadge = (UIImageView *)[cell.contentView viewWithTag:101];
        if(isInVKBadge == nil){
            isInVKBadge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vkBadge@2x.png"]];
            isInVKBadge.tag = 101;
            [isInVKBadge setFrame:CGRectMake(270, 16, 12, 12)];
            [cell.contentView addSubview:isInVKBadge];
            [isInVKBadge release];
        }
    }else{
        UIImageView *isInVKBadge = (UIImageView *)[cell.contentView viewWithTag:101];
        [isInVKBadge removeFromSuperview];
    }
    
    
    cell.textLabel.text = [person objectForKey:kPersonFirstName];
    cell.detailTextLabel.text = [person objectForKey:kPersonSecondName];
    
    return cell;
}


#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [searchArray removeAllObjects];
    
    // search field is not clear
    if ([searchText length] > 0){
        
        NSString *searchText = _searchField.text;
        
        for (NSDictionary *dict in people){
            NSString *stringForSearch = [dict objectForKey:kPersonFirstName];
            NSRange titleResultsRange = [stringForSearch rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (titleResultsRange.length > 0) {
                [searchArray addObject:dict]; 
            }    
        }
    }
    
    // Sort search array
    [searchArray sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:kPersonFirstName ascending:YES]]];
    
    // reload table
    [_tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    
    // reload table
    [_tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

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


#pragma mark -
#pragma mark VKServiceResultDelegate

- (void)completedWithVKResult:(VKServiceResult *)result context:(id)context{
    switch (result.queryType) {
        default:
            break;
    }
}

- (void)completedWithVKResult:(VKServiceResult *)result {
    switch (result.queryType) {
        // get friends by phone result
        case VKQueriesTypesFriendsGetByPhones:
            NSLog(@"result.body=%@", result.body);
            if (result.success){

                [[DataManager shared] saveLastTimeGetFriendsByPhones:CFAbsoluteTimeGetCurrent()];
                
                NSArray *friendsByPhones = [result.body objectForKey:kResponse];
                
                // save friends by phones
                [[DataManager shared] saveFriendsByPhones:friendsByPhones];
                
                // check
                [self checkFriendsByPhones:friendsByPhones];
                
            // errors
            }else{
                NSArray *friendsByPhones = [[DataManager shared] friendsByPhones];
                
                // check
                [self checkFriendsByPhones:friendsByPhones];
            }

            break;
        default:
            break;
    }
}

@end
