//
//  SimpleMapAnnotation.h
//  Vkmsg
//
//  Created by Igor Khomenko on 4/16/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleMapAnnotation : NSObject <MKAnnotation>{
    CLLocationCoordinate2D coordinate;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
