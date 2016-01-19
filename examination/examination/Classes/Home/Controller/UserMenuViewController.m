//
//  UserMenuViewController.m
//  examination
//
//  Created by 李晓 on 15/9/18.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import "UserMenuViewController.h"
#import "UserInfoViewController.h"
#import "AboutViewController.h"
#import "AuthViewController.h"
#import "UserLoginViewController.h"

@interface UserMenuViewController ()<UIAlertViewDelegate>

@end

@implementation UserMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"菜单"];
    
    BaseArrowCellItem *userItem = [BaseArrowCellItem  createBaseCellItemWithIcon:nil AndTitle:@"个人信息" SubTitle:nil ClickOption:^{
        UserInfoViewController *userInfo = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
        [self.navigationController pushViewController:userInfo animated:YES];
    }];
    
    //    BaseArrowCellItem *aboutWe = [BaseArrowCellItem  createBaseCellItemWithIcon:nil AndTitle:@"关于我们" SubTitle:nil ClickOption:^{
    //        AboutViewController *about = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutViewController"];
    //        [self.navigationController pushViewController:about animated:YES];
    //    }];
    Instance *instance = [Instance sharedInstance];
    if (instance.isAssessor) {
        BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithItem:@[userItem]];
        [self.dataList addObject:group1];
    }else{
        BaseCenterTitleCellItem *centerItem = [BaseCenterTitleCellItem createBaseCellItemWithCenterTitle:@"解除绑定" ClickOption:^{
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要解除绑定" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
        } WithColor:[UIColor redColor]];
        BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithItem:@[userItem,centerItem]];
        [self.dataList addObject:group1];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [SVProgressHUD show];
        Instance *instance = [Instance sharedInstance];
        [SkywareHttpTool HttpToolDeleteWithUrl:authcode paramesers:nil requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
            SkywareResult *result = [SkywareResult objectWithKeyValues:json];
            if ([result.message isEqualToString:@"200"]) {
                [CHKeychainTool delete:KEY_APP_AUCH_CODE];
                                AuthViewController *authVC = [[UIStoryboard storyboardWithName:@"Auth" bundle:nil] instantiateInitialViewController];
//                UserLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateInitialViewController];
                [UIWindow changeWindowRootViewController:authVC animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"退出失败，请稍后重试"];
            }
        } failure:^(NSError *error) {
            
            
        }];
    }
}


@end
