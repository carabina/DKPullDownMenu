//
//  DKPullDownResult.m
//  DKPullDownMenu
//
//  Created by 庄槟豪 on 2016/11/12.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownResult.h"

@implementation DKPullDownResult

+ (instancetype)resultWithTitle:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles
{
    return [[self alloc] initWithTitle:title subTitles:subTitles];
}

- (instancetype)initWithTitle:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles
{
    self.title = title;
    self.subTitles = subTitles;
    return self;
}

@end
