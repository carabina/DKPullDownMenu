//
//  DKPullDownMultiSelectCell.m
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownMultiSelectCell.h"

@interface DKPullDownMultiSelectCell ()
@property (nonatomic, strong) UIButton *cheakView;
@end

@implementation DKPullDownMultiSelectCell

- (UIButton *)cheakView
{
    if (!_cheakView) {
        _cheakView = [UIButton buttonWithType:UIButtonTypeCustom];
        _cheakView.userInteractionEnabled = NO;
        [_cheakView setImage:[UIImage imageNamed:@"multi_normal"] forState:UIControlStateNormal];
        [_cheakView setImage:[UIImage imageNamed:@"multi_select"] forState:UIControlStateSelected];
        [_cheakView sizeToFit];
        self.accessoryView = _cheakView;
    }
    return _cheakView;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    self.cheakView.selected = isSelected;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cheakView.hidden = NO;
    }
    return self;
}


@end
