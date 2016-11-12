//
//  DKPullDownTitleButton.m
//  DKPullDownMenu
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownTitleButton.h"

@implementation DKPullDownTitleButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.frame.size.width && self.imageView.frame.size.height && self.titleLabel.text.length) {
        // 按钮上有文字和图片，交换文字和图片的位置，间隔为10
        if (self.imageView.frame.origin.x < self.titleLabel.frame.origin.x) {
            CGRect titleFrame = self.titleLabel.frame;
            titleFrame.origin.x = self.imageView.frame.origin.x;
            self.titleLabel.frame = titleFrame;
            
            CGRect imageFrame = self.imageView.frame;
            imageFrame.origin.x = CGRectGetMaxX(self.titleLabel.frame) + 10;
            self.imageView.frame = imageFrame;
        }
    }
}

@end
