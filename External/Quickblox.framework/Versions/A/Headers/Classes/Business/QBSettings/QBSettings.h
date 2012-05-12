//
//  MobserEngineSettingsManager.h
//  Core
//

//  Copyright 2011 QuickBlox team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBSettings : NSObject {

}

#pragma mark Logging

+ (void)setLogLevel:(enum QBLogLevel)logLevel;
+ (enum QBLogLevel)logLevel;

#pragma mark -

#pragma mark Server settings

+ (NSString*)ServerDomainTemplate;
+ (void)setServerDomainTemplate:(NSString*)domainTemplate;

#pragma mark -

#pragma mark Service Zones and URLs

+ (enum ServiceZone)zoneForService:(NSString*)serviceName;
+ (void)setZone:(enum ServiceZone)zone forService:(NSString*)serviceName;

+ (NSString*)currentDomainForService:(NSString*)serviceName;
+ (NSString*)domainForService:(NSString*)serviceName;
+ (void)setDomain:(NSString*)domain forService:(NSString*)serviceName;

+ (NSString*)domainOfZone:(enum ServiceZone)zone forService:(NSString*)serviceName;
+ (void)setDomain:(NSString*)domain ofZone:(enum ServiceZone)zone forService:(NSString*)serviceName;

+ (NSMutableDictionary*)servicesInfo;
+ (NSArray*)services;

#pragma mark -

#pragma mark Defaults

+ (void)loadDefaults;

#pragma mark -

@end
