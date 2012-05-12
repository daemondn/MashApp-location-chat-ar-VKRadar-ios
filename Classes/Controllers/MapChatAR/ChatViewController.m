//
//  ChatViewController.m
//  Vkmsg
//
//  Created by Igor Khomenko on 3/27/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#define messageWidth 190

#import "ChatViewController.h"
#import "MapChatARViewController.h"
#import "ARMarkerView.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

@synthesize messageField, messagesTableView, activityIndicator, sendMessageActivityIndicator;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    messageField.leftViewMode = UITextFieldViewModeAlways;
    messageField.leftView = paddingView;
    [paddingView release];
    
    messageBGImage = [[[UIImage imageNamed:@"Grey_Bubble.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:13] retain];
    
    [activityIndicator startAnimating];
    [messagesTableView setUserInteractionEnabled:NO];
}

- (void)viewDidUnload
{
    self.messageField = nil;
    self.messagesTableView = nil;
    self.activityIndicator = nil;
    self.sendMessageActivityIndicator = nil;
    
    [messageBGImage release];
    messageBGImage = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)sendMessageDidPress:(id)sender{
    if ([[messageField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return;
    }    

	QBLGeoData *geoData = [QBLGeoData currentGeoData];
#ifdef DEBUG
    NSArray *coord = [[TestManager shared].testLocations objectForKey:[DataManager shared].currentUserId];
    if(coord != nil){
        geoData.latitude = (CLLocationDegrees)[[coord objectAtIndex:0] doubleValue];
        geoData.longitude = (CLLocationDegrees)[[coord objectAtIndex:1] doubleValue];
    }
#endif
	geoData.user = [DataManager shared].currentQBUser;
    geoData.status = messageField.text;
	
	geoData.created_at = [NSDate date];
	geoData.createdAt = [NSDate date];
	
    // post geodata
	[QBLocationService postGeoData:geoData delegate:self];	
	
	messageField.text = nil;
    
    [sendMessageActivityIndicator startAnimating];
}

- (void)pointsUpdated{
    messagesTableView.delegate = self;
    messagesTableView.dataSource = self;
    [messagesTableView reloadData];
    [activityIndicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.3];
    [messagesTableView setUserInteractionEnabled:YES];
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
        backView = [[ViewTouch alloc] initWithFrame:CGRectMake(0, 44, 320, 154) selector:@selector(touchOnView:) target:self];
        [self.view addSubview:backView];
        [backView release];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [backView removeFromSuperview];
    backView = nil;
}

- (void)touchOnView:(UIView *)view{
    [messageField resignFirstResponder];
}


#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserAnnotation *currentAnnotation = [[((MapChatARViewController *)delegate) chatPoints] objectAtIndex:[indexPath row]];
    
    CGSize boundingSize = CGSizeMake(messageWidth-20, 10000000);
    
    CGSize itemFrameSize = [currentAnnotation.userStatus sizeWithFont:[UIFont systemFontOfSize:14]
                            constrainedToSize:boundingSize
                                lineBreakMode:UILineBreakModeWordWrap];
    
    if(itemFrameSize.height < 50){
        itemFrameSize.height = 50;
    }
    return itemFrameSize.height + 15;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[((MapChatARViewController *)delegate) chatPoints] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserAnnotation *currentAnnotation = [[((MapChatARViewController *)delegate) chatPoints] objectAtIndex:[indexPath row]];
    
    // get height
    CGSize boundingSize = CGSizeMake(messageWidth-20, 10000000);
    
    CGSize itemFrameSize = [currentAnnotation.userStatus sizeWithFont:[UIFont systemFontOfSize:14]
                                             constrainedToSize:boundingSize
                                                 lineBreakMode:UILineBreakModeWordWrap];
    float textHeight = itemFrameSize.height + 7;
    float cellHeight = itemFrameSize.height < 50 ? 50 : itemFrameSize.height;
    cellHeight += 15;
	
    
    static NSString *reuseIdentifier = @"MessageCellReuseIdentifier";
    
    // create cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    AsyncImageView *userPhoto;
    UIImageView *messageBGView;
    UILabel *userMessage;
    UILabel *userName;
    UILabel *datetime;
    
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // user photo
        userPhoto = [[AsyncImageView alloc] init];
        userPhoto.layer.masksToBounds = YES;
        userPhoto.userInteractionEnabled =YES;
        userPhoto.tag = 101;
        userPhoto.layer.cornerRadius = 26;
        [cell.contentView addSubview:userPhoto];
        [userPhoto release];
        
        // user message
        //
        // background
        messageBGView = [[UIImageView alloc] init];
        messageBGView.tag = 102;
        [messageBGView setImage:messageBGImage];
         messageBGView.userInteractionEnabled =YES;
        [cell.contentView addSubview:messageBGView];
        [messageBGView release];
        //
        // label
        userMessage = [[UILabel alloc] init];
        userMessage.tag = 103;
        [userMessage setFont:[UIFont systemFontOfSize:14]];
        userMessage.numberOfLines = 0;
        [userMessage setBackgroundColor:[UIColor clearColor]];
        [messageBGView addSubview:userMessage];
        [userMessage release];
        
        
        // datetime
        datetime = [[UILabel alloc] init];
        datetime.tag = 104;
        [datetime setTextAlignment:UITextAlignmentCenter];
        datetime.numberOfLines = 2;
        [datetime setFont:[UIFont systemFontOfSize:11]];
        [datetime setBackgroundColor:[UIColor clearColor]];
        [datetime setTextColor:[UIColor grayColor]];
        [cell.contentView addSubview:datetime];
        [datetime release];
        
        // label
        userName = [[UILabel alloc] init];
        userName.tag = 105;
        [userName setFont:[UIFont boldSystemFontOfSize:11]];
        [userName setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:userName];
        [userName release];

    }else{
        userPhoto = (AsyncImageView *)[cell.contentView viewWithTag:101];
        messageBGView = (UIImageView *)[cell.contentView viewWithTag:102];
        userMessage = (UILabel *)[messageBGView viewWithTag:103];
        datetime = (UILabel *)[cell.contentView viewWithTag:104];
        userName = (UILabel *)[cell.contentView viewWithTag:105];
    }
    
    // set user photo
    [userPhoto setFrame:CGRectMake(5, cellHeight-52, 50, 50)];
    [userPhoto loadImageFromURL:[NSURL URLWithString:currentAnnotation.userPhotoUrl]];

    // set bg
    [messageBGView setFrame:CGRectMake(62, cellHeight-textHeight-10, messageWidth, textHeight)];
    
    // set message
    [userMessage setFrame:CGRectMake(15, 3, messageWidth-20, messageBGView.frame.size.height-10)];
    userMessage.text = currentAnnotation.userStatus; 
    [userMessage sizeToFit];
    
    // datetime
	NSTimeZone *tz = [NSTimeZone defaultTimeZone];
	NSInteger seconds = [tz secondsFromGMTForDate: currentAnnotation.createdAt];
	NSDate* firstDate = [NSDate dateWithTimeInterval: seconds sinceDate: currentAnnotation.createdAt];
	NSDate* secondaryDate = [NSDate dateWithTimeInterval: seconds sinceDate: firstDate]; // double timeshift
    datetime.text = [[secondaryDate description] substringToIndex:[[secondaryDate description] length]-6];
	
    [datetime setFrame:CGRectMake(messageWidth + 59, cellHeight-40, 75, 30)];
    
    // set user name
    [userName setFrame:CGRectMake(messageWidth + 61, cellHeight-52, 71, 12)];
    userName.text = currentAnnotation.userName; 
    
    // set vk user id
    cell.tag = [indexPath row];
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [delegate performSelector:@selector(touchOnMarker:) withObject:cell];
}


#pragma mark -
#pragma mark ActionStatusDelegate

- (void)completedWithResult:(Result *)result{
    // create message result
    if([result isKindOfClass:[QBLGeoDataResult class]]){
        if(result.success){
            QBLGeoDataResult *geoDataRes = (QBLGeoDataResult*)result; 
            
            // current vk user
            NSDictionary *currentVKUser = [DataManager shared].currentUserBody;
            // clear text
            messageField.text = @"";
            // add new Annotation to map/chat/ar
            [((MapChatARViewController *)delegate) addNewAnnotationToMapChatARForVKUser:currentVKUser withGeoData:geoDataRes.geoData];
        }
        [sendMessageActivityIndicator stopAnimating];
    }
}

@end
