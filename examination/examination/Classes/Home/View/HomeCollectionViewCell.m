//
//  HomeCollectionViewCell.m
//  examination
//
//  Created by 李晓 on 15/9/15.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@interface HomeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *course_name;

@property (weak, nonatomic) IBOutlet UILabel *exam_term;

@end

@implementation HomeCollectionViewCell

- (void)awakeFromNib
{
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
}


- (void)setModel:(CourseModel *)model
{
    _model = model;
    if ([model.exam_status isEqualToString:@"1"]) {
        self.backgroundColor= kExam_Status_UnripeBackageColor;
    }else if ([model.exam_status isEqualToString:@"2"]){
        self.backgroundColor= kExam_Status_SuccessBackageColor;
    }else if ([model.exam_status isEqualToString:@"3"]){
        self.backgroundColor= kExam_Status_LockBackageColor;
    }
    self.course_name.text = model.course_name;
    self.exam_term.text = [NSString stringWithFormat:@"%@期",model.exam_term];
}


@end
