//
//  FriendsRequestsTableViewCell.h
//  Vkmsg
//
//  Created by Alexey on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface FriendsRequestsTableViewCell : UITableViewCell
{
    UIButton* addButton;
}

@property (nonatomic, assign) IBOutlet AsyncImageView *avatar;
@property (nonatomic ,assign) IBOutlet UILabel *userName;
@property (nonatomic, retain) IBOutlet UIButton* addButton;

- (void)setAvatarURL:(NSURL *) photoUrl;

@end
