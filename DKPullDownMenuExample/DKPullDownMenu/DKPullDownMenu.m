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
    [self addSubview:menu];
    
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *viewControllers = [NSMutableArray array];
    [self.pullDownMenuItems enumerateObjectsUsingBlock:^(DKPullDownMenuItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        // 标题
        [titles addObject:item.title];
        id vc;
        switch (item.type) {
            case DKPullDownMenuItemTypeSingle:
                vc = [[DKPullDownSingleSelectViewController alloc] init];
                break;
            case DKPullDownMenuItemTypeMulti:
                vc = [[DKPullDownMultiSelectViewController alloc] init];
                break;
            case DKPullDownMenuItemTypeCustom:
                vc = item.customViewController;
        }
        // item关联控制器
        objc_setAssociatedObject(item, &DKPullDownMenuItemAssociateVcIdentifier, vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        // 控制器
        [viewControllers addObject:vc];
    }];
    
    _titles = [titles copy];
    _viewControllers = [viewControllers copy];
}

#pragma mark - <DKPullDownMenuDataSource>

- (NSInteger)numberOfColsInMenu:(DKPullDownBaseMenu *)pullDownMenu
{
    return self.titles.count;
}

- (UIButton *)pullDownMenu:(DKPullDownBaseMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    DKPullDownTitleButton *button = [DKPullDownTitleButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_titles[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:25 /255.0 green:143/255.0 blue:238/255.0 alpha:1] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"titleBtn_down"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"titleBtn_up"] forState:UIControlStateSelected];
    
    return button;
}

- (UIViewController *)pullDownMenu:(DKPullDownBaseMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index
{
    return self.viewControllers[index];
}

- (CGFloat)pullDownMenu:(DKPullDownBaseMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index
{
    return DKPullDownMenuShareManager.pullDownMenuItems[index].optionMenuHeight;
}


@end
