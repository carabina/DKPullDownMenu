//
//  DKPullDownMultiSelectViewController.m
//  DKPullDownMenu
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownMultiSelectViewController.h"
#import "DKPullDownMultiSelectCell.h"
#import "DKPullDownMenuManager.h"
#import "DKPullDownSubTitle.h"
#import <objc/runtime.h>

@interface DKPullDownMultiSelectViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton *confrimBtn;
@property (nonatomic, strong) DKPullDownMenuMultiSelectItem *item;
/** 所有子标题 */
@property (nonatomic, strong) NSArray<DKPullDownSubTitle *> *subTitles;
/** 记录已选择的子标题 */
@property (nonatomic, strong) NSMutableArray<DKPullDownSubTitle *> *selectSubTitles;
@end

@implementation DKPullDownMultiSelectViewController

#pragma mark - Getter && Setter

- (NSMutableArray<DKPullDownSubTitle *> *)selectSubTitles
{
    if (!_selectSubTitles) {
        _selectSubTitles = [NSMutableArray array];
    }
    return _selectSubTitles;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupItem];
    
    [self setupConfirmBtn];
    
    [self setupTableView];
    
    [self layoutSubviews];
    
    [self setupTitles];
    
    // 观察者
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    // 重新布局子控件
    [self layoutSubviews];
}

- (void)setupItem
{
    __weak typeof(self) weakSelf = self;
    [DKPullDownMenuShareManager.pullDownMenuItems enumerateObjectsUsingBlock:^(DKPullDownMenuItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        id vc = objc_getAssociatedObject(item, &DKPullDownMenuItemAssociateVcIdentifier);
        if (self == vc) {
            weakSelf.item = (DKPullDownMenuMultiSelectItem *)item;
            *stop = YES;
        }
    }];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = self.item.optionRowHeight;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [self.tableView registerClass:[DKPullDownMultiSelectCell class] forCellReuseIdentifier:NSStringFromClass([DKPullDownMultiSelectCell class])];
}

- (void)setupConfirmBtn
{
    UIButton *confrimBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    confrimBtn.backgroundColor = self.item.confirmBackgroundColor;
    [confrimBtn setTitleColor:self.item.confirmTitleColor forState:UIControlStateNormal];
    [confrimBtn setTitle:self.item.confirmTitle forState:UIControlStateNormal];
    confrimBtn.titleLabel.font = self.item.confirmTitleFont;
    [confrimBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.confrimBtn = confrimBtn;
    [self.view addSubview:confrimBtn];
}

- (void)setupTitles
{
    NSMutableArray<NSString *> *tempTitles = [NSMutableArray array];
    if (self.item.subTitles.count > 1) { // 有1个以上就加上"全选"
        [tempTitles addObject:self.item.subTitleTotal];
        [tempTitles addObjectsFromArray:self.item.subTitles];
    } else if (self.item.subTitles.count) {
        tempTitles = [self.item.subTitles copy];
    }
    NSMutableArray<DKPullDownSubTitle *> *subTitles = [NSMutableArray array];
    [tempTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 包装模型，一是因为字符串可能重复则地址可能会是同一个 处理多选逻辑会出bug, 二是因为可以根据封装的模型中的Id来将选中的结果排序
        DKPullDownSubTitle *subTitle = [[DKPullDownSubTitle alloc] init];
        subTitle.Id = [NSString stringWithFormat:@"%ld",(long)idx];
        subTitle.title = obj;
        [subTitles addObject:subTitle];
    }];
    // 子标题
    self.subTitles = [subTitles copy];
    [self.tableView reloadData];
}

/** 布局子控件 */
- (void)layoutSubviews
{
    CGSize viewSize = self.view.frame.size;
    CGFloat margin = 10;
    CGFloat confrimBtnX = margin;
    CGFloat confrimBtnH = 40;
    CGFloat confrimBtnY = viewSize.height - margin - confrimBtnH;
    CGFloat confrimBtnW = viewSize.width - margin * 2;
    self.confrimBtn.frame = CGRectMake(confrimBtnX, confrimBtnY, confrimBtnW, confrimBtnH);
    self.tableView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height - confrimBtnH - margin * 2);
}

- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)dealloc
{
    [self.view removeObserver:self forKeyPath:@"frame"];
}

#pragma mark - Events

/** 点击确定 */
- (void)confirmBtnClick
{
    [self.selectSubTitles sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[obj1 Id] integerValue] > [[obj2 Id] integerValue];
    }];
    NSMutableArray *realSelectSubTitles = [NSMutableArray arrayWithArray:self.selectSubTitles];
    if ([[self.selectSubTitles firstObject].title isEqualToString:self.item.subTitleTotal]) {
        [realSelectSubTitles removeObject:[realSelectSubTitles firstObject]];
    }
    NSArray *titles = [realSelectSubTitles valueForKeyPath:@"title"];
    // 通知传选中值
    [[NSNotificationCenter defaultCenter] postNotificationName:DKPullDownMenuTitleDidUpdatedNotification object:self userInfo:@{self.item.title:titles}];
}

#pragma mark - Private Method

/** 取消选中所有的cell */
- (void)unSelectAllCell
{
    // 取消之前所有选中标题
    [self.selectSubTitles removeAllObjects];
    
    NSInteger count = _subTitles.count;
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
     [self.selectSubTitles removeAllObjects];
    
    NSInteger count = _subTitles.count;
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        DKPullDownMultiSelectCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        DKPullDownSubTitle *subTitle = [self.subTitles objectAtIndex:i];
        if (cell) {
            cell.isSelected = YES;
        }
        [self.selectSubTitles addObject:subTitle];
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _subTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DKPullDownMultiSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DKPullDownMultiSelectCell class])];
    cell.textLabel.text = _subTitles[indexPath.row].title;
    DKPullDownSubTitle *subTitle = [self.subTitles objectAtIndex:indexPath.row];
    // 设置cell的选中状态
    cell.isSelected = [self.selectSubTitles containsObject:subTitle];
    cell.normalImage = self.item.multiNormalImage;
    cell.selectImage = self.item.multiSelectImage;
    
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
    DKPullDownMultiSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = !cell.isSelected;
    
    if (indexPath.row == 0) {
        // 点击了全选
        if (cell.isSelected == YES) {
            // 选中所有的cell
            [self selectAllCell];
        } else {
            // 取消所有的cell选中
            [self unSelectAllCell];
        }
        return;
    }
    
    // 点击了其它，取出对应的子标题
    DKPullDownSubTitle *subTitle = [self.subTitles objectAtIndex:indexPath.row];
    
    // 获取第一个子标题
    DKPullDownSubTitle *firstSubTitle = [self.subTitles firstObject];
    // 获取第一个cell
    DKPullDownMultiSelectCell *firstCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    if (cell.isSelected) { // 选中状态
        if (![self.selectSubTitles containsObject:subTitle]) { // 数组中不存在
            [self.selectSubTitles addObject:subTitle];
            // 更新"全选"的选中状态
            if (![firstSubTitle.title isEqualToString:self.item.subTitleTotal]) return;
            if (self.selectSubTitles.count == _subTitles.count - 1) { // 选满
                firstCell.isSelected = YES; // "全选"选中
                [self.selectSubTitles addObject:firstSubTitle];
            }
        }
    } else { // 取消选中
        if ([self.selectSubTitles containsObject:subTitle]) { // 数组中已存在
            [self.selectSubTitles removeObject:subTitle];
            // 更新"全选"的选中状态
            if (![firstSubTitle.title isEqualToString:self.item.subTitleTotal]) return;
            firstCell.isSelected = NO; // "全选"取消选中
            [self.selectSubTitles removeObject:firstSubTitle];
        }
    }
    
}

@end
