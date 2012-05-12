//
//  TestManager.m
//  Vkmsg
//
//  Created by Igor Khomenko on 4/2/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import "TestManager.h"

static TestManager *instance = nil;

@implementation TestManager

@synthesize testLocations;

+ (TestManager *)shared {
	@synchronized (self) {
		if (instance == nil){ 
            instance = [[self alloc] init];
        }
	}
	
	return instance;
}

- (id)init {
    self = [super init];
    
    if(self) {
        // point 1
        NSString *userID1 = @"168424571"; // test user, Qbmaster Jordan
        NSArray *coord1 = [NSArray arrayWithObjects:[NSNumber numberWithDouble:60.0], [NSNumber numberWithDouble:4.0], nil];// lat, lon
        
        // point 2
        NSString *userID2 = @"6321433"; // Ros
        NSArray *coord2 = [NSArray arrayWithObjects:[NSNumber numberWithDouble:-10.0], [NSNumber numberWithDouble:33.0], nil];// lat, lon
        
        // point 3
        NSString *userID3 = @"170967724"; // Carevna Lagushka
        NSArray *coord3 = [NSArray arrayWithObjects:[NSNumber numberWithDouble:60.0], [NSNumber numberWithDouble:97.0], nil];// lat, lon
        
        // point 4
        NSString *userID4 = @"170505378"; // Tarzan
        NSArray *coord4 = [NSArray arrayWithObjects:[NSNumber numberWithDouble:63.0], [NSNumber numberWithDouble:45.0], nil];// lat, lon
        
        self.testLocations = [NSDictionary dictionaryWithObjectsAndKeys:coord1, userID1, coord2, userID2, coord3, userID3, coord4, userID4, nil];
    }
    
    return self;
}

- (void)dealloc
{
    [testLocations release];
    [super dealloc];
}

@end
