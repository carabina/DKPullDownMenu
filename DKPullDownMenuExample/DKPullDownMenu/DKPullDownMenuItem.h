//
//  DKPullDownMenuItem.h
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKPullDownMenuItem : NSObject

/** 选项默认标题 */
@property (nonatomic, copy) NSString *title;
/** 子选项标题数组 */
@property (nonatomic, strong) NSArray<NSString *> *subTitles;
/** 弹出的选项菜单的高度 */
@property (nonatomic, assign) CGFloat optionMenuHeight;
/** 选项菜单的每一行高度 */
@property (nonatomic, assign) CGFloat optionRowHeight;
/** 主标题按钮默认状态图片 */
@property (nonatomic, weak) UIImage *normalImage;
/** 主标题按钮选中状态图片 */
@property (nonatomic, weak) UIImage *selectImage;
/** 主标题字体 */
@property (nonatomic, weak) UIFont *titleFont;
/** 子标题字体 */
@property (nonatomic, weak) UIFont *subTitleFont;
/** 主标题默认状态字体颜色 */
@property (nonatomic, weak) UIColor *titleNormalColor;
/** 主标题选中状态字体颜色 */
@property (nonatomic, weak) UIColor *titleSelectColor;
/** 子标题默认状态字体颜色 */
@property (nonatomic, weak) UIColor *subTitleNormalColor;
/** 子标题选中状态字体颜色 */
@property (nonatomic, weak) UIColor *subTitleSelectColor;

+ (instancetype)itemWithTitle:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles;
- (instancetype)initWithTitle:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles;
@end

@interface DKPullDownMenuSingleSelectItem : DKPullDownMenuItem
/** 选中图片 */
@property (nonatomic, weak) UIImage *singleSelectImage;
@end

@interface DKPullDownMenuMultiSelectItem : DKPullDownMenuItem
/** 普通状态图片 */
@property (nonatomic, weak) UIImage *multiNormalImage;
/** 选中状态图片 */
@property (nonatomic, weak) UIImage *multiSelectImage;
@end

@interface DKPullDownMenuCustomItem : DKPullDownMenuItem
/** 自定义的控制器 */
@property (nonatomic, strong) UIViewController *customViewController;

+ (instancetype)itemWithTitle:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithTitle:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles UNAVAILABLE_ATTRIBUTE;

+ (instancetype)itemWithTitle:(NSString *)title customViewController:(UIViewController *)customViewController;
- (instancetype)initWithTitle:(NSString *)title customViewController:(UIViewController *)customViewController;
@end
