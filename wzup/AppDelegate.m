//
//  AppDelegate.m
//  wzup
//
//  Created by Simen Lie on 16/02/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "AppDelegate.h"
#import "FeedViewController.h"
#import "StartViewController.h"
#import "AuthHelper.h"
#import "SearchViewController.h"
#import "PlaygroundViewController.h"
#import <NewRelicAgent/NewRelic.h>
#import "SettingsTableViewController.h"
@interface AppDelegate (){

}

@end

@implementation AppDelegate
AuthHelper *authHelper;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NewRelicAgent startWithApplicationToken:@"AA23e6b54731679b8b327c5fa411e39966732af8c2"];
    self.navigationViewController = [[NavigationViewController alloc]init];
    authHelper = [[AuthHelper alloc] init];
    //[authHelper resetCredentials];
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    
    // Override point for customization after application launch.

    if([authHelper getAuthToken] == nil){
        //[self setView:[[PlaygroundViewController alloc] init] second:@"playground"];
        [self setView:[[StartViewController alloc] init] second:@"startNav"];
    }else{
        //[self setView:[[SearchViewController alloc] init] second:@"search"];
        [self setView:[[FeedViewController alloc] init] second:@"feed2"];
        //[self setView:[[SettingsTableViewController alloc] init] second:@"settings"];
       // [self setView:[[FeedTableViewController alloc] init] second:@"FeedNavigation"];
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *str = [[[deviceToken description]
      stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    [authHelper storeDeviceId:str];
    
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}

-(void)setView:(UIViewController *)controller second:(NSString *) controllerString{
    //self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    controller = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:controllerString];
    [self.window makeKeyAndVisible];
    [self.window.rootViewController presentViewController:controller animated:NO completion:NULL];
}
- (void)showLoginView
{
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
   
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
