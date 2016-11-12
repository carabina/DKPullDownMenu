//
//  DKPullDownCover.h
//  DKPullDownMenu
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DKPullDownCoverClickBlock)();

@interface DKPullDownCover : UIView
/** 蒙版点击回调block */
@property (nonatomic, strong) DKPullDownCoverClickBlock coverClickBlock;
@end
