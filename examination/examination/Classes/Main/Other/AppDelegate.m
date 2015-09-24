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
    
    // 存储UUID 保证唯一性
    if(![CHKeychainTool load:KEY_DEVICE_UUID]){
        [CHKeychainTool save:KEY_DEVICE_UUID data:[SystemDeviceTool getUUID]];
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    LXFrameWorkInstance *instance = [LXFrameWorkInstance sharedLXFrameWorkInstance];
    instance.NavigationBar_bgColor = kRGBColor(84, 176, 220, 1);
    instance.NavigationBar_textColor = [UIColor whiteColor];
    instance.backState = writeBase;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    if ([CHKeychainTool load:KEY_APP_AUCH_CODE]) {
        //        UserLoginViewController *userVC = (UserLoginViewController *) [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
        //        self.window.rootViewController = userVC;
        //        self.navigationController = (UINavigationController *)userVC;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *UUID = [NSString stringWithFormat:@"%@",[CHKeychainTool load:KEY_DEVICE_UUID]];
        NSString *Code = [NSString stringWithFormat:@"%@",[CHKeychainTool load:KEY_APP_AUCH_CODE]];
        [params setObject:Code forKey:@"auth_code"];
        [params setObject:UUID forKey:@"device"];
        [SVProgressHUD showWithStatus:@"正在登录"];
        [SkywareHttpTool HttpToolPostWithUrl:login paramesers:params requestHeaderField:nil SuccessJson:^(id json) {
            SkywareResult *result = [SkywareResult objectWithKeyValues:json];
            if ([result.message isEqualToString:@"200"]) {
                Instance *instance = [Instance sharedInstance];
                instance.token = result.token;
                HomeViewController *home = [[UIStoryboard storyboardWithName:@"Home" bundle:nil]instantiateInitialViewController];
                self.window.rootViewController = home;
                self.navigationController = (UINavigationController *)home;
            }else{
                AuthViewController *authVC = [[UIStoryboard storyboardWithName:@"Auth" bundle:nil] instantiateInitialViewController];
                self.window.rootViewController = authVC;
                self.navigationController = (UINavigationController *)authVC;
            }
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        AuthViewController *authVC = [[UIStoryboard storyboardWithName:@"Auth" bundle:nil] instantiateInitialViewController];
        self.window.rootViewController = authVC;
        self.navigationController = (UINavigationController *)authVC;
    }
    [self.window makeKeyAndVisible];

    
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:NO];
    [app setStatusBarStyle:UIStatusBarStyleLightContent];
    
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
