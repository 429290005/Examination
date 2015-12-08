//
//  RegisterUserController.m
//  examination
//
//  Created by 李晓 on 15/12/8.
//  Copyright © 2015年 exam. All rights reserved.
//

#import "RegisterUserController.h"

@interface RegisterUserController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *againPwd;

@end

@implementation RegisterUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setNavTitle:@"用户注册"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)registerBtn:(UIButton *)sender {
    if (!self.username.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    if (!self.pwd.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if (![self.pwd.text isEqualToString:self.againPwd.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        return;
    }
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:@"网络不给力，请稍后再试"];
        
    });
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
