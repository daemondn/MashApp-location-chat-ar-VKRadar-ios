//
//  ServiceDescription.h
//  BaseServiceStaticLibrary
//

//  Copyright 2010 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServiceDescription : NSObject {

}
+ (NSString*)serviceEndpointURL;
+ (NSString*)serviceHost;
+ (NSString*)serviceName;
+ (enum ServiceZone)zone;
+ (void)setServiceZone:(enum ServiceZone)zone;
+ (void)setDomain:(NSString*)domain;
+ (void)setDomain:(NSString*)domain forZone:(enum ServiceZone)zone;
@end
