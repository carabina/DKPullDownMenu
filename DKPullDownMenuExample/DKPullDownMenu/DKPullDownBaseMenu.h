//
//  DKPullDownBaseMenu.h
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 更新下拉菜单标题的通知 */
UIKIT_EXTERN NSString *const DKPullDownMenuTitleDidUpdatedNotification;
/** item关联控制器的标识 */
UIKIT_EXTERN NSString *const DKPullDownMenuItemAssociateVcIdentifier;

@class DKPullDownBaseMenu;

/**
 *  下拉菜单的数据源协议
 */
@protocol DKPullDownMenuDataSource <NSObject>

/**
 *  下拉菜单的列数
 *  @param pullDownMenu 下拉菜单
 *  @return 下拉菜单列数
 */
- (NSInteger)numberOfColsInMenu:(DKPullDownBaseMenu *)pullDownMenu;

/**
 *  下拉菜单对应列的按钮外观
 *  @param pullDownMenu 下拉菜单
 *  @param index        第几列
 *  @return 下拉菜单每列按钮外观
 */
- (UIButton *)pullDownMenu:(DKPullDownBaseMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index;

/**
 *  下拉菜单对应列的控制器
 *  @param pullDownMenu 下拉菜单
 *  @param index        第几列
 *  @return 下拉菜单每列对应的控制器
 */
- (UIViewController *)pullDownMenu:(DKPullDownBaseMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index;

/**
 *  下拉菜单对应列的高度
 *  @param pullDownMenu 下拉菜单
 *  @param index        第几列
 *  @return 下拉菜单每列对应的高度
 */
- (CGFloat)pullDownMenu:(DKPullDownBaseMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index;

@end

@interface DKPullDownBaseMenu : UIView

/** 下拉菜单数据源 */
@property (nonatomic, weak) id<DKPullDownMenuDataSource> dataSource;
/** 分割线颜色 */
@property (nonatomic, strong) UIColor *separateLineColor;
/** 分割线距离顶部间距，默认10 */
@property (nonatomic, assign) NSInteger separateLineTopMargin;
/** 蒙版颜色 */
@property (nonatomic, strong) UIColor *coverColor;

/** 刷新下拉菜单 */
- (void)reload;


@end
