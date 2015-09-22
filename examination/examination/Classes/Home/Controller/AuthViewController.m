//
//  AuthViewController.m
//  examination
//
//  Created by 李晓 on 15/9/14.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import "AuthViewController.h"
#import "HomeViewController.h"
#import "CHKeychainTool.h"

@interface AuthViewController ()
@property (weak, nonatomic) IBOutlet UITextField *authCodeLabel;

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"设备授权"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)authBtnClick:(UIButton *)sender {
    if (!self.authCodeLabel.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入授权码"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *UUID = [NSString stringWithFormat:@"%@",[CHKeychainTool load:KEY_DEVICE_UUID]];
    [params setObject:self.authCodeLabel.text forKey:@"auth_code"];
    [params setObject:UUID forKey:@"device"];
    [SVProgressHUD show];
    [SkywareHttpTool HttpToolPostWithUrl:authcode paramesers:params requestHeaderField:nil SuccessJson:^(id json) {
        SkywareResult *result = [SkywareResult objectWithKeyValues:json];
        if ([result.message isEqualToString:@"200"]) {
            [CHKeychainTool save:KEY_APP_AUCH_CODE data:self.authCodeLabel.text];
            
            Instance *instance = [Instance sharedInstance];
            instance.token = result.token;
            
            HomeViewController *home = [[UIStoryboard storyboardWithName:@"Home" bundle:nil]instantiateInitialViewController];
            [UIWindow changeWindowRootViewController:home animated:YES];
        }else if ([result.message isEqualToString:@"412"]){
            [SVProgressHUD showErrorWithStatus:@"该授权码已经绑定过"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"授权码有误,请重新输入"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"授权错误，请联系管理员"];
    }];
}





@end
