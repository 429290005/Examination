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
#import "RegisterUserController.h"

@interface UserLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *login_name;
@property (weak, nonatomic) IBOutlet UITextField *login_pwd;

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"用户登录"];
    [self showRegisterBtn];
}

- (void) showRegisterBtn
{
    [SkywareHttpTool HttpToolGetWithUrl:showStatus paramesers:nil requestHeaderField:nil SuccessJson:^(id json) {
        SkywareResult *result = [SkywareResult objectWithKeyValues:json];
        if ([result.message isEqualToString:@"200"]) {
            NSDictionary *dict = result.result;
            BOOL flag = [dict[@"status"] boolValue];
            // YES : 走正常的用户登陆 NO：Apple正在审核
            if (flag) {
                self.registerBtn.hidden = YES;
            }else{
                self.registerBtn.hidden = NO;
            }
        }else{
            self.registerBtn.hidden = NO;
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        self.registerBtn.hidden = NO;
    }];
}

- (IBAction)btnClick:(UIButton *)sender {
    NSString *name = self.login_name.text;
    NSString *pwd = self.login_pwd.text;
    
    if (!name.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    if (!pwd.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *UUID = [NSString stringWithFormat:@"%@",[CHKeychainTool load:KEY_DEVICE_UUID]];
    [params setObject:pwd forKey:@"auth_code"];
    [params setObject:UUID forKey:@"device"];
    [SVProgressHUD show];
    [SkywareHttpTool HttpToolPostWithUrl:authcode paramesers:params requestHeaderField:nil SuccessJson:^(id json) {
        SkywareResult *result = [SkywareResult objectWithKeyValues:json];
        if ([result.message isEqualToString:@"200"]) {
            [CHKeychainTool save:KEY_APP_AUCH_CODE data:pwd];
            
            Instance *instance = [Instance sharedInstance];
            instance.token = result.token;
            
            HomeViewController *home = [[UIStoryboard storyboardWithName:@"Home" bundle:nil]instantiateInitialViewController];
            [UIWindow changeWindowRootViewController:home animated:YES];
        }else if ([result.message isEqualToString:@"412"]){
            //            [SVProgressHUD showErrorWithStatus:@"该授权码已经绑定过"];
            [SVProgressHUD showErrorWithStatus:@"密码输入有误,请重新输入"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"密码输入有误,请重新输入"];
            //            [SVProgressHUD showErrorWithStatus:@"授权码有误,请重新输入"];
        }
    } failure:^(NSError *error) {
        //        [SVProgressHUD showErrorWithStatus:@"授权错误，请联系管理员"];
        [SVProgressHUD showErrorWithStatus:@"用户名或密码错误"];
    }];
}

- (IBAction)registerUser:(UIButton *)sender {
    
    RegisterUserController *userVC = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateViewControllerWithIdentifier:@""];
    [self.navigationController pushViewController:userVC animated:YES];
    
}

@end
