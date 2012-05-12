//
//  FriendsViewController.h
//  Vkmsg
//
//  Created by Igor Khomenko on 3/28/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsTableViewCell.h"
#import "MessageViewController.h"
#import "ViewTouch.h"

@interface FriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, VKServiceResultDelegate>{

    // search data
    NSMutableArray *searchArray;
    
    // friends
    NSMutableDictionary *sections;
    NSMutableArray *friends;
    
    
    // for favorities feature
    NSMutableArray *selectedFriendsPathes;
    NSMutableArray *friendsToAddToFavorities;
    
    // back view fro hide keyboard
    ViewTouch *backView;
    
    // 
    MessageViewController *messagesViewController;
}
@property (nonatomic, retain) IBOutlet UISearchBar *searchField;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView *addSelectedContainer;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) UIViewController *parentController;

@property (nonatomic, assign) BOOL openedFromFavoritesController;
@property (nonatomic, assign) BOOL openedFromMessagesController;
@property (nonatomic, assign) BOOL openedFromEditConversationController;

- (IBAction) addSelectedButtonDidPress:(id)sender;

- (void) searchTableView;
- (void) newFriendsWasAdded;

@end
