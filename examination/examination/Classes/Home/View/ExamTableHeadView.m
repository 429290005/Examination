//
//  ExamTableHeadView.m
//  examination
//
//  Created by 李晓 on 15/9/17.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import "ExamTableHeadView.h"

@interface ExamTableHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *info;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *term;

@end

@implementation ExamTableHeadView

+ (instancetype) createExamTableHeadView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"ExamTableHeadView" owner:nil options:nil]lastObject];
}

- (void)setExamModel:(ExamModel *)examModel
{
    _examModel = examModel;
    
    self.info.text = examModel.info;
    self.name.text = examModel.name;
    self.term.text = examModel.term;
}

@end
