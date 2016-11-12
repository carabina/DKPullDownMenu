//
//  DKPullDownResult.h
//  DKPullDownMenu
//
//  Created by 庄槟豪 on 2016/11/12.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKPullDownResult : NSObject
/** 选中项的菜单标题 */
@property (nonatomic, copy) NSString *title;
/** 选中的子标题数组 */
@property (nonatomic, strong) NSArray<NSString *> *subTitles;

+ (instancetype)resultWithTitle:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles;
- (instancetype)initWithTitle:(NSString *)title subTitles:(NSArray<NSString *> *)subTitles;
@end
