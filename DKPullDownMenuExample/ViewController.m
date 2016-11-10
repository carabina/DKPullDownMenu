//
//  ViewController.m
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "ViewController.h"
#import "DKPullDownMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    DKPullDownMenu *menu = [[DKPullDownMenu alloc] init];
    menu.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    [self.view addSubview:menu];
    
    DKPullDownMenuItem *item1 = [DKPullDownMenuItem itemWithType:DKPullDownMenuItemTypeSingle title:@"单选" subTitles:@[@"单选A",@"单选B"]];
    DKPullDownMenuItem *item2 = [DKPullDownMenuItem itemWithType:DKPullDownMenuItemTypeMulti title:@"多选" subTitles:@[@"多选A",@"多选B",@"多选C",@"多选C",@"多选C",@"多选C",@"多选C",@"多选C",@"多选C",@"多选C",@"多选C",@"多选C"]];
    menu.pullDownMenuItems = @[item1,item2];
}


@end
