//
//  DKPullDownMenuItem.m
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownMenuItem.h"

@implementation DKPullDownMenuItem

#pragma mark - Getter && Setter

- (CGFloat)optionMenuHeight
{
    return _optionRowHeight ? _optionRowHeight : 300;
}

#pragma mark - Life Cycle

+ (instancetype)itemWithType:(DKPullDownMenuItemType)type title:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles
{
    return [[self alloc] initWithType:type title:title subTitles:subTitles];
}

+ (instancetype)itemWithType:(DKPullDownMenuItemType)type title:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles customViewController:(UIViewController *)customViewController
{
    return [[self alloc] initWithType:type title:title subTitles:subTitles customViewController:customViewController];
}

- (instancetype)initWithType:(DKPullDownMenuItemType)type title:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles
{
    _type = type;
    _title = title;
    _subTitles = subTitles;
    return self;
}

- (instancetype)initWithType:(DKPullDownMenuItemType)type title:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles customViewController:(UIViewController *)customViewController
{
    self = [self initWithType:type title:title subTitles:subTitles];
    _customViewController = customViewController;
    return self;
}

@end
