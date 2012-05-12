//
//  UserAnnotation.h
//  Vkmsg
//
//  Created by Igor Khomenko on 3/28/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Map Annotation class */
@interface UserAnnotation : NSObject <MKAnnotation>{
}

@property (nonatomic, retain) NSString *userPhotoUrl;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userStatus;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSUInteger vkUserId;
@property (nonatomic, assign) NSUInteger geoDataID;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSDictionary *vkUser;

@end
