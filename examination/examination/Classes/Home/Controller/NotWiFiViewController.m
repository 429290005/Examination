//
//  NotWiFiViewController.m
//  examination
//
//  Created by 李晓 on 16/1/11.
//  Copyright © 2016年 exam. All rights reserved.
//

#import "NotWiFiViewController.h"

@interface NotWiFiViewController ()

@end

@implementation NotWiFiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.activity.hidden = NO;
    AppDelegate  *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate showWhat];
}

@end
