//
//  DKPullDownSingleSelectViewController.m
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownSingleSelectViewController.h"
#import "DKPullDownSingleSelectCell.h"

@interface DKPullDownSingleSelectViewController ()
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, assign) NSInteger selectedCol;
@end

@implementation DKPullDownSingleSelectViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _selectedCol = 0;
    
    _titles = @[@"xx",@"xx",@"xxx",@"xxxx"];
    
    [self.tableView registerClass:[DKPullDownSingleSelectCell class] forCellReuseIdentifier:NSStringFromClass([DKPullDownSingleSelectCell class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedCol inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
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
    
    // 选中当前
    DKPullDownSingleSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 更新菜单标题
    [[NSNotificationCenter defaultCenter] postNotificationName:DKPullDownMenuTitleDidUpdatedNotification object:self userInfo:@{@"title":cell.textLabel.text}];
}


@end
