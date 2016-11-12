//
//  DKPullDownBaseMenu.m
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownBaseMenu.h"
#import "DKPullDownCover.h"
#import "DKPullDownMenuManager.h"

#define KAddObserver(keyPath) [DKPullDownMenuShareManager addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
#define KRemoveObserver(keyPath) [DKPullDownMenuShareManager removeObserver:self forKeyPath:keyPath];

@interface DKPullDownBaseMenu ()
/** 下拉菜单所有按钮 */
@property (nonatomic, strong) NSMutableArray *menuButtons;
/** 下拉菜单所有分割线 */
@property (nonatomic, strong) NSMutableArray<UIView *> *separateLines;
/** 下拉菜单所有控制器 */
@property (nonatomic, strong) NSMutableArray *controllers;
/** 下拉菜单每列高度 */
@property (nonatomic, strong) NSMutableArray *colsHeight;
/** 下拉菜单内容View */
@property (nonatomic, strong) UIView *contentView;
/** 下拉菜单蒙版 */
@property (nonatomic, strong) DKPullDownCover *coverView;
/** 下拉菜单顶部View */
@property (nonatomic, weak) UIView *headLine;
/** 下拉菜单底部View */
@property (nonatomic, weak) UIView *bottomLine;
/** 观察者 */
@property (nonatomic, weak) id observer;
@end

@implementation DKPullDownBaseMenu

NSString *const DKPullDownMenuTitleDidUpdatedNotification = @"DKPullDownMenuTitleDidUpdatedNotification";
NSString *const DKPullDownMenuItemAssociateVcIdentifier = @"DKPullDownMenuItemAssociateVcIdentifier";
NSString *const DKPullDownMenuVcAssociateOpRowHIdentifier = @"DKPullDownMenuVcAssociateOpRowHIdentifier";

static NSString *const kKeyPathSeparateLineColor = @"separateLineColor";
static NSString *const kKeyPathBottomSeparateLineAvailable = @"bottomSeparateLineAvailable";
static NSString *const kKeyPathHeadSeparateLineAvailable = @"headSeparateLineAvailable";
static NSString *const kKeyPathSeparateLineTopMargin = @"separateLineTopMargin";
static NSString *const kKeyPathCoverColor = @"coverColor";

#pragma mark - Getter && Setter

- (NSMutableArray<UIView *> *)separateLines
{
    if (!_separateLines) {
        _separateLines = [NSMutableArray array];
    }
    return _separateLines;
}

- (NSMutableArray *)menuButtons
{
    if (!_menuButtons) {
        _menuButtons = [NSMutableArray array];
    }
    return _menuButtons;
}

- (NSMutableArray *)colsHeight
{
    if (!_colsHeight) {
        _colsHeight = [NSMutableArray array];
    }
    return _colsHeight;
}

- (NSMutableArray *)controllers
{
    if (!_controllers) {
        _controllers = [NSMutableArray array];
    }
    return _controllers;
}

- (UIView *)coverView
{
    if (!_coverView) {
        UIView *pullDownMenu = self.superview;
        // 设置蒙版的frame
        CGFloat coverX = 0;
        CGFloat coverY = CGRectGetMaxY(pullDownMenu.frame);
        CGFloat coverW = self.frame.size.width;
        CGFloat coverH = pullDownMenu.superview.bounds.size.height - coverY;
        _coverView = [[DKPullDownCover alloc] initWithFrame:CGRectMake(coverX, coverY, coverW, coverH)];
        _coverView.backgroundColor = DKPullDownMenuShareManager.coverColor;
        [pullDownMenu.superview addSubview:_coverView];
        __weak typeof(self) weakSelf = self;
        // 蒙版点击block
        _coverView.coverClickBlock = ^{
            [weakSelf dismiss];
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
        };
    }
    return _coverView;
}

- (UIView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        _contentView.clipsToBounds = YES;
        [self.coverView addSubview:_contentView];
    }
    return _contentView;
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupBase];
    }
    return self;
}

- (void)dealloc
{
    [self clear];
    
    [[NSNotificationCenter defaultCenter] removeObserver:_observer];
    
    KRemoveObserver(kKeyPathSeparateLineColor)
    KRemoveObserver(kKeyPathHeadSeparateLineAvailable)
    KRemoveObserver(kKeyPathBottomSeparateLineAvailable)
    KRemoveObserver(kKeyPathSeparateLineTopMargin)
    KRemoveObserver(kKeyPathCoverColor)
}

- (void)setupBase
{
    self.backgroundColor = [UIColor whiteColor];

    // 监听更新菜单标题通知
    _observer = [[NSNotificationCenter defaultCenter] addObserverForName:DKPullDownMenuTitleDidUpdatedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        // 获取列
        NSInteger col = [self.controllers indexOfObject:note.object];
        // 获取对应按钮
        UIButton *btn = self.menuButtons[col];
        // 隐藏下拉菜单
        [self dismiss];
        // 获取所有值
        NSArray *allValues = note.userInfo.allValues;
        // 不需要设置标题,字典个数大于1，或者有数组
        if (allValues.count > 1 || [allValues.firstObject isKindOfClass:[NSArray class]]) return ;
        // 设置按钮标题
        [btn setTitle:allValues.firstObject forState:UIControlStateNormal];
        
        // 选中的数据
        NSLog(@"%@",note.userInfo);
    }];
    
    // 添加观察者
    KAddObserver(kKeyPathSeparateLineColor)
    KAddObserver(kKeyPathHeadSeparateLineAvailable)
    KAddObserver(kKeyPathBottomSeparateLineAvailable)
    KAddObserver(kKeyPathSeparateLineTopMargin)
    KAddObserver(kKeyPathCoverColor)
}

/** 布局子控件 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.menuButtons.count;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.bounds.size.width / count;
    CGFloat btnH = self.bounds.size.height;
    for (NSInteger i = 0; i < count; i++) {
        // 设置按钮位置
        UIButton *btn = self.menuButtons[i];
        btnX = i * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        // 设置分割线位置
        if (i < count - 1) {
            UIView *separateLine = self.separateLines[i];
            separateLine.frame = CGRectMake(CGRectGetMaxX(btn.frame), DKPullDownMenuShareManager.separateLineTopMargin, 1, btnH - 2 * DKPullDownMenuShareManager.separateLineTopMargin);
        }
    }
    // 设置顶部view位置
    CGFloat headX = 0;
    CGFloat headY = btnY;
    CGFloat headH = 1;
    CGFloat headW = self.bounds.size.width;
    _headLine.frame = CGRectMake(headX, headY, headW, headH);
    // 设置底部View位置
    CGFloat bottomY = btnH - headH;
    _bottomLine.frame = CGRectMake(headX, bottomY, headW, 0.3);
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    [self reload];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:kKeyPathSeparateLineColor]) { // 分割线颜色
        [self.separateLines enumerateObjectsUsingBlock:^(UIView * _Nonnull separateLine, NSUInteger idx, BOOL * _Nonnull stop) {
            separateLine.backgroundColor = DKPullDownMenuShareManager.separateLineColor;
        }];
    } else if ([keyPath isEqualToString:kKeyPathBottomSeparateLineAvailable]) { // 顶部分割线
        _bottomLine.hidden = !DKPullDownMenuShareManager.bottomSeparateLineAvailable;
    } else if ([keyPath isEqualToString:kKeyPathBottomSeparateLineAvailable]) { // 底部分割线
        _bottomLine.hidden = !DKPullDownMenuShareManager.bottomSeparateLineAvailable;
    } else if ([keyPath isEqualToString:kKeyPathSeparateLineTopMargin]) { // 分割线顶部间距
        [self.separateLines enumerateObjectsUsingBlock:^(UIView * _Nonnull separateLine, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect tempFrame = separateLine.frame;
            tempFrame.origin.y = DKPullDownMenuShareManager.separateLineTopMargin;
            tempFrame.size.height = self.bounds.size.height - 2 * DKPullDownMenuShareManager.separateLineTopMargin;
            separateLine.frame = tempFrame;
        }];
    } else if ([keyPath isEqualToString:kKeyPathCoverColor]) { // 蒙版颜色
        _coverView.backgroundColor = DKPullDownMenuShareManager.coverColor;
    }
}

#pragma mark - Events

/** 点击菜单标题按钮 */
- (void)menuBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    // 取消其他按钮选中
    for (UIButton *otherButton in self.menuButtons) {
        if (otherButton == button) continue;
        otherButton.selected = NO;
    }
    
    if (button.isSelected == YES) {
        // 弹出蒙版
        self.coverView.hidden = NO;
        // 获取索引
        NSInteger index = button.tag;
        // 移除之前子控制器的View
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        // 添加对应子控制器的view
        UIViewController *vc = self.controllers[index];
        vc.view.frame = self.contentView.bounds;
        [self.contentView addSubview:vc.view];
        
        // 设置内容的高度
        CGFloat height = [self.colsHeight[index] floatValue];
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.contentView.frame;
            frame.size.height = height;
            self.contentView.frame = frame;
        }];
    } else {
        // 隐藏蒙版
        [self dismiss];
    }
}

#pragma mark - Private Method

/** 清除数据 移除子控件 */
- (void)clear
{
    self.bottomLine = nil;
    self.coverView = nil;
    self.contentView = nil;
    [self.separateLines removeAllObjects];
    [self.menuButtons removeAllObjects];
    [self.controllers removeAllObjects];
    [self.colsHeight removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

/** 刷新下拉菜单 */
- (void)reload
{
    [self clear];
    // 没有数据源，直接返回
    if (self.dataSource == nil) return;
    // 如果之前已经添加过，直接返回
    if (self.menuButtons.count) return;
    
    // 断言实现数据源方法
    NSAssert([self.dataSource respondsToSelector:@selector(numberOfColsInMenu:)], @"dataSource method not implement - [numberOfColsInMenu:]");
    NSAssert([self.dataSource respondsToSelector:@selector(pullDownMenu:buttonForColAtIndex:)], @"DataSource method not implement - [pullDownMenu:buttonForColAtIndex:]");
    NSAssert([self.dataSource respondsToSelector:@selector(pullDownMenu:viewControllerForColAtIndex:)], @"dataSource method not implement - [pullDownMenu:viewControllerForColAtIndex:]");
    NSAssert([self.dataSource respondsToSelector:@selector(pullDownMenu:heightForColAtIndex:)], @"dataSource method not implement - [pullDownMenu:heightForColAtIndex:]");
    
    // 获取列数
    NSInteger cols = [self.dataSource numberOfColsInMenu:self];
    // 没有列直接返回
    if (cols == 0) return;
    
    // 添加按钮
    for (NSInteger col = 0; col < cols; col++) {
        // 获取按钮
        UIButton *menuButton = [self.dataSource pullDownMenu:self buttonForColAtIndex:col];
        NSAssert(menuButton, @"[pullDownMenu:buttonForColAtIndex:] return button must not be nil");
        
        menuButton.tag = col;
        [menuButton addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuButton];
        [self.menuButtons addObject:menuButton];
        
        // 保存对应列的高度
        CGFloat height = [self.dataSource pullDownMenu:self heightForColAtIndex:col];
        [self.colsHeight addObject:@(height)];
        
        // 保存对应列的子控制器
        UIViewController *vc = [self.dataSource pullDownMenu:self viewControllerForColAtIndex:col];
        [self.controllers addObject:vc];
    }
    
    // 添加分割线
    NSInteger separateCount = cols - 1;
    for (NSInteger i = 0; i < separateCount; i++) {
        UIView *separateLine = [[UIView alloc] init];
        separateLine.backgroundColor = DKPullDownMenuShareManager.separateLineColor;
        [self addSubview:separateLine];
        [self.separateLines addObject:separateLine];
    }
    
    // 添加顶部view
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = DKPullDownMenuShareManager.separateLineColor;
    headView.hidden = !DKPullDownMenuShareManager.isHeadSeparateLineAvailable;
    _headLine = headView;
    [self addSubview:headView];
    
    // 添加底部View
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = DKPullDownMenuShareManager.separateLineColor;
    bottomView.hidden = !DKPullDownMenuShareManager.isBottomSeparateLineAvailable;
    _bottomLine = bottomView;
    [self addSubview:bottomView];
    
    // 布局子控件
    [self layoutSubviews];
}

/** 隐藏下拉菜单 */
- (void)dismiss
{
    // 所有按钮取消选中
    for (UIButton *button in self.menuButtons) {
        button.selected = NO;
    }
    // 移除蒙版
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        CGRect frame = self.contentView.frame;
        frame.size.height = 0;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        self.coverView.hidden = YES;
        self.coverView.backgroundColor = DKPullDownMenuShareManager.coverColor;
    }];
}

@end
