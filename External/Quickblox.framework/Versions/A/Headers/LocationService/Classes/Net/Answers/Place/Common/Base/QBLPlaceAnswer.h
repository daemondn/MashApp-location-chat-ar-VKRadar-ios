//
//  QBLPlaceAnswer.h
//  LocationService
//
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBLPlaceAnswer : QBLocationServiceAnswer{
@protected
	QBLPlace *placeData;
}

@property (nonatomic, readonly) QBLPlace *placeData;

@end
