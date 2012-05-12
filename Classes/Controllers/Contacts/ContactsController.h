//
//  ContactsController.h
//  Vkmsg
//
//  Created by md314 on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocalContactsViewController.h"
#import "FriendsViewController.h"
#import "FriendRequestsViewController.h"

@interface ContactsController : UIViewController{
    BOOL isFirstAppear;
}

@property (nonatomic, retain) IBOutlet LocalContactsViewController *localContactsController;
@property (nonatomic, retain) IBOutlet FriendsViewController *friendsViewController;
@property (nonatomic, retain) IBOutlet FriendRequestsViewController *friendRequestsViewController;

@property (nonatomic, assign)  UISegmentedControl *segmentControl;

- (void)segmentChange:(id)sender;

@end
