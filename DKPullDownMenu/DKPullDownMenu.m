//
//  DKPullDownMenu.m
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownMenu.h"
#import "DKPullDownTitleButton.h"
#import "DKPullDownSingleSelectViewController.h"
#import "DKPullDownMultiSelectViewController.h"
#import "DKPullDownMenuManager.h"
#import <objc/runtime.h>

@interface DKPullDownMenu () <DKPullDownMenuDataSource>
@property (nonatomic, weak) DKPullDownBaseMenu *menu;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *viewControllers;
@end

@implementation DKPullDownMenu

#pragma mark - Getter && Setter

- (void)setPullDownMenuItems:(NSArray<DKPullDownMenuItem *> *)pullDownMenuItems
{
    _pullDownMenuItems = pullDownMenuItems;
    DKPullDownMenuShareManager.pullDownMenuItems = pullDownMenuItems;
    
    if (self.frame.size.width && self.frame.size.height) {
        // 初始化下拉菜单
        [self setupMenu];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (frame.size.width && frame.size.height && _pullDownMenuItems.count) {
        // 初始化下拉菜单
        [self setupMenu];
    }
}

- (void)setSeparateLineColor:(UIColor *)separateLineColor
{
    _separateLineColor = separateLineColor;
    DKPullDownMenuShareManager.separateLineColor = separateLineColor;
}

- (void)setHeadSeparateLineAvailable:(BOOL)headSeparateLineAvailable
{
    _headSeparateLineAvailable = headSeparateLineAvailable;
    DKPullDownMenuShareManager.headSeparateLineAvailable = headSeparateLineAvailable;
}

- (void)setBottomSeparateLineAvailable:(BOOL)bottomSeparateLineAvailable
{
    _bottomSeparateLineAvailable = bottomSeparateLineAvailable;
    DKPullDownMenuShareManager.bottomSeparateLineAvailable = bottomSeparateLineAvailable;
}

- (void)setSeparateLineTopMargin:(CGFloat)separateLineTopMargin
{
    _separateLineTopMargin = separateLineTopMargin;
    DKPullDownMenuShareManager.separateLineTopMargin = separateLineTopMargin;
}

- (void)setCoverColor:(UIColor *)coverColor
{
    _coverColor = coverColor;
    DKPullDownMenuShareManager.coverColor = coverColor;
}

#pragma mark - Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 初始化下拉菜单
    [self setupMenu];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (frame.size.width && frame.size.height && _pullDownMenuItems.count) {
            // 初始化下拉菜单
            [self setupMenu];
        }
    }
    return self;
}

/** 初始化下拉菜单 */
- (void)setupMenu
{
    // 创建下拉菜单
    DKPullDownBaseMenu *menu = [[DKPullDownBaseMenu alloc] initWithFrame:self.bounds];
    menu.dataSource = self;
    self.menu = menu;
    DKPullDownMenuShareManager.menu = menu;
    [self addSubview:menu];
    
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *viewControllers = [NSMutableArray array];
    [self.pullDownMenuItems enumerateObjectsUsingBlock:^(DKPullDownMenuItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        // 标题
        [titles addObject:item.title];
        id vc;
        if ([item isKindOfClass:[DKPullDownMenuSingleSelectItem class]]) {
            vc = [[DKPullDownSingleSelectViewController alloc] init];
        } else if ([item isKindOfClass:[DKPullDownMenuMultiSelectItem class]]) {
            vc = [[DKPullDownMultiSelectViewController alloc] init];
        } else if ([item isKindOfClass:[DKPullDownMenuCustomItem class]]) {
            vc = ((DKPullDownMenuCustomItem *)item).customViewController;
        } else { // 父类, 默认为单选
            vc = [[DKPullDownSingleSelectViewController alloc] init];
        }
        // item关联控制器
        objc_setAssociatedObject(item, &DKPullDownMenuItemAssociateVcIdentifier, vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        // 控制器
        [viewControllers addObject:vc];
    }];
    
    _titles = [titles copy];
    _viewControllers = [viewControllers copy];
    
    // 监听结果通知
    [DKPullDownMenuShareManager addObserver:self forKeyPath:@"results" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"results"]) {
        // 代理传值
        if (self.delegate && [self.delegate respondsToSelector:@selector(pullDownMenu:selectedResultsDidUpdated:)]) {
            [self.delegate pullDownMenu:self selectedResultsDidUpdated:DKPullDownMenuShareManager.results];
        }
    }
}

- (void)dealloc
{
    [DKPullDownMenuShareManager removeObserver:self forKeyPath:@"results"];
}

#pragma mark - <DKPullDownMenuDataSource>

- (NSInteger)numberOfColsInMenu:(DKPullDownBaseMenu *)pullDownMenu
{
    return self.titles.count;
}

- (UIButton *)pullDownMenu:(DKPullDownBaseMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    DKPullDownMenuItem *item = DKPullDownMenuShareManager.pullDownMenuItems[index];
    DKPullDownTitleButton *button = [DKPullDownTitleButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_titles[index] forState:UIControlStateNormal];
    [button setTitleColor:item.titleNormalColor forState:UIControlStateNormal];
    [button setTitleColor:item.titleSelectColor forState:UIControlStateSelected];
    [button setImage:item.normalImage forState:UIControlStateNormal];
    [button setImage:item.selectImage forState:UIControlStateSelected];
    
    return button;
}

- (UIViewController *)pullDownMenu:(DKPullDownBaseMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index
{
    return self.viewControllers[index];
}

- (CGFloat)pullDownMenu:(DKPullDownBaseMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index
{
    DKPullDownMenuItem *item = DKPullDownMenuShareManager.pullDownMenuItems[index];
    if (!item.optionMenuHeight) {
        // 高度限制不能超出屏幕
        CGFloat optionMenuMaxH = [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.menu.frame) - 20; // -20是状态栏高度
        CGFloat optionMenuH = item.subTitles.count * item.optionRowHeight;
        // 多选的时候算多个按钮的高度和两个间距
        if ([item isKindOfClass:[DKPullDownMenuMultiSelectItem class]]) {
            if (item.subTitles.count > 1) {
                optionMenuH = (item.subTitles.count + 1) * item.optionRowHeight;
            }
            optionMenuH += 10 * 2 + 40;
        }
        // Custom default
        if (!optionMenuH) {
            optionMenuH = optionMenuMaxH;
        }
        return optionMenuH > optionMenuMaxH ? optionMenuMaxH : optionMenuH;
    }
    
    return item.optionMenuHeight;
}


@end
