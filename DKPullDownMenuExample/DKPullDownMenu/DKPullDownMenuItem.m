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

- (CGFloat)optionRowHeight
{
    return _optionRowHeight ? _optionRowHeight : 44;
}

- (UIImage *)normalImage
{
    return _normalImage ? _normalImage : nil;
}

- (UIImage *)selectImage
{
    return _selectImage ? _selectImage : nil;
}

- (UIFont *)titleFont
{
    return _titleFont ? _titleFont : [UIFont systemFontOfSize:14.0];
}

- (UIFont *)subTitleFont
{
    return _subTitleFont ? _subTitleFont : [UIFont systemFontOfSize:14.0];
}

- (UIColor *)titleNormalColor
{
    return _titleNormalColor ? _titleNormalColor : [UIColor blackColor];
}

- (UIColor *)titleSelectColor
{
    return _titleSelectColor ? _titleSelectColor : [UIColor blackColor];
}

- (UIColor *)subTitleNormalColor
{
    return _subTitleNormalColor ? _subTitleNormalColor : [UIColor blackColor];
}

- (UIColor *)subTitleSelectColor
{
    return _subTitleSelectColor ? _subTitleSelectColor : [UIColor blackColor];
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
