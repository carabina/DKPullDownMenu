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

@interface DKPullDownMenuExampleViewController ()

@end

@implementation DKPullDownMenuExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    DKPullDownMenu *menu = [[DKPullDownMenu alloc] init];
    menu.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    [self.view addSubview:menu];
    
    // 单选
    DKPullDownMenuItem *item1 = [DKPullDownMenuItem itemWithTitle:@"单选" subTitles:@[@"单选A",@"单选B"]];
    item1.optionMenuHeight = 200;
    item1.optionRowHeight = 50;
    
    // 多选
    DKPullDownMenuMultiSelectItem *item2 = [DKPullDownMenuMultiSelectItem itemWithTitle:@"多选" subTitles:@[@"多选A",@"多选B",@"多选C",@"多选D",@"多选E",@"多选F",@"多选G",@"多选H",@"多选I",@"多选J",@"多选K",@"多选L",@"多选M",@"多选N"]];
    item2.optionMenuHeight = 300;
    item2.optionRowHeight = 80;
    
    // 自定义
    DKCustomDemoViewController *customVc = [[DKCustomDemoViewController alloc] init];
    DKPullDownMenuCustomItem *item3 = [DKPullDownMenuCustomItem itemWithTitle:@"自定义" customViewController:customVc];
    item3.optionMenuHeight = 400;
    
    menu.pullDownMenuItems = @[item1,item2,item3];
}


@end
