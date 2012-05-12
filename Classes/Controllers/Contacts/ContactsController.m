//
//  ContactsController.m
//  Vkmsg
//
//  Created by md314 on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsController.h"

@interface ContactsController ()

@end

@implementation ContactsController

@synthesize localContactsController = _localContactsController;
@synthesize friendsViewController = _friendsViewController;
@synthesize friendRequestsViewController = _friendRequestsViewController;
@synthesize segmentControl = segmentControl;

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.localContactsController = nil;
    self.friendsViewController = nil;
    self.friendRequestsViewController = nil;
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
    if(self){
        _localContactsController.view.alpha = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _localContactsController.parentController = self;
    _localContactsController.contactDetailsController.parentController = self;
    _friendsViewController.parentController = self;
    
    // add segment to title
    segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Contacts", nil), NSLocalizedString(@"Friends", nil), NSLocalizedString(@"Requests", nil), nil]];
    [segmentControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [segmentControl setFrame:CGRectMake(20, 7, 280, 30)];
    [segmentControl setSelectedSegmentIndex:0];
    [segmentControl addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentControl;
    [segmentControl release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!isFirstAppear){
        [segmentControl setSelectedSegmentIndex:0];
        [self segmentChange:segmentControl];
    }else{
        switch ([segmentControl selectedSegmentIndex]) {
            case 0:
                break;
            case 1:
                [_friendsViewController viewWillAppear:NO];
                break;
            case 2:
                [_friendRequestsViewController viewWillAppear:NO];
                break;
        }
    }
    isFirstAppear = YES;
}

#pragma mark -
#pragma mark Segment action

- (void)segmentChange:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;

    switch ([segmentedControl selectedSegmentIndex]) {
        // show Local contacts
        case 0:
            if([_localContactsController.view superview] == nil){
                [self.view addSubview:_localContactsController.view];
                [_localContactsController viewWillAppear:NO];
				[_localContactsController.view setFrame:CGRectMake(0, 0, 320, 390)];
            }
            [_friendsViewController.view removeFromSuperview];
            [_friendRequestsViewController.view removeFromSuperview];
            
            break;
            
        // show Friends
        case 1:
            if([_friendsViewController.view superview] == nil){
                [self.view addSubview:_friendsViewController.view];
                [_friendsViewController viewWillAppear:NO];
                [_friendsViewController.view setFrame:CGRectMake(0, 0, 320, 460)];
            }
            [_localContactsController.view removeFromSuperview];
            [_friendRequestsViewController.view removeFromSuperview];
            
            break;
            
        // show Friends requests
        case 2:
            if([_friendRequestsViewController.view superview] == nil){
                [self.view addSubview:_friendRequestsViewController.view];
                [_friendRequestsViewController viewWillAppear:NO];
				[_friendRequestsViewController.tableView reloadData];
                [_friendRequestsViewController.view setFrame:CGRectMake(0, 0, 320, 415)];
            }
            [_localContactsController.view removeFromSuperview];
            [_friendsViewController.view removeFromSuperview];
            
            break;
            
        default:
            break;
    }
}

@end
