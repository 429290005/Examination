//
//  QuestionViewController.m
//  examination
//
//  Created by 李晓 on 15/9/17.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import "QuestionViewController.h"
#import "ExamTableHeadView.h"
#import "QuestionModel.h"

@interface QuestionViewController ()
{
    NSInteger _currentUnit;
    NSInteger _currentQuestion;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UILabel *Qtitle;
@property (weak, nonatomic) IBOutlet UILabel *Qcontent;
@property (weak, nonatomic) IBOutlet UILabel *unit;
@property (weak, nonatomic) IBOutlet UILabel *answer;
@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"我的考题"];
    [self getQuestionDataWithid:self.data.id];
    [self setHeadView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _currentUnit = self.unit_no;
    _currentQuestion = self.quest_no;
}

- (void)getQuestionDataWithid:(NSString *)question_id
{
    [SVProgressHUD show];
    Instance *instance = [Instance sharedInstance];
    [SkywareHttpTool HttpToolGetWithUrl:question paramesers:@[question_id] requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        SkywareResult *result = [SkywareResult objectWithKeyValues:json];
        NSArray *requestArray = result.result;
        QuestionModel *questionM = [QuestionModel objectWithKeyValues: [requestArray firstObject]];
        [self setViewData:questionM];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
}

- (void) setHeadView
{
    ExamTableHeadView *headView = [ExamTableHeadView createExamTableHeadView];
    headView.frame = CGRectMake(0, 64, kWindowWidth, headView.height);
    headView.examModel = self.examModel;
    [self.view addSubview:headView];
}

- (void) setViewData:(QuestionModel *) questionM
{
    self.Qtitle.text = [NSString stringWithFormat:@"第%@题",questionM.question_no];
    self.Qcontent.text = questionM.title;
    self.unit.text = [NSString stringWithFormat:@"第%@部分",questionM.unit];
    self.answer.text = questionM.answer;
    
    CGSize qsize = [questionM.title sizeWithFont:[UIFont systemFontOfSize:15] MaxWidth:self.view.width - 20];
    CGSize asize = [questionM.answer sizeWithFont:[UIFont systemFontOfSize:15] MaxWidth:self.view.width - 110];
    
    self.viewHeight.constant = qsize.height + asize.height + 300;
    
    [self updateViewConstraints];
}

- (IBAction)goExamBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rootViewBtnClick:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)upQuestionBtnClick:(UIButton *)sender {
    NSArray *array =  self.examModel.catalog; // 全部部分
    CatalogModel *catalog =  array[_currentUnit];  // 当前部分
    NSArray *dataArray = catalog.data; // 当前题Array
    
    if (_currentQuestion <= 0) { // 第一题不能在上
        if (_currentUnit <= 0) {
            [SVProgressHUD showInfoWithStatus:@"已经是第一题"];
        }else{
            CatalogModel *catalog =  array[--_currentUnit]; // 取上一部分
            NSArray *nextQuestArray = catalog.data; // 上一部分题Array
            _currentQuestion = nextQuestArray.count -1; // 从最后一个开始
            ExamData *Edata = nextQuestArray[_currentQuestion];
            [self getQuestionDataWithid:Edata.id];
        }
    }else{
        ExamData *Edata = dataArray[--_currentQuestion];
        [self getQuestionDataWithid:Edata.id];
    }
}

- (IBAction)downQuestionBtnClick:(UIButton *)sender {
    NSArray *array =  self.examModel.catalog; // 全部部分
    CatalogModel *catalog =  array[_currentUnit];  // 当前部分
    NSArray *dataArray = catalog.data; // 当前题Array
    NSInteger countUnit = array.count;  // 总部分数量
    
    if (_currentQuestion >= dataArray.count -1) {  // 该部分最后一题
        if (_currentUnit >= countUnit -1) {  // 已经最后一部分
            [SVProgressHUD showInfoWithStatus:@"已经是最后一题"];
            return;
        }else{
            _currentQuestion = 0; // 从第一个开始
            CatalogModel *catalog =  array[++_currentUnit]; // 取下一部分
            NSArray *nextQuestArray = catalog.data; // 下一部分题Array
            ExamData *Edata = nextQuestArray[_currentQuestion];
            [self getQuestionDataWithid:Edata.id];
        }
    }else{
        ExamData *Edata = dataArray[++_currentQuestion ];
        [self getQuestionDataWithid:Edata.id];
    }
}

@end
