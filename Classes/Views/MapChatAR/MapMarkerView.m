//
//  MapPinView.m
//  Vkmsg
//
//  Created by Igor Khomenko on 3/28/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import "MapMarkerView.h"

#define markerWidth 100
#define markerHeight 55

@implementation MapMarkerView
@synthesize userPhotoView, userName, userStatus, annotation;
@synthesize target, action;

-(id)initWithAnnotation:(id<MKAnnotation>)_annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithAnnotation:_annotation reuseIdentifier:reuseIdentifier])) {
        
        self.frame = CGRectMake(0, 0, markerWidth, markerHeight);
        
        // save annotation
        //
        self.annotation = _annotation;
        
        // bg view for user name & status & photo
        //
        container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, markerWidth, markerHeight-10)];
        container.layer.cornerRadius = 5;
        container.clipsToBounds = YES;
        [container setBackgroundColor:[UIColor clearColor]];
        [self addSubview:container];
        [container release];
        
        
        // add user photo 
        //
		userPhotoView = [[AsyncImageView alloc] initWithFrame: CGRectMake(0, 0, 45, 45)];
		[userPhotoView loadImageFromURL:[NSURL URLWithString:annotation.userPhotoUrl]];
		[container addSubview: userPhotoView];
        [userPhotoView release];
        
        
        // add userName
        //
        UIImageView *userNameBG = [[UIImageView alloc] init];
        [userNameBG setFrame:CGRectMake(45, 0, 55, 23)];
        [userNameBG setImage:[UIImage imageFromResource:@"radarMarkerName@2x.png"]];
        [container addSubview: userNameBG];
        [userNameBG release];
        //
        userName = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, userNameBG.frame.size.width-3, userNameBG.frame.size.height)];
        [userName setBackgroundColor:[UIColor clearColor]];
        [userName setText:annotation.userName];
        [userName setFont:[UIFont boldSystemFontOfSize:11]];
        [userName setTextColor:[UIColor whiteColor]];
        [userNameBG addSubview:userName];
        [userName release];
        
        
        // add userStatus
        //
        UIImageView *userStatusBG = [[UIImageView alloc] init];
        [userStatusBG setFrame:CGRectMake(45, 23, 55, 22)];
        [userStatusBG setImage:[UIImage imageFromResource:@"radarMarkerStatus@2x.png"]]; 
        [container addSubview: userStatusBG];
        [userStatusBG release];
        //
        userStatus = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, userStatusBG.frame.size.width-3, userStatusBG.frame.size.height)];
        [userStatus setFont:[UIFont systemFontOfSize:11]];
        [userStatus setText:annotation.userStatus];
        [userStatus setBackgroundColor:[UIColor clearColor]];
        [userStatus setTextColor:[UIColor whiteColor]];
        [userStatusBG addSubview:userStatus];
        [userStatus release];
        
        
        // add arrow
        //
        UIImageView *arrow = [[UIImageView alloc] init];
        [arrow setImage:[UIImage imageFromResource:@"radarMarkerArrow@2x.png"]];
        [arrow setFrame:CGRectMake(45, 45, 10, 8)];
        [self addSubview: arrow];
        [arrow release];
    }
    
    return self;
}

/*
- (void)setAnnotation:(UserAnnotation *)_annotation{
    [annotation release];
    annotation = [_annotation retain];
    
    // it's me
    if([[annotation.vkUser objectForKey:kUid] intValue] == [[[DataManager shared].currentUserBody objectForKey:kUid] intValue]){
    }
}*/

// touch action
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if([target respondsToSelector:action]){
        [target performSelector:action withObject:self];
    }
}

- (void)dealloc
{
    [annotation release];
    [super dealloc];
}

@end
