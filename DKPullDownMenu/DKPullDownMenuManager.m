//
//  DKPullDownMenuManager.m
//  DKPullDownMenu
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownMenuManager.h"
#import "DKPullDownBaseMenu.h"

#define DKScreenH [UIScreen mainScreen].bounds.size.height
#define DKScreenW [UIScreen mainScreen].bounds.size.width

@interface DKPullDownMenuManager ()
@property (nonatomic, strong) DKPullDownMenuManager *manager;
@end

@implementation DKPullDownMenuManager
static DKPullDownMenuManager *_instance;

#pragma mark - Life Cycle

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

+ (instancetype)sharedInstance
{
    if (!_instance) {
        _instance = [[DKPullDownMenuManager alloc] init];
        // Base
        _instance.separateLineTopMargin = -1;
    }
    
    return _instance;
}

#pragma mark - Getter && Setter

- (UIColor *)separateLineColor
{
    return _separateLineColor ? _separateLineColor : [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1];
}

- (NSInteger)separateLineTopMargin
{
    return _separateLineTopMargin >= 0 ? _separateLineTopMargin : 10;
}

- (UIColor *)coverColor
{
    return _coverColor ? _coverColor : [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:0.3];
}

- (NSMutableArray<DKPullDownResult *> *)results
{
    if (!_results) {
        _results = [NSMutableArray array];
    }
    return _results;
}

@end
