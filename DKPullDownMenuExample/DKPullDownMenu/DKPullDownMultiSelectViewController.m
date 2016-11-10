//
//  DKPullDownMultiSelectViewController.m
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownMultiSelectViewController.h"
#import "DKPullDownMultiSelectCell.h"
#import "DKPullDownMenuManager.h"
#import <objc/runtime.h>

@interface DKPullDownMultiSelectViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
// 记录已选中的cell
@property (nonatomic, strong) NSMutableArray *selectCells;
@end

@implementation DKPullDownMultiSelectViewController

/** 更新下拉菜单标题的通知 */
UIKIT_EXTERN NSString *const DKPullDownMenuTitleDidUpdatedNotification;
/** item关联控制器的标识 */
UIKIT_EXTERN NSString *const DKPullDownMenuItemAssociateVcIdentifier;

#pragma mark - Getter && Setter

- (NSMutableArray *)selectCells
{
    if (_selectCells == nil) {
        _selectCells = [NSMutableArray array];
    }
    return _selectCells;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setupConfirmBtn];
    
    [self setupTitles];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    CGSize viewSize = self.view.frame.size;
    tableView.frame = CGRectMake(0, 0, viewSize.width, 180);
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [self.tableView registerClass:[DKPullDownMultiSelectCell class] forCellReuseIdentifier:NSStringFromClass([DKPullDownMultiSelectCell class])];
}

- (void)setupConfirmBtn
{
    UIButton *confrimBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    CGFloat margin = 10;
    CGFloat x = margin;
    CGFloat h = 40;
    CGFloat y = 240 - margin - h;
    CGFloat w = self.view.frame.size.width - margin * 2;
    confrimBtn.frame = CGRectMake(x, y, w, h);
    confrimBtn.backgroundColor = [UIColor blueColor];
    [confrimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confrimBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confrimBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confrimBtn];
}

- (void)setupTitles
{
    [DKPullDownMenuShareManager.pullDownMenuItems enumerateObjectsUsingBlock:^(DKPullDownMenuItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        id vc = objc_getAssociatedObject(item, &DKPullDownMenuItemAssociateVcIdentifier);
        if (self == vc) {
            if (item.subTitles.count > 1) { // 有1个以上就加上"全部"
                NSMutableArray *tempTitles = [NSMutableArray array];
                [tempTitles addObject:@"全部"];
                [tempTitles addObjectsFromArray:item.subTitles];
                _titles = [tempTitles copy];
            } else if (item.subTitles.count) {
                _titles = item.subTitles;
            }
            *stop = YES;
        }
    }];
}

#pragma mark - Events

/** 点击确定 */
- (void)confirmBtnClick
{
    NSArray *titles = [self.selectCells valueForKeyPath:@"textLabel.text"];
    // 更新菜单标题
    [[NSNotificationCenter defaultCenter] postNotificationName:DKPullDownMenuTitleDidUpdatedNotification object:self userInfo:@{@"arr":titles}];
}

#pragma mark - Private Method

/** 选中"全部"cell */
- (void)selectTotalCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    DKPullDownMultiSelectCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = YES;
}

/** 取消选中"全部"cell */
- (void)unSelectTotalCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    DKPullDownMultiSelectCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = NO;
}

/** 取消选中所有的cell */
- (void)unSelectAllCell
{
    // 取消之前所有选中cell
    [self.selectCells removeAllObjects];
    
    NSInteger count = _titles.count;
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        DKPullDownMultiSelectCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.isSelected = NO;
    }
}

/** 选中所有的cell */
- (void)selectAllCell
{
    // 取消之前所有选中cell
    [self.selectCells removeAllObjects];
    
    NSInteger count = _titles.count;
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        DKPullDownMultiSelectCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.isSelected = YES;
        if (i > 0) {
            [self.selectCells addObject:cell];
        }
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DKPullDownMultiSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DKPullDownMultiSelectCell class])];
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DKPullDownMultiSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = !cell.isSelected;
    
    if (indexPath.row == 0) { // 点击了全部
        if (cell.isSelected == YES) {
            // 选中所有的cell
            [self selectAllCell];
        } else {
            // 取消所有的cell选中
            [self unSelectAllCell];
        }
        return;
    }
    
    // 记录选中的cell
    if (cell.isSelected) {
        [self.selectCells addObject:cell];
    } else {
        [self.selectCells removeObject:cell];
    }
    
    // 判断是否选择了所有的cell
    if (self.selectCells.count == _titles.count - 1) {
        // 选中"全部"cell"
        [self selectTotalCell];
    } else {
        // 取消选中"全部"cell
        [self unSelectTotalCell];
    }
}

@end
