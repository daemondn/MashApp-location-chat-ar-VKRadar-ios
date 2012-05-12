//
//  FriendRequestsViewController.h
//  Vkmsg
//
//  Created by Igor Khomenko on 3/28/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsRequestsTableViewCell.h"

@class FriendsRequestsTableViewCell;

@interface FriendRequestsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, VKServiceResultDelegate>
{
}
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) NSMutableArray* requestsUsers;
@property (nonatomic, retain) NSMutableArray* suggestUsers;

- (void) addFriend:(id)sender;
- (void) setupCell:(FriendsRequestsTableViewCell *)cell forUser:(NSDictionary *)user withIndexPath:(NSIndexPath *)indexPath;

@end
