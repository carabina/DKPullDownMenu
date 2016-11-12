//
//  DKPullDownMultiSelectCell.h
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKPullDownMultiSelectCell : UITableViewCell
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, weak) UIImage *normalImage;
@property (nonatomic, weak) UIImage *selectImage;
@end
