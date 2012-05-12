//
//  SimpleMapAnnotation.m
//  Vkmsg
//
//  Created by Igor Khomenko on 4/16/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import "SimpleMapAnnotation.h"

@implementation SimpleMapAnnotation
@synthesize coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)_coordinate{
    self = [super init];
    if(self){
        coordinate = _coordinate;
    }
    
    return self;
}

@end
