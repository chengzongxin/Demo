//
//  THKCompanyDetailBannerRollingLiveCell.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/6.
//

#import "THKCompanyDetailBannerRollingLiveCell.h"

@interface THKCompanyDetailBannerRollingLiveCell ()

@end

@implementation THKCompanyDetailBannerRollingLiveCell


- (void)setupSubviews{
    [super setupSubviews];
    
    self.imageView.layer.cornerRadius = 4;
    self.imageView.layer.borderWidth = 0;
    self.imageView.layer.masksToBounds = YES;
    
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
