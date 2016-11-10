//
//  DKPullDownTitleButton.m
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownTitleButton.h"

@implementation DKPullDownTitleButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.frame.origin.x < self.titleLabel.frame.origin.x) {
        CGRect titleFrame = self.titleLabel.frame;
        titleFrame.origin.x = self.imageView.frame.origin.x;
        self.titleLabel.frame = titleFrame;

        CGRect imageFrame = self.imageView.frame;
        imageFrame.origin.x = CGRectGetMaxX(self.titleLabel.frame) + 10;
        self.imageView.frame = imageFrame;
    }
}

@end
