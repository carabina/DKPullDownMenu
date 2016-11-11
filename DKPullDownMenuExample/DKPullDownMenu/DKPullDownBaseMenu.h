//
//  DKPullDownBaseMenu.h
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import <UIKit/UIKit.h>

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

/** 刷新下拉菜单 */
- (void)reload;

@end
