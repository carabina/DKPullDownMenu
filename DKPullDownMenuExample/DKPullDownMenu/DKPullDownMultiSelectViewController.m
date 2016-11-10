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
#import "DKPullDownSubTitle.h"
#import <objc/runtime.h>

@interface DKPullDownMultiSelectViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton *confrimBtn;
/** 所有子标题 */
@property (nonatomic, strong) NSArray<DKPullDownSubTitle *> *subTitles;
/** 记录已选择的子标题 */
@property (nonatomic, strong) NSMutableArray<DKPullDownSubTitle *> *selectSubTitles;
@end

@implementation DKPullDownMultiSelectViewController

/** 更新下拉菜单标题的通知 */
UIKIT_EXTERN NSString *const DKPullDownMenuTitleDidUpdatedNotification;
/** item关联控制器的标识 */
UIKIT_EXTERN NSString *const DKPullDownMenuItemAssociateVcIdentifier;
/** 第一个子标题 */
static NSString *const kPullDownMultiSubTitleTotal = @"全部";

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
    
    [self setupConfirmBtn];
    
    [self setupTableView];
    
    [self setupTitles];
    
    // 观察者
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"%@",change[@"new"]);
    
    [self.tableView removeFromSuperview];
    [self.confrimBtn removeFromSuperview];

    [self setupTableView];
    [self setupConfirmBtn];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    CGSize viewSize = self.view.frame.size;
    tableView.frame = CGRectMake(0, 0, viewSize.width, self.view.frame.size.height - 40 - 10 * 2);
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
    CGFloat y = self.view.frame.size.height - margin - h;
    CGFloat w = self.view.frame.size.width - margin * 2;
    confrimBtn.frame = CGRectMake(x, y, w, h);
    confrimBtn.backgroundColor = [UIColor blueColor];
    [confrimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confrimBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confrimBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.confrimBtn = confrimBtn;
    [self.view addSubview:confrimBtn];
}

- (void)setupTitles
{
    __weak typeof(self) weakSelf = self;
    [DKPullDownMenuShareManager.pullDownMenuItems enumerateObjectsUsingBlock:^(DKPullDownMenuItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        id vc = objc_getAssociatedObject(item, &DKPullDownMenuItemAssociateVcIdentifier);
        if (self == vc) {
            NSMutableArray<NSString *> *tempTitles = [NSMutableArray array];
            if (item.subTitles.count > 1) { // 有1个以上就加上"全部"
                [tempTitles addObject:kPullDownMultiSubTitleTotal];
                [tempTitles addObjectsFromArray:item.subTitles];
            } else if (item.subTitles.count) {
                tempTitles = [item.subTitles copy];
            }
            NSMutableArray<DKPullDownSubTitle *> *subTitles = [NSMutableArray array];
            [tempTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DKPullDownSubTitle *subTitle = [[DKPullDownSubTitle alloc] init];
                subTitle.Id = [NSString stringWithFormat:@"%ld",(long)idx];
                subTitle.title = obj;
                [subTitles addObject:subTitle];
            }];
            weakSelf.subTitles = [subTitles copy];
            [weakSelf.tableView reloadData];
            *stop = YES;
        }
    }];
}

#pragma mark - Events

/** 点击确定 */
- (void)confirmBtnClick
{
    [self.selectSubTitles sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[obj1 Id] integerValue] > [[obj2 Id] integerValue];
    }];
    NSMutableArray *realSelectSubTitles = [NSMutableArray arrayWithArray:self.selectSubTitles];
    if ([[self.selectSubTitles firstObject].title isEqualToString:kPullDownMultiSubTitleTotal]) {
        [realSelectSubTitles removeObject:[realSelectSubTitles firstObject]];
    }
    NSArray *titles = [realSelectSubTitles valueForKeyPath:@"title"];
    // 更新菜单标题
    [[NSNotificationCenter defaultCenter] postNotificationName:DKPullDownMenuTitleDidUpdatedNotification object:self userInfo:@{@"arr":titles}];
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
    
    // 点击了其它，取出对应的子标题
    DKPullDownSubTitle *subTitle = [self.subTitles objectAtIndex:indexPath.row];
    
    if (cell.isSelected) { // 选中状态
        if (![self.selectSubTitles containsObject:subTitle]) { // 数组中不存在
            [self.selectSubTitles addObject:subTitle];
        }
    } else { // 取消选中
        if ([self.selectSubTitles containsObject:subTitle]) { // 数组中已存在
            [self.selectSubTitles removeObject:subTitle];
        }
    }
    
    // 更新"全部"的选中状态
    DKPullDownSubTitle *firstSubTitle = [self.subTitles firstObject];
    if (![firstSubTitle.title isEqualToString:kPullDownMultiSubTitleTotal]) return;
    // 获取"全部"的cell
    DKPullDownMultiSelectCell *firstCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    firstCell.isSelected = self.selectSubTitles.count == _subTitles.count;
    if (firstCell.isSelected) { // 选中"全部"
        if (![self.selectSubTitles containsObject:firstSubTitle]) {
            [self.selectSubTitles addObject:firstSubTitle];
        }
    } else { // 取消选中"全部"
        if ([self.selectSubTitles containsObject:firstSubTitle]) {
            [self.selectSubTitles removeObject:firstSubTitle];
        }
    }
    
}

@end
