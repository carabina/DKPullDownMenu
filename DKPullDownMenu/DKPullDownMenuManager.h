//
//  DKPullDownMenuManager.h
//  DKPullDownMenu
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKPullDownMenuItem.h"
#import "DKPullDownResult.h"

#define DKPullDownMenuShareManager [DKPullDownMenuManager sharedInstance]

/** 更新下拉菜单标题的通知 */
UIKIT_EXTERN NSString *const DKPullDownMenuTitleDidUpdatedNotification;
/** item关联控制器的标识 */
UIKIT_EXTERN NSString *const DKPullDownMenuItemAssociateVcIdentifier;

@class DKPullDownBaseMenu;

@interface DKPullDownMenuManager : NSObject
@property (nonatomic, strong) NSArray<DKPullDownMenuItem *> *pullDownMenuItems;
@property (nonatomic, weak) DKPullDownBaseMenu *menu;
/** 分割线颜色 */
@property (nonatomic, strong) UIColor *separateLineColor;
/** 是否添加顶部分割线 */
@property (nonatomic, assign, getter=isHeadSeparateLineAvailable) BOOL headSeparateLineAvailable;
/** 是否添加底部分割线 */
@property (nonatomic, assign, getter=isBottomSeparateLineAvailable) BOOL bottomSeparateLineAvailable;
/** 分割线距离顶部间距，默认10 */
@property (nonatomic, assign) NSInteger separateLineTopMargin;
/** 蒙版颜色 */
@property (nonatomic, strong) UIColor *coverColor;

/** 选择结果 */
@property (nonatomic, strong) NSMutableArray<DKPullDownResult *> *results;

+ (instancetype)sharedInstance;
@end
