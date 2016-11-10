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

@interface DKPullDownMenu () <DKPullDownMenuDataSource>
@property (nonatomic, weak) DKPullDownBaseMenu *menu;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *viewControllers;
@end

@implementation DKPullDownMenu

#pragma mark - Getter && Setter

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (frame.size.width && frame.size.height) {
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
        if (frame.size.width && frame.size.height) {
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
    
    // 初始化标题
    _titles = @[@"xxx",@"xxxx"];
    // 初始化控制器
    _viewControllers = @[[[DKPullDownSingleSelectViewController alloc] init],[[DKPullDownSingleSelectViewController alloc] init]];
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
    // 第1列 高度
    if (index == 0) {
        return 400;
    }
    
    // 第2列 高度
    if (index == 1) {
        return 176;
    }
    
    // 第3列 高度
    return 240;
}


@end
