//
//  AboutViewController.m
//  examination
//
//  Created by 李晓 on 15/9/18.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *info;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"关于我们"];
    //    [self getAboutInfo];
}

- (void)getAboutInfo
{
    Instance *instance = [Instance sharedInstance];
    [SVProgressHUD show];
    [SkywareHttpTool HttpToolGetWithUrl:infoURL paramesers:nil requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        SkywareResult *result = [SkywareResult objectWithKeyValues:json];
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
}


@end
