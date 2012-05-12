//
//  MobserEngineSettingsManager.h
//  Mobserv
//
//  Created by Mikhail Asavkin on 02.01.11.
//  Copyright 2011 YAS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MobservEngineSettingsManager : NSObject {

}
+ (void)setLogLevel:(enum MBLogLevel)logLevel;
+ (enum MBLogLevel)logLevel;
@end
