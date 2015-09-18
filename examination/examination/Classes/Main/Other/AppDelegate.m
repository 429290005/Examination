//
//  AppDelegate.m
//  examination
//
//  Created by 李晓 on 15/9/7.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "AuthViewController.h"
#import "CHKeychainTool.h"
#import "SystemDeviceTool.h"
#import "UserLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    if ([CHKeychainTool load:KEY_APP_AUCH_CODE]) {
        UserLoginViewController *userVC = (UserLoginViewController *) [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
        self.window.rootViewController = userVC;
        self.navigationController = (UINavigationController *)userVC;
    }else{
        AuthViewController *authVC = [[UIStoryboard storyboardWithName:@"Auth" bundle:nil] instantiateInitialViewController];
        self.window.rootViewController = authVC;
        self.navigationController = (UINavigationController *)authVC;
    }
    [self.window makeKeyAndVisible];
    
    LXFrameWorkInstance *instance = [LXFrameWorkInstance sharedLXFrameWorkInstance];
    instance.NavigationBar_bgColor = kRGBColor(84, 176, 220, 1);
    instance.NavigationBar_textColor = [UIColor whiteColor];
    instance.backState = writeBase;
    
    
    // 存储UUID 保证唯一性
    if(![CHKeychainTool load:KEY_DEVICE_UUID]){
        [CHKeychainTool save:KEY_DEVICE_UUID data:[SystemDeviceTool getUUID]];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
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
