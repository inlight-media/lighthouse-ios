//
//  LighthouseManager.h
//  Lighthouse
//
//  Created by Benjamin Pearson on 31/12/13.
//  Copyright (c) 2013 Inlight Media. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface LighthouseManager : NSObject <CLLocationManagerDelegate, CBCentralManagerDelegate> {
	BOOL _active;
	BOOL _launched;
	BOOL _hasRequestedPermission;
	CLLocationManager *_location;
	CBCentralManager *_bluetooth;
	NSMutableDictionary *_beacons;
	NSOperationQueue *_queue;
	NSMutableDictionary *_properties;
	NSMutableDictionary *_config;
	NSTimer *_updateTimer;
	NSMutableArray *_regions;
}

+ (LighthouseManager *)sharedInstance;

#pragma mark - Lifecycle
- (void)configure:(NSDictionary *)config;
- (void)launch;
- (void)sync;
- (void)activate;
- (void)suspend;
- (void)terminate;

#pragma mark - Properties
- (void)setProperties:(NSDictionary *)properties;
- (void)addProperty:(NSString *)key value:(id)value;
- (void)removeProperty:(NSString *)key;

#pragma mark - Permission
- (void)requestPermission;
- (BOOL)hasRequestedPermission;

#pragma mark - Logging
+ (void)disableLogging;
+ (void)enableLogging;
+ (BOOL)isLoggingEnabled;

#pragma mark - Notifications
+ (void)disableNotifications;
+ (void)enableNotifications;
+ (BOOL)isNotificationsEnabled;

#pragma mark - Transmission
+ (void)disableTransmission;
+ (void)enableTransmission;
+ (BOOL)isTransmissionEnabled;

#pragma mark - Production
+ (void)disableProduction;
+ (void)enableProduction;
+ (BOOL)isProductionEnabled;

#pragma mark - List
- (NSDictionary *)beacons;
- (NSDictionary *)properties;
- (NSDictionary *)config;

#pragma mark - Push Notification Services
- (void)requestPushNotifications;
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (NSString *)pushNotificationToken;
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

@end