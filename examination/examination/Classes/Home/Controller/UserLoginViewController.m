//
//  UserLoginViewController.m
//  examination
//
//  Created by 李晓 on 15/9/15.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import "UserLoginViewController.h"
#import "HomeViewController.h"
#import "CHKeychainTool.h"

@interface UserLoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *auth_code;

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"用户登录"];
    NSString *Code = [NSString stringWithFormat:@"%@",[CHKeychainTool load:KEY_APP_AUCH_CODE]];
    self.auth_code.text = Code;
    [self btnClick:nil];
}

- (IBAction)btnClick:(UIButton *)sender {
    
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
            [UIWindow changeWindowRootViewController:home animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"登录失败,请稍后重试"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

@end
