//
//  CHKeychainTool.h
//  examination
//
//  Created by 李晓 on 15/9/15.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const KEY_DEVICE_UUID ;
extern NSString * const KEY_USERNAME ;
extern NSString * const KEY_PASSWORD ;

@interface CHKeychainTool : NSObject

/**
 *  存储
 *
 *  @param service KEY
 *  @param data    任何形式的数据
 */
+ (void)save:(NSString *)service data:(id)data;
/**
 *  加载
 *
 *  @param service KEY
 *
 *  @return id类型数据
 */
+ (id)load:(NSString *)service;
/**
 *  删除
 *
 *  @param service KEY
 */
+ (void)delete:(NSString *)service;

@end