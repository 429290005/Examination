//
//  HomeViewController.m
//  examination
//
//  Created by 李晓 on 15/9/7.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import "HomeViewController.h"
#import "UserLoginViewController.h"
#import "HomeCollectionViewCell.h"
#import "ExamTableViewController.h"
#import "UserMenuViewController.h"
#import "CourseModel.h"

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataList;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"首页"];
    
    [self getUserCourse];
    
    __weak typeof (self) nav = self;
    [self setRightBtnWithImage:[UIImage imageNamed:@"main_menu_btn"] orTitle:nil ClickOption:^{
        UserMenuViewController *menu = [[UserMenuViewController alloc] init];
        [nav.navigationController pushViewController:menu animated:YES];
    }];
}

- (void) getUserCourse
{
    Instance *instance = [Instance sharedInstance];
    [SkywareHttpTool HttpToolGetWithUrl:userCourse paramesers:nil requestHeaderField:@{@"token":instance.token} SuccessJson:^(id json) {
        SkywareResult *result = [SkywareResult objectWithKeyValues:json];
        NSArray *courseArray = [CourseModel objectArrayWithKeyValuesArray:result.result];
        [self.dataList addObjectsFromArray:courseArray];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

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
    return CGSizeMake(cellWH, cellWH);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 15, 20, 15);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExamTableViewController *examVC = [[ExamTableViewController alloc] init];
    CourseModel *model = self.dataList[indexPath.row];
    examVC.exam_id = model.exam_id;
    [self.navigationController pushViewController:examVC animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell * cell = (HomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSInteger status = [cell.model.exam_status integerValue];
    if (status == 1 || status == 3) {
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