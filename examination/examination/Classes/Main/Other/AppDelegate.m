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
#import "NotWiFiViewController.h"

@interface AppDelegate ()
{
    NotWiFiViewController *notWifi;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 存储UUID 保证唯一性
    if(![CHKeychainTool load:KEY_DEVICE_UUID]){
        [CHKeychainTool save:KEY_DEVICE_UUID data:[SystemDeviceTool getUUID]];
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor: kRGBColor(238, 238, 238, 1)];
    
    LXFrameWorkInstance *instance = [LXFrameWorkInstance sharedLXFrameWorkInstance];
    instance.NavigationBar_bgColor = kRGBColor(84, 176, 220, 1);
    instance.NavigationBar_textColor = [UIColor whiteColor];
    instance.backState = writeBase;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self showWhat];
    return YES;
}

- (void) showWhat
{
    // 上架到appStore 打开这段
    [self applicationShowAuth];
    notWifi = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"NotWiFiViewController"];
    self.window.rootViewController = notWifi;
    [self.window makeKeyAndVisible];
    
    // 需要授权码登录
    //    [self userAccurateLogin];
    
    // 使用测试账号直接登录
    //    [self shaBiAppleChecking];
    
    // 改为登陆的方式
    //    UserLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateInitialViewController];
    //    self.window.rootViewController = loginVC;
    //    self.navigationController = (UINavigationController *)loginVC;
    //    [self.window makeKeyAndVisible];
    
}

- (void) applicationShowAuth
{
    [SkywareHttpTool HttpToolGetWithUrl:showStatus paramesers:nil requestHeaderField:nil SuccessJson:^(id json) {
        SkywareResult *result = [SkywareResult objectWithKeyValues:json];
        if ([result.message isEqualToString:@"200"]) {
            NSDictionary *dict = result.result;
            BOOL flag = [dict[@"status"] boolValue];
            // YES : 走正常的用户登陆 NO：Apple正在审核
            if (flag) {
                [self userAccurateLogin];
            }else{
                [self shaBiAppleChecking];
            }
        }else{
            notWifi.activity.hidden = YES;
            [SVProgressHUD showErrorWithStatus:@"网络不给力请稍后重试"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        notWifi.activity.hidden = YES;
        [SVProgressHUD showErrorWithStatus:@"网络不给力请稍后重试"];
        //        AuthViewController *authVC = [[UIStoryboard storyboardWithName:@"Auth" bundle:nil] instantiateInitialViewController];
        //        self.window.rootViewController = authVC;
        //        self.navigationController = (UINavigationController *)authVC;
        //        [self.window makeKeyAndVisible];
        
    }];
}

- (void) shaBiAppleChecking{
    Instance *instance = [Instance sharedInstance];
    instance.isAssessor = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kTestAuth forKey:@"auth_code"];
    [params setObject:kTestUDID forKey:@"device"];
    [self applicationLoginWithParmas:params];
}

- (void) userAccurateLogin{
    Instance *instance = [Instance sharedInstance];
    instance.isAssessor = NO;
    if ([CHKeychainTool load:KEY_APP_AUCH_CODE]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *UUID = [NSString stringWithFormat:@"%@",[CHKeychainTool load:KEY_DEVICE_UUID]];
        NSString *Code = [NSString stringWithFormat:@"%@",[CHKeychainTool load:KEY_APP_AUCH_CODE]];
        [params setObject:Code forKey:@"auth_code"];
        [params setObject:UUID forKey:@"device"];
        [self applicationLoginWithParmas:params];
    }else{
        AuthViewController *authVC = [[UIStoryboard storyboardWithName:@"Auth" bundle:nil] instantiateInitialViewController];
        self.window.rootViewController = authVC;
        self.navigationController = (UINavigationController *)authVC;
        [self.window makeKeyAndVisible];
    }
}

- (void) applicationLoginWithParmas:(NSDictionary *) params
{
    [SVProgressHUD showWithStatus:@"正在登录"];
    [SkywareHttpTool HttpToolPostWithUrl:login paramesers:params requestHeaderField:nil SuccessJson:^(id json) {
        SkywareResult *result = [SkywareResult objectWithKeyValues:json];
        if ([result.message isEqualToString:@"200"]) {
            Instance *instance = [Instance sharedInstance];
            instance.token = result.token;
            HomeViewController *home = [[UIStoryboard storyboardWithName:@"Home" bundle:nil]instantiateInitialViewController];
            self.window.rootViewController = home;
            self.navigationController = (UINavigationController *)home;
            [self.window makeKeyAndVisible];
        }else{
            //            AuthViewController *authVC = [[UIStoryboard storyboardWithName:@"Auth" bundle:nil] instantiateInitialViewController];
            //            self.window.rootViewController = authVC;
            //            self.navigationController = (UINavigationController *)authVC;
            //            [self.window makeKeyAndVisible];
            [SVProgressHUD showErrorWithStatus:@"网络不给力请稍后重试"];
            notWifi.activity.hidden = YES;
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络不给力请稍后重试"];
        notWifi.activity.hidden = YES;
    }];
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
