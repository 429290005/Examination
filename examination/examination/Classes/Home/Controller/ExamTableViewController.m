//
//  ExamTableViewController.m
//  examination
//
//  Created by 李晓 on 15/9/15.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import "ExamTableViewController.h"
#import "QuestionViewController.h"
#import "ExamTableHeadView.h"
#import "ExamModel.h"

@interface ExamTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_catalogModel;
    ExamTableHeadView *_headView;
    ExamModel *_examM;
}
@end

@implementation ExamTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"我的试卷"];
    
    [self setUpTableHeadView];
    [self getExamData];
}

- (void)setUpTableHeadView
{
    _headView = [ExamTableHeadView createExamTableHeadView];
    self.tableView.tableHeaderView = _headView;
}

- (void)getExamData
{
    [SVProgressHUD show];
    Instance *instance = [Instance sharedInstance];
    [SkywareHttpTool HttpToolGetWithUrl:exam paramesers:@[self.exam_id] requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        SkywareResult *result = [SkywareResult objectWithKeyValues:json];
        _examM = [ExamModel objectWithKeyValues:result.result];
        _headView.examModel = _examM;
        _catalogModel = _examM.catalog;
        if (!_catalogModel.count) {
            [SVProgressHUD showInfoWithStatus:@"暂无试卷"];
        }else{
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力，请检查网络设置"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _catalogModel.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CatalogModel *catalog =  _catalogModel[section];
    return catalog.data.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, 100, 30)];
    [headView addSubview:label];
    headView.backgroundColor = [UIColor lightGrayColor];
    label.textColor = [UIColor whiteColor];
    CatalogModel *catalog =  _catalogModel[section];
    label.text = [NSString stringWithFormat:@"第%@部分",catalog.name];
    return headView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"ExamTableViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    CatalogModel *catalog =  _catalogModel[indexPath.section];
    ExamData *data = catalog.data[indexPath.row];
    NSRange srcRange = [data.title rangeOfString:@"<p><img"];
    NSRange jpgRange = [data.title rangeOfString:@"/></p>"];
    if (srcRange.location != NSNotFound && jpgRange.location != NSNotFound) {
        NSMutableString *Mstring = [NSMutableString stringWithString:data.title];
        NSRange jpgUrlRange = NSMakeRange(srcRange.location, jpgRange.location - srcRange.location + jpgRange.length);
        [Mstring deleteCharactersInRange:jpgUrlRange];
        data.title = Mstring;
    }
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[data.title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    cell.textLabel.attributedText = attrStr;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CatalogModel *catalog =  _catalogModel[indexPath.section];
    ExamData *data = catalog.data[indexPath.row];
    QuestionViewController *questionVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"QuestionViewController"];
    questionVC.data = data;
    questionVC.examModel = _examM;
    questionVC.unit_no = indexPath.section;
    questionVC.quest_no = indexPath.row;
    [self.navigationController pushViewController:questionVC animated:YES];
}



@end
