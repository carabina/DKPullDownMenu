//
//  DKPullDownMenuManager.h
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKPullDownMenuItem.h"

#define DKPullDownMenuShareManager [DKPullDownMenuManager sharedInstance]

/** 更新下拉菜单标题的通知 */
UIKIT_EXTERN NSString *const DKPullDownMenuTitleDidUpdatedNotification;
/** item关联控制器的标识 */
UIKIT_EXTERN NSString *const DKPullDownMenuItemAssociateVcIdentifier;

@interface DKPullDownMenuManager : NSObject
@property (nonatomic, strong) NSArray<DKPullDownMenuItem *> *pullDownMenuItems;

+ (instancetype)sharedInstance;
@end
