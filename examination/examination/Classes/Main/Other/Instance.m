//
//  Instance.m
//  examination
//
//  Created by 李晓 on 15/9/15.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import "Instance.h"

@implementation Instance

LXSingletonM(Instance)



- (NSString *)token
{
    if (!_token) {
        return @"";
    }else{
        return _token;
    }
}

@end
