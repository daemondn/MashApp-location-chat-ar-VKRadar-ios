//
//  ChatViewController.h
//  Vkmsg
//
//  Created by Igor Khomenko on 3/27/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewTouch.h"

@interface ChatViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, ActionStatusDelegate>{
    UIImage *messageBGImage;
    
    ViewTouch *backView;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) IBOutlet UITextField *messageField;
@property (nonatomic, retain) IBOutlet UITableView *messagesTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *sendMessageActivityIndicator;

- (IBAction)sendMessageDidPress:(id)sender;

- (void)pointsUpdated;

@end
