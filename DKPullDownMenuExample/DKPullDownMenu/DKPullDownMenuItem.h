//
//  DKPullDownMenuItem.h
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DKPullDownMenuItemType) {
    DKPullDownMenuItemTypeSingle,   // 单选
    DKPullDownMenuItemTypeMulti,    // 多选
    DKPullDownMenuItemTypeCustom    // 自定义
};

@interface DKPullDownMenuItem : NSObject

/** 类型 */
@property (nonatomic, assign) DKPullDownMenuItemType type;
/** 选项默认标题 */
@property (nonatomic, copy) NSString *title;
/** 子选项标题数组 */
@property (nonatomic, strong) NSArray<NSString *> *subTitles;
/** 弹出的选项菜单的高度 */
@property (nonatomic, assign) CGFloat optionMenuHeight;
/** 选项菜单的每一行高度 */
@property (nonatomic, assign) CGFloat optionRowHeight;
/** 自定义的控制器 */
@property (nonatomic, strong) UIViewController *customViewController;

+ (instancetype)itemWithType:(DKPullDownMenuItemType)type title:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles;
+ (instancetype)itemWithType:(DKPullDownMenuItemType)type title:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles customViewController:(UIViewController *)customViewController;

- (instancetype)initWithType:(DKPullDownMenuItemType)type title:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles;
- (instancetype)initWithType:(DKPullDownMenuItemType)type title:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles customViewController:(UIViewController *)customViewController;

@end
