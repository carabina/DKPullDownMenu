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
    self.title = title ? title : @"";
    self.subTitles = subTitles;
    return self;
}

@end

@implementation DKPullDownMenuSingleSelectItem

@end

@implementation DKPullDownMenuMultiSelectItem

@end

@implementation DKPullDownMenuCustomItem

+ (instancetype)itemWithTitle:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles
{
    return [super itemWithTitle:title subTitles:subTitles];
}

- (instancetype)initWithTitle:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles
{
    return [super initWithTitle:title subTitles:subTitles];
}

+ (instancetype)itemWithTitle:(NSString *)title customViewController:(UIViewController *)customViewController
{
    return [[self alloc] initWithTitle:title customViewController:customViewController];
}

- (instancetype)initWithTitle:(NSString *)title customViewController:(UIViewController *)customViewController
{
    NSAssert(customViewController, @"DKPullDownMenuCustomItem customViewController cannot be nil");
    self.title = title;
    self.customViewController = customViewController;
    return self;
}

@end
