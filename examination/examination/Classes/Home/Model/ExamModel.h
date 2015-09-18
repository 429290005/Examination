//
//  ExamModel.h
//  examination
//
//  Created by 李晓 on 15/9/15.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatalogModel.h"
#import "ExamData.h"

@interface ExamModel : NSObject

@property (nonatomic,copy) NSString *id;

@property (nonatomic,copy) NSString *info;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *term;

@property (nonatomic,strong) NSArray *catalog;

@end
