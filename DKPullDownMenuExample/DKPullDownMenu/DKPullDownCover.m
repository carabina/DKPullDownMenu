//
//  DKPullDownCover.m
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownCover.h"

@implementation DKPullDownCover

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_coverClickBlock) {
        _coverClickBlock();
    }
}

@end
