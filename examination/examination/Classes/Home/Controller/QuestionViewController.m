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
    self.unit.text = [self switchUnit:questionM.unit];
    self.Qtitle.text = [NSString stringWithFormat:@"第%@题",questionM.question_no];
    
    NSMutableAttributedString * attrTitle = [[NSMutableAttributedString alloc] initWithData:[questionM.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    __block CGFloat allImageHeight = 0.0;
    for(int i =0; i < [attrTitle length]; i++)
    {
        NSAttributedString *temp = [attrTitle attributedSubstringFromRange:NSMakeRange(i, 1)];
        [temp enumerateAttributesInRange:NSMakeRange(0, temp.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            NSTextAttachment *textAtt = [attrs objectForKey:@"NSAttachment"];
            if (textAtt) {
                if (textAtt.bounds.size.width > 300) {
                    CGSize size = [self computeScaleWithSize:textAtt.bounds.size AndMaxSize:CGSizeMake(300, 0)];
                    textAtt.bounds = CGRectMake(0, 0, size.width, size.height);
                    //                    NSLog(@"%@",NSStringFromCGSize(size));
                }
                allImageHeight += textAtt.bounds.size.height;
            }
        }];
    }
    self.Qcontent.attributedText = attrTitle;
    self.Qcontent.textAlignment  = NSTextAlignmentLeft;
    self.Qcontent.font = [UIFont systemFontOfSize:15];
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[questionM.answer dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    for(int i =0; i < [attrStr length]; i++)
    {
        NSAttributedString *temp = [attrStr attributedSubstringFromRange:NSMakeRange(i, 1)];
        [temp enumerateAttributesInRange:NSMakeRange(0, temp.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            NSTextAttachment *textAtt = [attrs objectForKey:@"NSAttachment"];
            if (textAtt) {
                if (textAtt.bounds.size.width > 300) {
                    CGSize size = [self computeScaleWithSize:textAtt.bounds.size AndMaxSize:CGSizeMake(300, 0)];
                    textAtt.bounds = CGRectMake(0, 0, size.width, size.height);
                    //                    NSLog(@"%@",NSStringFromCGSize(size));
                }
                allImageHeight += textAtt.bounds.size.height;
            }
        }];
    }
//    [attrStr insertAttributedString:[[NSAttributedString alloc] initWithString:@"试题答案:"] atIndex:0];
    [attrStr insertAttributedString:[[NSAttributedString alloc] initWithString:@"\t\t\t"] atIndex:0];
    self.answer.attributedText = attrStr;
    self.answer.textAlignment  = NSTextAlignmentLeft;
    self.answer.font = [UIFont systemFontOfSize:15];
    
    CGSize qsize = [questionM.title sizeWithFont:[UIFont systemFontOfSize:15] MaxWidth:self.view.width - 20];
    CGSize asize = [questionM.answer sizeWithFont:[UIFont systemFontOfSize:15] MaxWidth:self.view.width - 20];
    self.viewHeight.constant = qsize.height + asize.height + allImageHeight +280;
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

- (NSString *) switchUnit:(NSString *) unit
{
    NSInteger tag = [unit integerValue];
    switch (tag) {
        case 1:
        {
            return @"单选题";
        }
            break;
        case 2:
        {
            return @"多选题";
        }
            break;
        case 3:
        {
            return @"判断题";
        }
            break;
        case 4:
        {
            return @"翻译题";
        }
            break;
        case 5:
        {
            return @"简答题";
        }
            break;
        case 6:
        {
            return @"计算题";
        }
            break;
        case 7:
        {
            return @"论述题";
        }
            break;
        default:
            break;
    }
    return @"";
}

- (CGSize) computeScaleWithSize:(CGSize) size AndMaxSize:(CGSize) maxSize
{
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat scale = size.width / size.height;
    if (maxSize.width == 0 && maxSize.height != 0) {
        height = maxSize.height;
        width = height * scale;
    }
    if (maxSize.height == 0 && maxSize.width != 0){
        width = maxSize.width;
        height = width / scale;
    }
    return CGSizeMake(width, height);
}

@end
