//
//  DKPullDownMultiSelectCell.m
//  DKPullDownMenu
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownMultiSelectCell.h"

#define DKPhotosBundle [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DKPullDownMenu.bundle"]]
#define DKImage(imageName) [UIImage imageWithContentsOfFile:[[DKPhotosBundle resourcePath] stringByAppendingPathComponent:imageName]]

@interface DKPullDownMultiSelectCell ()
@property (nonatomic, strong) UIButton *checkView;
@end

@implementation DKPullDownMultiSelectCell

- (UIButton *)cheakView
{
    if (!_checkView) {
        _checkView = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkView.userInteractionEnabled = NO;
        _checkView.bounds = CGRectMake(0, 0, 18, 18);
        _checkView.contentMode = UIViewContentModeScaleAspectFit;
        [_checkView setImage:DKImage(@"multi_normal") forState:UIControlStateNormal];
        [_checkView setImage:DKImage(@"multi_select") forState:UIControlStateSelected];
        [_checkView sizeToFit];
        self.accessoryView = _checkView;
    }
    return _checkView;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.cheakView.selected = isSelected;
}

- (void)setNormalImage:(UIImage *)normalImage
{
    if (!normalImage) return;
    
    _normalImage = normalImage;
    [self.cheakView setImage:normalImage forState:UIControlStateNormal];
}

- (void)setSelectImage:(UIImage *)selectImage
{
    if (!selectImage) return;
    
     _selectImage = selectImage;
    [self.cheakView setImage:selectImage forState:UIControlStateSelected];
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
