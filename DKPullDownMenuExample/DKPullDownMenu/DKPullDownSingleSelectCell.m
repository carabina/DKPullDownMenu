//
//  DKPullDownSingleSelectCell.m
//  DKPullDownMenuExample
//
//  Created by 庄槟豪 on 2016/11/10.
//  Copyright © 2016年 cn.dankal. All rights reserved.
//

#import "DKPullDownSingleSelectCell.h"

#define DKPhotosBundle [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DKPullDownMenu.bundle"]]
#define DKImage(imageName) [UIImage imageWithContentsOfFile:[[DKPhotosBundle resourcePath] stringByAppendingPathComponent:imageName]]

@interface DKPullDownSingleSelectCell ()
@property (nonatomic, strong) UIImageView *checkView;
@end

@implementation DKPullDownSingleSelectCell

- (void)setCheckImage:(UIImage *)checkImage
{
    if (!checkImage) return;
    
    _checkImage = checkImage;
    self.checkView.image = checkImage;
}

- (UIImageView *)checkView
{
    if (!_checkView) {
        _checkView = [[UIImageView alloc] init];
        _checkView.bounds = CGRectMake(0, 0, 18, 18);
        _checkView.image = DKImage(@"single_select");
        _checkView.contentMode = UIViewContentModeScaleAspectFit;
        self.accessoryView = _checkView;
    }
    return _checkView;
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

    self.checkView.hidden = !selected;
}

@end
