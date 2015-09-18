//
//  BaseTableViewController.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/6/15.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseCellItem.h"
#import "BaseArrowCellItem.h"
#import "BaseSwitchCellItem.h"
#import "BaseCenterTitleCellItem.h"
#import "BaseSubtitleCellItem.h"
#import "BaseCellItemGroup.h"
#import "BaseTableViewCell.h"
#import <MJRefresh.h>

// 屏幕宽高
#define kWindowWidth [UIScreen mainScreen].bounds.size.width
#define kWindowHeight [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <=568.0)
#define IS_IPHONE_5_OR_5S (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6_OR_6S (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P_OR_6PS (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define kLINE_1_PX (1.0f / [UIScreen mainScreen].scale)

@interface BaseTableViewController : BaseViewController

/** 自定义的TableView */
@property (nonatomic,strong) UITableView *tableView;

/** UITableView数据源 */
@property (nonatomic,strong) NSMutableArray *dataList;

/** TableView 实时滚动展示NavigationBar */
@property (nonatomic,assign) BOOL displayNav;

/** TableView 拖拽 TableView 放大HeadImg */
@property (nonatomic,strong) UIImage *scaleImage;

/** TableView 拖拽 TableView 放大HeadImg Height */
@property (nonatomic,assign) CGFloat scaleHeight;


@end
