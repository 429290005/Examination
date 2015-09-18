//
//  UserInfoViewController.m
//  examination
//
//  Created by 李晓 on 15/9/18.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoModel.h"

@interface UserInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *status;

@property (weak, nonatomic) IBOutlet UILabel *classes_name;

@property (weak, nonatomic) IBOutlet UILabel *subject_name;

@property (weak, nonatomic) IBOutlet UILabel *source;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"个人信息"];
    [self getUserInfo];
}

- (void) getUserInfo
{
    Instance *instance = [Instance sharedInstance];
    [SVProgressHUD show];
    [SkywareHttpTool HttpToolGetWithUrl:user paramesers:nil requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        SkywareResult *result = [SkywareResult objectWithKeyValues:json];
        UserInfoModel *userinfo = [UserInfoModel objectWithKeyValues:result.result];
        [self setViewInfoWithUserInfo:userinfo];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
}

- (void)setViewInfoWithUserInfo:(UserInfoModel *) userinfo
{
    NSInteger state = [userinfo.status integerValue];
    self.status.text = state == 1 ? @"已锁定" : @"正常";
    self.classes_name.text = userinfo.classes_name;
    self.subject_name.text = userinfo.subject_name;
    self.source.text = userinfo.course;
}


@end
