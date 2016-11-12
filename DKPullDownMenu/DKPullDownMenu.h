//
//  DKPullDownMenu.h
//  DKPullDownMenu
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownBaseMenu.h"
#import "DKPullDownMenuItem.h"
#import "DKPullDownResult.h"

@class DKPullDownMenu;
@protocol DKPullDownMenuDelegate <NSObject>
@optional
/** 更新选择结果 */
- (void)pullDownMenu:(DKPullDownMenu *)pullDownMenu selectedResultsDidUpdated:(NSArray<DKPullDownResult *> *)results;
@end

@interface DKPullDownMenu : UIView

@property (nonatomic, strong) NSArray<DKPullDownMenuItem *> *pullDownMenuItems;
/** 分割线颜色 */
@property (nonatomic, strong) UIColor *separateLineColor;
/** 分割线宽度 */
@property (nonatomic, assign) CGFloat separateLineWidth;
/** 分割线距离顶部间距，默认10 */
@property (nonatomic, assign) CGFloat separateLineTopMargin;

/** 是否添加顶部分割线 */
@property (nonatomic, assign, getter=isHeadSeparateLineAvailable) BOOL headSeparateLineAvailable;
/** 是否添加底部分割线 */
@property (nonatomic, assign, getter=isBottomSeparateLineAvailable) BOOL bottomSeparateLineAvailable;
/** 蒙版颜色 */
@property (nonatomic, strong) UIColor *coverColor;

/** 下拉菜单代理 */
@property (nonatomic, weak) id<DKPullDownMenuDelegate> delegate;
@end
