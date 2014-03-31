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

    // Enable NSNotification events to be transmitted on enter/exit/range (optional)
    [LighthouseManager enableNotifications];

	// Disable transmissions (you could do this for development or if a user doesnt want their data collected)
    //[LighthouseManager disableTransmission];

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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBeacon:) name:@"LighthouseDidEnterBeacon" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didExitBeacon:) name:@"LighthouseDidExitBeacon" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRangeBeacon:) name:@"LighthouseDidRangeBeacon" object:nil];
	
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

- (void)didEnterBeacon:(NSNotification *)notification {
	NSLog(@"didEnterBeacon %@", notification.userInfo);
}

- (void)didExitBeacon:(NSNotification *)notification {
	NSLog(@"didExitBeacon %@", notification.userInfo);
}

- (void)didRangeBeacon:(NSNotification *)notification {
	NSLog(@"didRangeBeacon %@", notification.userInfo);
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