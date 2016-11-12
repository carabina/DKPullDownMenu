//
//  DKPullDownMenuItem.m
//  DKPullDownMenu
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownMenuItem.h"

#define DKPhotosBundle [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DKPullDownMenu.bundle"]]
#define DKImage(imageName) [UIImage imageWithContentsOfFile:[[DKPhotosBundle resourcePath] stringByAppendingPathComponent:imageName]]

@implementation DKPullDownMenuItem

#pragma mark - Getter && Setter

- (CGFloat)optionRowHeight
{
    return _optionRowHeight ? _optionRowHeight : 44;
}

- (UIImage *)normalImage
{
    return _normalImage ? _normalImage : DKImage(@"titleBtn_down");
}

- (UIImage *)selectImage
{
    return _selectImage ? _selectImage : DKImage(@"titleBtn_up");
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

- (NSString *)confirmTitle
{
    if (!_confirmTitle || !_confirmTitle.length) {
        _confirmTitle = @"确定";
    }
    return _confirmTitle;
}

- (UIFont *)confirmTitleFont
{
    if (!_confirmTitleFont) {
        _confirmTitleFont = [UIFont systemFontOfSize:15];
    }
    return _confirmTitleFont;
}

- (UIColor *)confirmTitleColor
{
    if (!_confirmTitleColor) {
        _confirmTitleColor = [UIColor whiteColor];
    }
    return _confirmTitleColor;
}

- (UIColor *)confirmBackgroundColor
{
    if (!_confirmBackgroundColor) {
        _confirmBackgroundColor = [UIColor colorWithRed:23/255.0 green:132/255.0 blue:235/255.0 alpha:1];
    }
    return _confirmBackgroundColor;
}

- (NSString *)subTitleTotal
{
    if (!_subTitleTotal || !_subTitleTotal.length) {
        _subTitleTotal = @"全选";
    }
    return _subTitleTotal;
}

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
