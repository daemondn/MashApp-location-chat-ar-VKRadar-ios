//
//  LocalContactsViewController.h
//  Vkmsg
//
//  Created by Igor Khomenko on 3/28/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDetailsViewController.h"
#import "ViewTouch.h"

@class ContactDetailsViewController;
@class ContactsController;

@interface LocalContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, VKServiceResultDelegate>{

    NSMutableDictionary* sections;
    
    // all people
    NSMutableArray* people;
    
    // all phones
    NSMutableDictionary *phonesDictionary;
    BOOL friendsByPhonesInitialized;
    
    // search
    NSMutableArray *searchArray;

    // back view for hide keyboard
    ViewTouch* backView;
}

@property (nonatomic, retain) IBOutlet UISearchBar *searchField;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) ContactsController *parentController;

@property (nonatomic, retain) IBOutlet ContactDetailsViewController *contactDetailsController;

- (void)checkFriendsByPhones:(NSArray *)friendsByPhones;

@end
