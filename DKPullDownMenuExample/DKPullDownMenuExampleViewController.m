//
//  ViewController.m
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownMenuExampleViewController.h"
#import "DKPullDownMenu.h"
#import "DKCustomDemoViewController.h"

@interface DKPullDownMenuExampleViewController ()<DKPullDownMenuDelegate>

@end

@implementation DKPullDownMenuExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建菜单
    DKPullDownMenu *menu = [[DKPullDownMenu alloc] init];
    menu.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    menu.delegate = self;
    [self.view addSubview:menu];
    
    // 构建选项 单选
    DKPullDownMenuSingleSelectItem *item1 = [DKPullDownMenuSingleSelectItem itemWithTitle:@"Single" subTitles:@[@"SingleA",@"SingleB"]];
//    item1.optionMenuHeight = 200;
//    item1.optionRowHeight = 50;
//    item1.titleSelectColor = [UIColor redColor];
//    item1.singleSelectImage = [UIImage imageNamed:@"ic_choosed"];
    
    // 构建选项 多选
    NSMutableArray *multiSubTitles = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        [multiSubTitles addObject:[NSString stringWithFormat:@"Mulit%ld",(long)i]];
    }
    DKPullDownMenuMultiSelectItem *item2 = [DKPullDownMenuMultiSelectItem itemWithTitle:@"Mulit" subTitles:multiSubTitles];
//    item2.optionMenuHeight = 300;
//    item2.optionRowHeight = 80;
//    item2.multiNormalImage = [UIImage imageNamed:@"ic_choosing"];
//    item2.multiSelectImage = [UIImage imageNamed:@"ic_choosed"];
//    item2.confirmBackgroundColor = [UIColor redColor];
    item2.subTitleTotal = @"Total";
    
    // 构建选项 自定义
    DKCustomDemoViewController *customVc = [[DKCustomDemoViewController alloc] init];
    DKPullDownMenuCustomItem *item3 = [DKPullDownMenuCustomItem itemWithTitle:@"Custom" customViewController:customVc];
//    item3.optionMenuHeight = 400;
    
    menu.pullDownMenuItems = @[item1,item2,item3];
    menu.separateLineTopMargin = 15;
    menu.coverColor = [UIColor lightGrayColor];
    menu.separateLineColor = [UIColor lightGrayColor];
    menu.bottomSeparateLineAvailable = YES;
//    menu.headSeparateLineAvailable = YES;
}

#pragma mark - <DKPullDownMenuDelegate>

- (void)pullDownMenu:(DKPullDownMenu *)pullDownMenu selectedResultsDidUpdated:(NSArray<DKPullDownResult *> *)results
{
    [results enumerateObjectsUsingBlock:^(DKPullDownResult * _Nonnull result, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"选项:%@ 选择结果:%@",result.title, result.subTitles);
    }];
   
}

@end
