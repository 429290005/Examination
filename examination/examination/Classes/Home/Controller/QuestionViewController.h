//
//  QuestionViewController.h
//  examination
//
//  Created by 李晓 on 15/9/17.
//  Copyright (c) 2015年 exam. All rights reserved.
//
#import "ExamModel.h"

@interface QuestionViewController : BaseViewController

@property (nonatomic,strong) ExamData *data;
/**
 *  HeadView 使用
 */
@property (nonatomic,strong) ExamModel *examModel;
/**
 *  第几部分
 */
@property (nonatomic,assign) NSInteger unit_no;
/**
 *  第几题
 */
@property (nonatomic,assign) NSInteger quest_no;

@end
