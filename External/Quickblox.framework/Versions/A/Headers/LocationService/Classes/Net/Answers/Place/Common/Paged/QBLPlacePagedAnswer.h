//
//  QBLPlacePagedAnswer.h
//  LocationService
//
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBLPlacePagedAnswer : QBLocationServicePagedAnswer{
	QBLPlace *currentItem;
	NSMutableArray *places;
}

@property (nonatomic, retain) NSMutableArray *places;
@property (nonatomic, assign) QBLPlace *currentItem;

@end
