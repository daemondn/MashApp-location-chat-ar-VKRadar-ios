//
//  FavoritesController.h
//  Vkmsg
//
//  Created by md314 on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *favoritiesFriends;
}
@property (nonatomic, retain) IBOutlet UITableView *favoritiesTableView;
@property (nonatomic, retain) IBOutlet UIImageView *inviteFriendsContainer;

- (IBAction)inviteFriendButtonDidPress :(id)sender;
- (void)editButtonDidPress :(id)sender;
- (void)addButtonDidPress :(id)sender;

- (void)startDialogWithFriend:(NSDictionary *)friend;

@end
