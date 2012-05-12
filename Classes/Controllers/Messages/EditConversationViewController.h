//
//  EditConversationViewController.h
//  Vkmsg
//
//  Created by Igor Khomenko on 4/12/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageViewController.h"

@interface EditConversationViewController : UIViewController <VKServiceResultDelegate>{
    NSMutableArray *chatUsers;
}

@property (nonatomic, retain) IBOutlet UITableView *usersTableView;
@property (nonatomic, assign) int chatID;
@property (nonatomic, retain) NSDictionary *friendToAdd;
@property (nonatomic, assign) MessageViewController *messagesViewController;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
