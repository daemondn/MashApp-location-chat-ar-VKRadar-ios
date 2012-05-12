//
//  DialogViewController.h
//  Vkmsg
//
//  Created by Rostislav Kobizsky on 4/4/12.
//  Copyright (c) 2012 Injoit Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "MessageViewController.h"
#import "AsyncImageView.h"
#import "NSString+HTML.h"
#import "ViewTouch.h"

@interface DialogViewController : PullRefreshTableViewController <VKServiceResultDelegate, UISearchBarDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    NSMutableArray *searchArray;
    
    UIActivityIndicatorView *activityIndicator;
    
    // back view fro hide keyboard
    ViewTouch *backView;
    
    BOOL isInitialized;
}
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@end
