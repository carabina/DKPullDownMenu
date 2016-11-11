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
@property (nonatomic, copy) NSArray<NSString *> *titles;
@property (nonatomic, assign) NSInteger selectedCol;
@end

@implementation DKPullDownSingleSelectViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setupTitles];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedCol inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
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

- (void)setupTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[DKPullDownSingleSelectCell class] forCellReuseIdentifier:NSStringFromClass([DKPullDownSingleSelectCell class])];
    
}

- (void)setupTitles
{
    __weak typeof(self) weakSelf = self;
    [DKPullDownMenuShareManager.pullDownMenuItems enumerateObjectsUsingBlock:^(DKPullDownMenuItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        id vc = objc_getAssociatedObject(item, &DKPullDownMenuItemAssociateVcIdentifier);
        if (self == vc) {
            // 子标题
            weakSelf.titles = item.subTitles;
            // 行高
            weakSelf.tableView.rowHeight = item.optionRowHeight;
            
            [weakSelf.tableView reloadData];
            *stop = YES;
        }
    }];
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
    if (indexPath.row == 0) {
        [cell setSelected:YES animated:NO];
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
    _selectedCol = indexPath.row;
    
    // 选中当前cell
    DKPullDownSingleSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 更新菜单标题
    [[NSNotificationCenter defaultCenter] postNotificationName:DKPullDownMenuTitleDidUpdatedNotification object:self userInfo:@{@"title":cell.textLabel.text}];
}


@end
