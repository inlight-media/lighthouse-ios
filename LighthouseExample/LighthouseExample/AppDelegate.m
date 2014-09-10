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
    [LighthouseManager enableLogging];

	// Disable transmissions (you could do this for development or if a user doesnt want their data collected)
    //[LighthouseManager disableTransmission];

    // Enable production when you are ready to deploy, you can also use Preprocessor Macros to control this for instance.
    //[LighthouseManager enableProduction];

    // Configure the manager using Lighthouse keys
    [[LighthouseManager sharedInstance] configure:@{
        @"appId": @"533bb440d3384b8a6a000012",
		@"appKey": @"047b62e5346236896c2eca2e8407f1f59cde7646",
		@"appToken": @"7cdfd231f223e75e8cf4e927ccc0be4c2031598f",
		@"appVersion": @"iPhone-1.0"
    }];

    // Start monitoring
    [[LighthouseManager sharedInstance] launch];

	// Read the settings on startup (NOTE: This value could be nil because settings are loaded asynchronously)
	NSLog(@"Check settings at the start %@", [[LighthouseManager sharedInstance] settings]);

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
	[[LighthouseManager sharedInstance] subscribe:@"LighthouseDidUpdateSettings" observer:self selector:@selector(didUpdateSettings:)];

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

	// You can now show a UIView or other UI element showing the user the campaign.

	// You can then trigger a "campaign action" when the user clicks a button for instance to record how many people
	// have see and performed an action on the campaign. For the moment we just wait 15 seconds before triggering
	[NSTimer scheduledTimerWithTimeInterval:15 target:[LighthouseManager sharedInstance] selector:@selector(campaignActioned:) userInfo:data repeats:NO];
	
	NSDictionary *notification = [[[LighthouseManager sharedInstance] notifications] lastObject];
	[[LighthouseManager sharedInstance] campaignActioned:notification];
}

- (void)didUpdateSettings:(NSDictionary *)data {
	NSLog(@"didUpdateSettings %@", data);
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
