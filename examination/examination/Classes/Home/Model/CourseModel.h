//
//  CourseModel.h
//  examination
//
//  Created by 李晓 on 15/9/15.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseModel : NSObject

/**
 *  课程编码
 */
@property (nonatomic,copy) NSString *course_code;
/**
 *  试题状态
 */
@property (nonatomic,copy) NSString *exam_status;
/**
 *  课程名称
 */
@property (nonatomic,copy) NSString *course_name;
/**
 *  考题id
 */
@property (nonatomic,copy) NSString *exam_id;
/**
 *  考题学期
 */
@property (nonatomic,copy) NSString *exam_term;

@end
