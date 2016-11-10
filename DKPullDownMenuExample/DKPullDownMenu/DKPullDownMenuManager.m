//
//  DKPullDownMenuManager.m
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownMenuManager.h"
#import "DKPullDownMenuItem.h"

#define DKScreenH [UIScreen mainScreen].bounds.size.height
#define DKScreenW [UIScreen mainScreen].bounds.size.width

@interface DKPullDownMenuManager ()
@property (nonatomic, strong) DKPullDownMenuManager *manager;
@end

@implementation DKPullDownMenuManager
static DKPullDownMenuManager *_instance;

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
    }
    
    return _instance;
}





@end
