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
#import "UserLoginViewController.h"
#import "AuthViewController.h"

@interface UserMenuViewController ()

@end

@implementation UserMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"菜单"];
    
    BaseArrowCellItem *userItem = [BaseArrowCellItem  createBaseCellItemWithIcon:nil AndTitle:@"个人信息" SubTitle:nil ClickOption:^{
        UserInfoViewController *userInfo = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
        [self.navigationController pushViewController:userInfo animated:YES];
    }];
    
    BaseArrowCellItem *aboutWe = [BaseArrowCellItem  createBaseCellItemWithIcon:nil AndTitle:@"关于我们" SubTitle:nil ClickOption:^{
        AboutViewController *about = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutViewController"];
        [self.navigationController pushViewController:about animated:YES];
    }];
    
    BaseCenterTitleCellItem *centerItem = [BaseCenterTitleCellItem createBaseCellItemWithCenterTitle:@"退出登录" ClickOption:^{
        Instance *instance = [Instance sharedInstance];
        [SVProgressHUD show];
        [SkywareHttpTool HttpToolDeleteWithUrl:authcode paramesers:nil requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
            SkywareResult *result = [SkywareResult objectWithKeyValues:json];
            if ([result.message isEqualToString:@"200"]) {
                [CHKeychainTool delete:KEY_APP_AUCH_CODE];
                //                UserLoginViewController *userVC = (UserLoginViewController *) [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
                AuthViewController *authVC = [[UIStoryboard storyboardWithName:@"Auth" bundle:nil] instantiateInitialViewController];
                [UIWindow changeWindowRootViewController:authVC animated:YES];
            }
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
            
        }];
        
    } WithColor:[UIColor redColor]];
    
    BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithItem:@[userItem,aboutWe,centerItem]];
    
    [self.dataList addObject:group1];
}


@end