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
    return _optionMenuHeight ? _optionMenuHeight : 300;
}

- (CGFloat)optionRowHeight
{
    return _optionRowHeight ? _optionRowHeight : 44;
}

#pragma mark - Life Cycle

+ (instancetype)itemWithTitle:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles
{
    return [[self alloc] initWithTitle:title subTitles:subTitles];
}

- (instancetype)initWithTitle:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles
{
    NSAssert(subTitles.count, @"DKPullDownMenuItem subTitles cannot be nil");
    _title = title ? title : @"";
    _subTitles = subTitles;
    return self;
}

@end

@implementation DKPullDownMenuSingleSelectItem

@end

@implementation DKPullDownMenuMultiSelectItem

@end

@implementation DKPullDownMenuCustomItem

+ (instancetype)itemWithTitle:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles customViewController:(UIViewController *)customViewController
{
    return [[super alloc] initWithTitle:title subTitles:subTitles customViewController:customViewController];
}

- (instancetype)initWithTitle:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles customViewController:(UIViewController *)customViewController
{
    NSAssert(customViewController, @"DKPullDownMenuCustomItem customViewController cannot be nil");
    self = [super initWithTitle:title subTitles:subTitles];
    _customViewController = customViewController;
    return self;
}

@end
