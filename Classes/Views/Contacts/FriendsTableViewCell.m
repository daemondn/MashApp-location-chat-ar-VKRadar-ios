//
//  FriendsTableViewCell.m
//  Vkmsg
//
//  Created by md314 on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsTableViewCell.h"

@implementation FriendsTableViewCell

@synthesize avatar = _avatar;
@synthesize userName = _userName;
@synthesize online = _online;

- (void)dealloc {
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

- (void)setAvatarURL:(NSURL *) photoUrl {
    [_avatar loadImageFromURL:photoUrl];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
