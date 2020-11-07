//
//  THKCompanyDetailBannerRollingCell.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "THKCompanyDetailBannerRollingBaseCell.h"

@interface THKCompanyDetailBannerRollingBaseCell ()


@end

@implementation THKCompanyDetailBannerRollingBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)setupSubviews{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
}

- (void)makeConstraints{
    
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:kImgAtBundle(@"ico_headPortrait_60")];
        _imageView.layer.cornerRadius = 2;
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFontMedium(12);
        _titleLabel.textColor = UIColorHexString(@"FFC899");
        _titleLabel.text = @"现代轻奢中的奥秘";
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = UIFont(10);
        _subtitleLabel.textColor = UIColor.whiteColor;
        _subtitleLabel.text = @"1小时52分钟后开播";
    }
    return _subtitleLabel;
}



@end
