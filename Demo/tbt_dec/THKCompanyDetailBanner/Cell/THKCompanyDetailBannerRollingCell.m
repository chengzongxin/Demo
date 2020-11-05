//
//  THKCompanyDetailBannerRollingCell.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/5.
//

#import "THKCompanyDetailBannerRollingCell.h"

@interface THKCompanyDetailBannerRollingCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *remindLiveLabel;

@end

@implementation THKCompanyDetailBannerRollingCell

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
    [self.contentView addSubview:self.remindLiveLabel];
}

- (void)makeConstraints{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView).inset(6);
        make.width.mas_equalTo(42);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(8);
        make.top.mas_equalTo(9);
        make.right.equalTo(self.contentView).inset(24);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(8);
        make.bottom.equalTo(self.contentView).inset(11);
        make.right.equalTo(self.contentView).inset(24);
    }];
    
    [self.remindLiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).inset(13);
        make.bottom.equalTo(self.contentView).inset(10);
        make.size.mas_equalTo(CGSizeMake(48, 15));
    }];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
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

- (UILabel *)remindLiveLabel{
    if (!_remindLiveLabel) {
        _remindLiveLabel = [[UILabel alloc] init];
        _remindLiveLabel.font = UIFont(10);
        _remindLiveLabel.textColor = UIColor.whiteColor;
        _remindLiveLabel.textAlignment = NSTextAlignmentCenter;
        _remindLiveLabel.backgroundColor = UIColorHexString(@"FF255C");
        _remindLiveLabel.text = @"提醒开播";
        _remindLiveLabel.layer.cornerRadius = 2;
    }
    return _remindLiveLabel;
}

@end
