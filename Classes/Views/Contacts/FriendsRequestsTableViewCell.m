//
//  FriendsRequestsTableViewCell.m
//  Vkmsg
//
//  Created by Alexey on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsRequestsTableViewCell.h"

@implementation FriendsRequestsTableViewCell

@synthesize avatar = _avatar;
@synthesize userName = _userName;
@synthesize addButton;

- (void)dealloc
{
    [addButton release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setAvatarURL:(NSURL *) photoUrl 
{
    [_avatar loadImageFromURL:photoUrl];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
