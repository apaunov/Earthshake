//
//  AppDelegate.m
//  Earthshake
//
//  Created by Andrey Paunov on 2016-03-24.
//  Copyright © 2016 Andrey Paunov. All rights reserved.
//

#import "EarthshakeAppDelegate.h"
#import "EarthshakeModelFactory.h"
#import "EarthshakeServiceFactory.h"

@interface EarthshakeAppDelegate ()

@property (strong, nonatomic) EarthshakeModelFactory *earthshakeModelFactory;
@property (strong, nonatomic) EarthshakeServiceFactory *earthshakeServiceFactory;
@property (strong, nonatomic) EarthshakeViewControllerFactory *earthshakeViewControllerFactory;

@end

@implementation EarthshakeAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self initializeEarthshakeModelFactory];
    [self initializeEarthshakeServiceFactory];
    [self initializeEarthshakeViewControllerFactory];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Custom methods

- (void)initializeEarthshakeModelFactory
{
    self.earthshakeModelFactory = [[EarthshakeModelFactory alloc] init];
}

- (void)initializeEarthshakeServiceFactory
{
    self.earthshakeServiceFactory = [[EarthshakeServiceFactory alloc] init];
    self.earthshakeServiceFactory.earthshakeModelFactory = self.earthshakeModelFactory;
}

- (void)initializeEarthshakeViewControllerFactory
{
    self.earthshakeViewControllerFactory = [[EarthshakeViewControllerFactory alloc] init];
    self.earthshakeService = [self.earthshakeServiceFactory createEarthshakeService];       // Temporary assignment
    self.earthshakeViewControllerFactory.earthshakeService = self.earthshakeService;
}

@end