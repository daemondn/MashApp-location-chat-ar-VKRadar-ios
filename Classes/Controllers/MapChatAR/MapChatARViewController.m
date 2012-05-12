//
//  MapChatARViewController.m
//  Vkmsg
//
//  Created by Alexey on 21.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define mapSearch @"mapSearch"
#define chatSearch @"chatSearch"

#import "MapChatARViewController.h"
#import "ARManager.h"
#import "ARMarkerView.h"
#import "MessageViewController.h"

@interface MapChatARViewController ()

@end

@implementation MapChatARViewController

@synthesize mapViewController, chatViewController, arViewController;
@synthesize segmentControl;
@synthesize mapPoints, chatPoints;
@synthesize userActionSheet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        // divice support AR
        if([ARManager deviceSupportsAR]){
            arViewController = [[AugmentedRealityController alloc] initWithViewFrame:CGRectMake(0, 45, 320, 415)];
            arViewController.delegate = self;
        }
        
        chatIDs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.mapViewController = nil;
    self.chatViewController = nil;
    self.arViewController = nil;
    
    [mapPoints release];
    [chatPoints release];
    [userActionSheet release];
    [chatIDs release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add segment to title
    if(![self.navigationItem.titleView isKindOfClass:UISegmentedControl.class]){
        NSArray *segments;
        if([ARManager deviceSupportsAR]){
            segments = [NSArray arrayWithObjects:NSLocalizedString(@"Radar", nil), 
                                                    NSLocalizedString(@"Map", nil), 
                                                        NSLocalizedString(@"Chat", nil), nil];
        }else{
            segments = [NSArray arrayWithObjects:NSLocalizedString(@"Map", nil), 
                                                    NSLocalizedString(@"Chat", nil), nil];
        }
        segmentControl = [[UISegmentedControl alloc] initWithItems:segments];
        [segmentControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [segmentControl setFrame:CGRectMake(20, 7, 280, 30)];
        [segmentControl addTarget:self action:@selector(segmentValueDidChanged:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = segmentControl;
        [segmentControl release];
    }
    
    mapViewController.delegate = self;
    chatViewController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	
	[FlurryAnalytics logEvent:@"User visit radar tab"];
    
    if(!isFirstAppear){
        // get points for map/ar
        QBLGeoDataSearchRequest *searchMapARPointsRequest = [[QBLGeoDataSearchRequest alloc] init];
        searchMapARPointsRequest.last_only = YES; // Only last location
        searchMapARPointsRequest.perPage = 20; // Pins limit for each page
        searchMapARPointsRequest.sort_by = GeoDataSortByKindCreatedAt;
        [QBLocationService findGeoData:searchMapARPointsRequest delegate:self context:mapSearch];
        [searchMapARPointsRequest release];
        
        
        // get points for chat
        QBLGeoDataSearchRequest *searchChatMessagesRequest = [[QBLGeoDataSearchRequest alloc] init];
        searchChatMessagesRequest.perPage = 20; // Pins limit for each page
        searchChatMessagesRequest.status = YES;
        searchChatMessagesRequest.sort_by = GeoDataSortByKindCreatedAt;
        [QBLocationService findGeoData:searchChatMessagesRequest delegate:self context:chatSearch];
        [searchChatMessagesRequest release];
        
        
        // check for new points
        updateTimre = [[NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(checkForNewPoints:) userInfo:nil repeats:YES] retain];
        
        // show map
        [segmentControl setSelectedSegmentIndex:0];
        [self segmentValueDidChanged:segmentControl];
    }    
    isFirstAppear = YES;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [updateTimre invalidate];
    [updateTimre release];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// get new points from QuickBlox Location
- (void) checkForNewPoints:(NSTimer *) timer{
	QBLGeoDataSearchRequest *searchRequest = [[QBLGeoDataSearchRequest alloc] init];
	searchRequest.status = YES;
    searchRequest.sort_by = GeoDataSortByKindCreatedAt;
    searchRequest.sort_asc = 1;
    searchRequest.perPage = 15;
    searchRequest.min_created_at = [NSDate dateWithTimeIntervalSinceNow:-20];
	[QBLocationService findGeoData:searchRequest delegate:self];
	[searchRequest release];
}

- (void)segmentValueDidChanged:(id)sender{
    switch (segmentControl.selectedSegmentIndex) {
        // show Radar / Map
        case 0:
            if(segmentControl.numberOfSegments == 2){
                [self showMap];
            }else{
                [self showRadar];
            }
           
            break;
        
        // show Map / Chat
        case 1:
            if(segmentControl.numberOfSegments == 2){
                [self showChat];
            }else{
                [self showMap];
            }
            break;
            
        // Chat
        case 2:
            [self showChat];
                        
            break;
            
        default:
            break;
    }
}

- (void)showRadar{
    if([arViewController.view superview] == nil){
        [self.view addSubview:arViewController.view];
        [arViewController.view setFrame:CGRectMake(0, 0, 320, 436)];
    }
    [mapViewController.view removeFromSuperview];
    [chatViewController.view removeFromSuperview];
    
    // start AR
    [arViewController displayAR];
    
    
    // show popup at 1st run
    if([[DataManager shared] isFirstStartApp]){
        [[DataManager shared] setFirstStartApp:NO];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VK", nil) 
                                                        message:NSLocalizedString(@"Look through Radar white turning around to see who is where. Switch to Map and Chat (above) when necessary.", nil)    
                                                       delegate:nil 
                                              cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)showChat{
	[FlurryAnalytics logEvent:@"User visit mapchat tab"];
	
    if([chatViewController.view superview] == nil){
        [self.view addSubview:chatViewController.view];
        [chatViewController.view setFrame:CGRectMake(0, 0, 320, 438)];
    }
    [mapViewController.view removeFromSuperview];
    [arViewController.view removeFromSuperview];
    
    // stop AR
    [arViewController dissmisAR];
}

- (void)showMap{
	[FlurryAnalytics logEvent:@"User visit map tab"];
	
    if([mapViewController.view superview] == nil){
        [self.view addSubview:mapViewController.view];
        [mapViewController.view setFrame:CGRectMake(0, 0, 320, 436)];
    }
    [chatViewController.view removeFromSuperview];
    [arViewController.view removeFromSuperview];
    
    // stop AR
    [arViewController dissmisAR];
}


/*
 Touch on marker
 */
- (void)touchOnMarker:(UIView *)marker{
    // get user name & id
    NSString *userName = nil;
    if([marker isKindOfClass:MapMarkerView.class]){ // map
        userName = ((MapMarkerView *)marker).userName.text;
        selectedVKUser = ((MapMarkerView *)marker).annotation.vkUser;
    }else if([marker isKindOfClass:ARMarkerView.class]){ // ar
        userName = ((ARMarkerView *)marker).userName.text;
        selectedVKUser = ((ARMarkerView *)marker).userAnnotation.vkUser;
    }else if([marker isKindOfClass:UITableViewCell.class]){ // chat
        userName = ((UILabel *)[marker viewWithTag:105]).text;
        UserAnnotation *currentAnnotation = [chatPoints objectAtIndex:marker.tag];
        selectedVKUser = currentAnnotation.vkUser;
    }

    
    // check yourself
    if([[selectedVKUser objectForKey:kUid] intValue] == [[[DataManager shared].currentUserBody objectForKey:kUid] intValue]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VK", nil) 
                                                        message:NSLocalizedString(@"It's me!", nil)  
                                                       delegate:nil 
                                              cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    // show action sheet
    if(userActionSheet == nil){
        userActionSheet = [[UIActionSheet alloc] initWithTitle:userName 
                                                      delegate:self 
                                             cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
                                        destructiveButtonTitle:nil 
                                             otherButtonTitles:NSLocalizedString(@"Send message", nil), NSLocalizedString(@"View personal VK page", nil),
                                                               NSLocalizedString(@"Add to friends", nil), nil];
    }

    [userActionSheet showFromTabBar:self.tabBarController.tabBar];
}

/*
 Add new annotation to map,chat,ar
 */
- (void)addNewAnnotationToMapChatARForVKUser:(NSDictionary *)vkUser withGeoData:(QBLGeoData *)geoData{
    
    // save messages ids
    [chatIDs addObject:[NSString stringWithFormat:@"%d", geoData.ID]];
    
    // create new user annotation
    UserAnnotation *newAnnotation = [[UserAnnotation alloc] init];
    newAnnotation.geoDataID = geoData.ID;
    newAnnotation.coordinate = geoData.location.coordinate;
    newAnnotation.userStatus = geoData.status;
    newAnnotation.userName = [NSString stringWithFormat:@"%@ %@", 
                              [vkUser objectForKey:kUserFirstName], [vkUser objectForKey:kUserLastName]];
    newAnnotation.userPhotoUrl = [vkUser objectForKey:kPhoto];
    newAnnotation.vkUserId = [[vkUser objectForKey:kUid] intValue];
    newAnnotation.vkUser = vkUser;
	newAnnotation.createdAt = geoData.created_at;
    
    // Add to Chat
    [chatPoints insertObject:newAnnotation atIndex:0];
    [newAnnotation release];
    //
    NSIndexPath *newMessagePath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *newRows = [[NSArray alloc] initWithObjects:newMessagePath, nil];
    [chatViewController.messagesTableView insertRowsAtIndexPaths:newRows withRowAnimation:UITableViewRowAnimationNone];
    [newRows release];
    
    
    // Check for Map
    BOOL isExistPoint = NO;
    for (UserAnnotation *annotation in mapViewController.mapView.annotations){
        // already exist, change status
        if(newAnnotation.vkUserId == annotation.vkUserId){
            annotation.userStatus = newAnnotation.userStatus;
            MapMarkerView *marker = (MapMarkerView *)[mapViewController.mapView viewForAnnotation:annotation];
            marker.userStatus.text = annotation.userStatus;
            isExistPoint = YES;
            break;
        }
    }
    
    // Check for AR
    if(isExistPoint){
        for (ARMarkerView *marker in arViewController.coordinateViews){
            // already exist, change status
            if(newAnnotation.vkUserId == marker.userAnnotation.vkUserId){
                ARMarkerView *marker = (ARMarkerView *)[arViewController viewForExistAnnotation:newAnnotation];
                marker.userStatus.text = newAnnotation.userStatus;
                isExistPoint = YES;
                break;
            }
        }
    }
    
    // new -> add to Map, AR
    if(!isExistPoint){
        [mapPoints addObject:newAnnotation];
        [mapViewController.mapView addAnnotation:newAnnotation];
        [arViewController addUserAnnotation:newAnnotation];
    }
}

 
#pragma mark -
#pragma mark ActionStatusDelegate

- (void)completedWithResult:(Result *)result context:(void *)contextInfo{
    // get points result
	if([result isKindOfClass:[QBLGeoDataPagedResult class]]){
        if (result.success){
            QBLGeoDataPagedResult *geoDataSearchResult = (QBLGeoDataPagedResult *)result;
            
            // update map
            if([((NSString *)contextInfo) isEqualToString:mapSearch]){
                [mapPoints release];
                mapPoints = [geoDataSearchResult.geodatas mutableCopy];
                
                // get vk users info
                NSMutableArray *vkMapUsersIds = [[NSMutableArray alloc] init];
                for (QBLGeoData *geodata in geoDataSearchResult.geodatas){
                    [vkMapUsersIds addObject:[NSNumber numberWithInt:geodata.user.externalUserID]];
                }
                //
                [VKService usersProfilesWithIds:[vkMapUsersIds stringComaSeparatedValue] delegate:self context:mapSearch];
                //
                [vkMapUsersIds release];
                
            // update chat
            }else if([((NSString *)contextInfo) isEqualToString:chatSearch]){
                [chatPoints release];
                chatPoints = [geoDataSearchResult.geodatas mutableCopy]; 
                
                // get vk users info
                NSMutableArray *vkChatUsersIds = [[NSMutableArray alloc] init];
                for (QBLGeoData *geodata in geoDataSearchResult.geodatas){
                    [vkChatUsersIds addObject:[NSNumber numberWithInt:geodata.user.externalUserID]];
                }
                //
                [VKService usersProfilesWithIds:[vkChatUsersIds stringComaSeparatedValue] delegate:self context:chatSearch];
                //
                [vkChatUsersIds release];
            
            // check for new one
            }else{
                if([geoDataSearchResult.geodatas count] == 0){
                    return;
                }
                
                
                // get vk users info
                NSMutableArray *vkChatUsersIds = nil;
                NSMutableArray *geodataProcessed = [NSMutableArray array];
                for (QBLGeoData *geodata in geoDataSearchResult.geodatas){
                    // skip if already exist
                    if([chatIDs containsObject:[NSString stringWithFormat:@"%d", geodata.ID]]){
                        continue;
                    }
                    
                    // skip own;
                    if([DataManager shared].currentQBUser.ID == geodata.user.ID){
                        continue;
                    }

                    // collect users ids
                    if(vkChatUsersIds == nil){
                        vkChatUsersIds = [[NSMutableArray alloc] init];
                    }
                    [vkChatUsersIds addObject:[NSNumber numberWithInt:geodata.user.externalUserID]];
                    
                    [geodataProcessed addObject:geodata];
                }
                
                if(vkChatUsersIds == nil){
                    return;
                }
                
                //
                [VKService usersProfilesWithIds:[vkChatUsersIds stringComaSeparatedValue] delegate:self context:geodataProcessed];
                //
                [vkChatUsersIds release];
            }
        }
    }
}


#pragma mark -
#pragma mark VKServiceResultDelegate

- (void)completedWithVKResult:(VKServiceResult *)result context:(id)context{
    switch (result.queryType) {
        case VKQueriesTypesUsersGet:
            if(result.success){
                
                // Map/AR init
                if([context isKindOfClass:NSString.class] && [context isEqualToString:mapSearch]){
                    CLLocationCoordinate2D coordinate;
                    int index = 0;
                    
                    NSArray *mapPointsCopy = [NSArray arrayWithArray:mapPoints];
                    for (QBLGeoData *geodata in mapPointsCopy) {	

                        NSDictionary *vkUser = [[result.body objectForKey:kResponse] objectAtIndex:index];
                        
                        coordinate.latitude = geodata.latitude;
                        coordinate.longitude = geodata.longitude;
                        UserAnnotation *mapAnnotation = [[UserAnnotation alloc] init];
                        mapAnnotation.geoDataID = geodata.ID;
                        mapAnnotation.coordinate = coordinate;
                        mapAnnotation.userStatus = geodata.status;
                        mapAnnotation.userName = [NSString stringWithFormat:@"%@ %@", 
                                                        [vkUser objectForKey:kUserFirstName], [vkUser objectForKey:kUserLastName]];
                        mapAnnotation.userPhotoUrl = [vkUser objectForKey:kPhoto];
                        mapAnnotation.vkUserId = [[vkUser objectForKey:kUid] intValue];
                        mapAnnotation.vkUser = vkUser;
                        mapAnnotation.createdAt = geodata.created_at;
                        [mapPoints replaceObjectAtIndex:index withObject:mapAnnotation];
                        [mapAnnotation release];
                        
                        ++index;
                        
                        
                        
                        // own centered
                        if( mapAnnotation.vkUserId == [[[DataManager shared].currentUserBody objectForKey:kUid] intValue]){
                            MKCoordinateRegion region;
                            //Set Zoom level using Span
                            MKCoordinateSpan span;  
                            region.center = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
                            span.latitudeDelta = 10;
                            span.longitudeDelta = 10;
                            region.span = span;
                            [mapViewController.mapView setRegion:region animated:TRUE];
                        }
                    }
                    
                    [mapViewController pointsUpdated];
                    [arViewController pointsUpdated];
                    
                // Chat init
                }else if([context isKindOfClass:NSString.class] && [context isEqualToString:chatSearch]){
                    CLLocationCoordinate2D coordinate;
                    int index = 0;
                    
                    NSArray *chatPointsCopy = [NSArray arrayWithArray:chatPoints];
                    for (QBLGeoData *geodata in chatPointsCopy) {	
                        
                        NSDictionary *vkUser = nil;
                        for(NSDictionary *user in [result.body objectForKey:kResponse]){
                            if(geodata.user.externalUserID == [[user objectForKey:kUid] intValue]){
                                vkUser = user;
                                break;
                            }
                        }
                        
                        coordinate.latitude = geodata.latitude;
                        coordinate.longitude = geodata.longitude;
                        UserAnnotation *chatAnnotation = [[UserAnnotation alloc] init];
                        chatAnnotation.geoDataID = geodata.ID;
                        chatAnnotation.coordinate = coordinate;
                        chatAnnotation.userStatus = geodata.status;
                        chatAnnotation.userName = [NSString stringWithFormat:@"%@ %@", 
                                                        [vkUser objectForKey:kUserFirstName], [vkUser objectForKey:kUserLastName]];
                        chatAnnotation.userPhotoUrl = [vkUser objectForKey:kPhoto];
                        chatAnnotation.vkUserId = [[vkUser objectForKey:kUid] intValue];
                        chatAnnotation.vkUser = vkUser;
                        chatAnnotation.createdAt = geodata.created_at;
                        [chatPoints replaceObjectAtIndex:index withObject:chatAnnotation];
                        [chatAnnotation release];
                        
                        [chatIDs addObject:[NSString stringWithFormat:@"%d", geodata]];
                        
                        ++index;
                    }
                    
                    [chatViewController pointsUpdated];
                
                // check new
                }else{
                    for (QBLGeoData *geoData in context) {	
                        
                        // get vk user
                        NSDictionary *vkUser = nil;
                        for(NSDictionary *user in [result.body objectForKey:kResponse]){
                            if(geoData.user.externalUserID == [[user objectForKey:kUid] intValue]){
                                vkUser = user;
                                break;
                            }
                        }
                        
                        // add new Annotation to map/chat/ar
                        [self addNewAnnotationToMapChatARForVKUser:vkUser withGeoData:geoData];
                    }        
                }
            }
            break;
            
        // add to friends
        case VKQueriesTypesFriendsAdd:
            if(result.success){
                NSString *message = nil;
                if([[result.body objectForKey:kResponse] intValue] == 1){
                    message = NSLocalizedString(@"Invite has been sent", nil);
                }else if([[result.body objectForKey:kResponse] intValue] == 2){
                    message = NSLocalizedString(@"Friend has been added", nil);
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"VK", nil) 
                                                                message: message 
                                                               delegate:nil 
                                                      cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else{
                NSString *message = [result.errors stringValue];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Errors", nil) 
                                                                message:message  
                                                               delegate:nil 
                                                      cancelButtonTitle:NSLocalizedString(@"Ok", nil) 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            break;
        default:
            break;
    }
}

- (void)completedWithVKResult:(VKServiceResult *)result{
    [self completedWithVKResult:result context:nil];
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{ // send message
                MessageViewController *messagesViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
                messagesViewController.isNewConversation = YES;
                [messagesViewController setUserOpponent:selectedVKUser];
                [self.navigationController pushViewController:messagesViewController animated:YES];
                [messagesViewController release];
            }

            break;
        case 1: // view personal vk page
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/id%@", VK, [selectedVKUser objectForKey:kUid]]]];
            break;
        case 2: // add to friends
            [VKService friendsAdd:[selectedVKUser objectForKey:kUid] delegate:self];
            break;
        case 3: // cancel
            break;
            
        default:
            break;
    }
    
    [userActionSheet release];
    userActionSheet = nil;
}

@end
