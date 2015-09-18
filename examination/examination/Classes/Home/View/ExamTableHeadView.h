//
//  ExamTableHeadView.h
//  examination
//
//  Created by 李晓 on 15/9/17.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamModel.h"

@interface ExamTableHeadView : UIView

@property (nonatomic,strong) ExamModel *examModel;

+ (instancetype) createExamTableHeadView;

@end
