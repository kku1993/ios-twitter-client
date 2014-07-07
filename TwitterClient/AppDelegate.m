//
//  AppDelegate.m
//  TwitterClient
//
//  Created by Kevin Ku on 7/6/14.
//  Copyright (c) 2014 Kevin Ku. All rights reserved.
//

#import "AppDelegate.h"
#import "LogInViewController.h"
#import "TimelineViewController.h"
#import "TwitterAPI.h"
#import "NSURL+DictionaryFromQueryString.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // check if the user is logged in already
    if(![[TwitterAPI instance] isLoggedIn]) {
        LogInViewController *vc = [[LogInViewController alloc] init];
        self.window.rootViewController = vc;
    }
    else
        [self showTimeline];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSDictionary *parameters = [url DictionaryFromQueryString];
    if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
        // successfully obtained oauth access token
        [[TwitterAPI instance]
         fetchAccessTokenWithPath:@"/oauth/access_token"
         method:@"POST"
         requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
         success:^(BDBOAuthToken *accessToken){
             NSLog(@"Got access token");
             [[TwitterAPI instance].requestSerializer saveAccessToken:accessToken];
             [self showTimeline];
         }
         failure:^(NSError *err){
             NSLog(@"failed to get access token");
         }];
    }
    return true;
}

- (void) showTimeline{
    TimelineViewController *tvc = [[TimelineViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
    self.window.rootViewController = nvc;
}

@end
