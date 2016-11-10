//
//  DKPullDownMenuManager.h
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKPullDownMenuItem.h"

#define DKPullDownMenuShareManager [DKPullDownMenuManager sharedInstance]

@interface DKPullDownMenuManager : NSObject
@property (nonatomic, strong) NSArray<DKPullDownMenuItem *> *pullDownMenuItems;

+ (instancetype)sharedInstance;
@end
