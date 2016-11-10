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
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, assign) NSInteger selectedCol;
@end

@implementation DKPullDownSingleSelectViewController

/** 更新下拉菜单标题的通知 */
UIKIT_EXTERN NSString *const DKPullDownMenuTitleDidUpdatedNotification;
/** item关联控制器的标识 */
UIKIT_EXTERN NSString *const DKPullDownMenuItemAssociateVcIdentifier;

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitles];
    
    [self.tableView registerClass:[DKPullDownSingleSelectCell class] forCellReuseIdentifier:NSStringFromClass([DKPullDownSingleSelectCell class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedCol inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)setupTitles
{
    [DKPullDownMenuShareManager.pullDownMenuItems enumerateObjectsUsingBlock:^(DKPullDownMenuItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        id vc = objc_getAssociatedObject(item, &DKPullDownMenuItemAssociateVcIdentifier);
        if (self == vc) {
            _titles = item.subTitles;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedCol = indexPath.row;
    
    // 选中当前cell
    DKPullDownSingleSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 更新菜单标题
    [[NSNotificationCenter defaultCenter] postNotificationName:DKPullDownMenuTitleDidUpdatedNotification object:self userInfo:@{@"title":cell.textLabel.text}];
}


@end
