//
//  DKPullDownSingleSelectViewController.m
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownSingleSelectViewController.h"
#import "DKPullDownSingleSelectCell.h"
#import "DKPullDownMenuManager.h"
#import <objc/runtime.h>

@interface DKPullDownSingleSelectViewController ()
@property (nonatomic, strong) DKPullDownMenuSingleSelectItem *item;
/** 子标题数组 */
@property (nonatomic, copy) NSArray<NSString *> *titles;
/** 记录选中的行 */
@property (nonatomic, assign) NSInteger selectedRow;
@end

@implementation DKPullDownSingleSelectViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupItem];
    
    [self setupTableView];
    
    _selectedRow = -1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_selectedRow >= 0) { // 已经有选中
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedRow inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

/** 画完整分割线 */
- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)setupItem
{
    __weak typeof(self) weakSelf = self;
    [DKPullDownMenuShareManager.pullDownMenuItems enumerateObjectsUsingBlock:^(DKPullDownMenuItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        id vc = objc_getAssociatedObject(item, &DKPullDownMenuItemAssociateVcIdentifier);
        if (self == vc) {
            weakSelf.item = (DKPullDownMenuSingleSelectItem *)item;
            *stop = YES;
        }
    }];
}

- (void)setupTableView
{
    // 注册
    [self.tableView registerClass:[DKPullDownSingleSelectCell class] forCellReuseIdentifier:NSStringFromClass([DKPullDownSingleSelectCell class])];
    // 行高
    self.tableView.rowHeight = self.item.optionRowHeight;
    // 清除底部多余的分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    // 子标题
    self.titles = self.item.subTitles;
    // 刷新
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DKPullDownSingleSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DKPullDownSingleSelectCell class])];
    cell.textLabel.text = _titles[indexPath.row];
    if ([self.item isKindOfClass:[DKPullDownMenuSingleSelectItem class]]) {
        cell.checkImage = self.item.singleSelectImage;
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedRow = indexPath.row;
    
    // 选中当前cell
    DKPullDownSingleSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 更新菜单标题
    [[NSNotificationCenter defaultCenter] postNotificationName:DKPullDownMenuTitleDidUpdatedNotification object:self userInfo:@{self.item.title:cell.textLabel.text}];
}

@end
