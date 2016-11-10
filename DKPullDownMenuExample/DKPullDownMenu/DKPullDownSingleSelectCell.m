//
//  DKPullDownSingleSelectCell.m
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownSingleSelectCell.h"

@interface DKPullDownSingleSelectCell ()
@property (nonatomic, strong) UIImageView *cheakView;
@end

@implementation DKPullDownSingleSelectCell

- (UIImageView *)cheakView
{
    if (_cheakView == nil) {
        _cheakView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选中对号"]];
        self.accessoryView = _cheakView;
    }
    return _cheakView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    self.cheakView.hidden = !selected;
}

@end
