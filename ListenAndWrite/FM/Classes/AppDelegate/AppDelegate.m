//
//  AppDelegate.m
//  FM
//
//  Created by lanou3g on 15/11/25.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@end

/**
 *     typedef enum {
 *  NotReachable = 0,  //无连接
 *  ReachableViaWiFi,  //使用3G/GPRS网络
 *  ReachableViaWWAN  //使用WiFi网络
 *  } NetworkStatus;
 */

@implementation AppDelegate


- (void)reachabilityChanged:(NSNotification *)note {
    Reachability *currentReach = [note object];
    NSParameterAssert([currentReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [currentReach currentReachabilityStatus];
    NSLog(@"^^^ %ld", (long)status);

    self.isReachable = YES;
    
    if(status == NotReachable) {
        
        self.isReachable = NO;
        
    } else if (status == ReachableViaWiFi||status == ReachableViaWWAN) {
        self.isReachable = YES;
        
    }
    
    NSLog(@"^^^ %d",self.isReachable);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
    
    [self.hostReach startNotifier];

    return YES;
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
