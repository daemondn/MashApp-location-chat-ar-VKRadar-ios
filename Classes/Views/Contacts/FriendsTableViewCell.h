//
//  FriendsTableViewCell.h
//  Vkmsg
//
//  Created by md314 on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface FriendsTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, assign) IBOutlet AsyncImageView *avatar;
@property (nonatomic ,assign) IBOutlet UILabel *userName;
@property (nonatomic, assign) IBOutlet UIImageView *online;

- (void)setAvatarURL:(NSURL *) photoUrl;

@end
