//
//  Instance.h
//  examination
//
//  Created by 李晓 on 15/9/15.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Instance : NSObject

LXSingletonH(Instance)

/*** 用户token */
@property (nonatomic,copy) NSString *token;

/*** 是否审核过程 */
@property (nonatomic,assign) BOOL isAssessor;

@end
