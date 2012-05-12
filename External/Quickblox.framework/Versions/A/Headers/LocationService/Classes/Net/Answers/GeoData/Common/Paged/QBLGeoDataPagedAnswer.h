//
//  QBLGeoDataPagedAnswer.h
//  LocationService
//
//  Created by Igor Khomenko on 2/3/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBLGeoDataPagedAnswer : QBLocationServicePagedAnswer{
	QBUUserAnswer *userAnswer;
	QBLGeoData *currentItem;
	NSMutableArray *geodatas;
}

@property (nonatomic, retain) NSMutableArray *geodatas;
@property (nonatomic, assign) QBLGeoData *currentItem;

@end
