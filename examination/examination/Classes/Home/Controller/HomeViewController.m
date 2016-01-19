//
//  HomeViewController.m
//  examination
//
//  Created by 李晓 on 15/9/7.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionViewCell.h"
#import "ExamTableViewController.h"
#import "UserMenuViewController.h"
#import "CourseModel.h"
#import <MJRefresh.h>

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) MJRefreshHeader *refHeader;

@property (nonatomic,strong) NSMutableArray *dataList;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"首页"];
    
    __weak typeof (self) nav = self;
    Instance *instance = [Instance sharedInstance];
    if (!instance.isAssessor) {
        [self setRightBtnWithImage:[UIImage imageNamed:@"main_menu_btn"] orTitle:nil ClickOption:^{
            UserMenuViewController *menu = [[UserMenuViewController alloc] init];
            [nav.navigationController pushViewController:menu animated:YES];
        }];
    }
    [self setLeftBtnWithImage:[UIImage imageNamed:@"popover_icon_refresh"] orTitle:nil ClickOption:^{
        [nav.refHeader beginRefreshing];
    }];
    
    self.collectionView.header = self.refHeader;
    [self.refHeader beginRefreshing];
}

- (MJRefreshHeader *)refHeader
{
    if (!_refHeader) {
        _refHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    }
    return _refHeader;
}

- (void)loadNewData
{
    [self getUserCourse];
}

- (void) getUserCourse
{
    Instance *instance = [Instance sharedInstance];
    [SkywareHttpTool HttpToolGetWithUrl:userCourse paramesers:nil requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        SkywareResult *result = [SkywareResult objectWithKeyValues:json];
        NSArray *courseArray = [CourseModel objectArrayWithKeyValuesArray:result.result];
        if (courseArray.count) {
            [self.dataList removeAllObjects];
        }
        [self.dataList addObjectsFromArray:[self appChackingRemoveNotprepareWith:courseArray]];
        [self.collectionView reloadData];
        [SVProgressHUD dismiss];
        [self.refHeader endRefreshing];
    } failure:^(NSError *error) {
        [self.refHeader endRefreshing];
        [SVProgressHUD dismiss];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

/**
 *  如果苹果正在审核，去掉没有准备好的试卷
 */
- (NSMutableArray *) appChackingRemoveNotprepareWith:(NSArray *) courseArray
{
    Instance *instance = [Instance sharedInstance];
    NSMutableArray *array = [NSMutableArray array];
    if (!instance.isAssessor) return (NSMutableArray *)courseArray;
    [courseArray enumerateObjectsUsingBlock:^(CourseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger status = [obj.exam_status integerValue];
        if (status == 2) {
            [array addObject:obj];
        }
    }];
    return array;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewID" forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWH = (kWindowWidth - 3 * 15) * 0.5;
    return CGSizeMake(cellWH, cellWH * 0.7);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 15, 20, 15);
}

/**
 *  UICollectionView被选中时调用的方法
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExamTableViewController *examVC = [[ExamTableViewController alloc] init];
    CourseModel *model = self.dataList[indexPath.row];
    examVC.exam_id = model.exam_id;
    [self.navigationController pushViewController:examVC animated:YES];
}

//返回这个UICollectionView是否可以被选择
/**
 *  1. 考卷尚未准备好：等待
 *  2. 考卷已经准备好：正常
 *  3. 考卷已经锁定：锁定
 */

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell * cell = (HomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSInteger status = [cell.model.exam_status integerValue];
    
    if (status == 1) {
        [SVProgressHUD showInfoWithStatus:@"考卷尚未准备好"];
        return NO;
    }else if(status == 3){
        [SVProgressHUD showInfoWithStatus:@"考卷已经锁定"];
        return NO;
    }
    return YES;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}
@end