//
//  AppDelegate.m
//  LighthouseExample
//
//  Created by Benjamin Pearson on 26/03/14.
//  Copyright (c) 2014 Lighthouse. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	[self.window setRootViewController:[[UIViewController alloc] init]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

	// Enable logging (optional)
    //[LighthouseManager enableLogging];

	// Disable transmissions (you could do this for development or if a user doesnt want their data collected)
    //[LighthouseManager disableTransmission];

    // Enable production when you are ready to deploy, you can also use Preprocessor Macros to control this for instance.
    //[LighthouseManager enableProduction];

    // Configure the manager using Lighthouse keys
    [[LighthouseManager sharedInstance] configure:@{
        @"appId": @"53292c768d8e1e0b5a00000b",
		@"appKey": @"78a8956f40c43603364783721cd261c74285bf9e",
		@"appToken": @"8c9c72a2e45aa7e80af6cac981d87d9cf610906f",
		@"appVersion": @"iPhone-1.0",
		@"uuids": @[@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
    }];

    // Start monitoring
    [[LighthouseManager sharedInstance] launch];

    // Request permission (you can do this whenever you like - it will ask user for location permission - possibly you want to wait until they reach a certain section of your app)
	// To fire immediately
	// [[LighthouseManager sharedInstance] requestPermission];
	// In this example we have delayed the permission request by 5 seconds
	[NSTimer scheduledTimerWithTimeInterval:5 target:[LighthouseManager sharedInstance] selector:@selector(requestPermission) userInfo:nil repeats:NO];


    // Request push notification permission (you can do this whenever you like - it will ask user for push notification permission - possibly you want to wait until they reach a certain section of your app)
	// To fire immediately
	// [[LighthouseManager sharedInstance] requestPushNotifications];
	// In this example we have delayed the permission request by 15 seconds
	[NSTimer scheduledTimerWithTimeInterval:15 target:[LighthouseManager sharedInstance] selector:@selector(requestPushNotifications) userInfo:nil repeats:NO];

	// Listen to notifications from Lighthouse
	[[LighthouseManager sharedInstance] subscribe:@"LighthouseDidEnterBeacon" observer:self selector:@selector(didEnterBeacon:)];
	[[LighthouseManager sharedInstance] subscribe:@"LighthouseDidExitBeacon" observer:self selector:@selector(didExitBeacon:)];
	[[LighthouseManager sharedInstance] subscribe:@"LighthouseDidRangeBeacon" observer:self selector:@selector(didRangeBeacon:)];
	[[LighthouseManager sharedInstance] subscribe:@"LighthouseDidReceiveNotification" observer:self selector:@selector(didReceiveNotification:)];
	[[LighthouseManager sharedInstance] subscribe:@"LighthouseDidReceiveCampaign" observer:self selector:@selector(didReceiveCampaign:)];

	// If we have a notification in the payload get it out of launch options
	NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
	if (notification) {
		[[LighthouseManager sharedInstance] didReceiveRemoteNotification:notification];
	}

    return YES;
}

#pragma mark - Application Lifecycle

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[LighthouseManager sharedInstance] suspend];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[LighthouseManager sharedInstance] activate];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[LighthouseManager sharedInstance] terminate];
}

#pragma mark - Notification Handers

- (void)didEnterBeacon:(NSDictionary *)data {
	NSLog(@"didEnterBeacon %@", data);
}

- (void)didExitBeacon:(NSDictionary *)data {
	NSLog(@"didExitBeacon %@", data);
}

- (void)didRangeBeacon:(NSDictionary *)data {
	NSLog(@"didRangeBeacon %@", data);
}

- (void)didReceiveNotification:(NSDictionary *)data {
	NSLog(@"didReceiveNotification %@", data);
	// Retrieve detailed campaign data for the notification. This will perform async and then fire LighthouseDidReceiveCampaign event.
	[[LighthouseManager sharedInstance] campaign:data];
}

- (void)didReceiveCampaign:(NSDictionary *)data {
	NSLog(@"didReceiveCampaign %@", data);
}

#pragma mark - Push Notifications

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	NSLog(@"application:didReceiveRemoteNotification");
	[[LighthouseManager sharedInstance] didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken);
	[[LighthouseManager sharedInstance] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
	NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", err);
	[[LighthouseManager sharedInstance] didRegisterForRemoteNotificationsWithDeviceToken:nil];
}

@end
