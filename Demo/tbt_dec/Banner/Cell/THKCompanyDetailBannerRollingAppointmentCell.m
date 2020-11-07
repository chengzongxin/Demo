//
//  THKCompanyDetailBannerRollingAppointmentCell.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/6.
//

#import "THKCompanyDetailBannerRollingAppointmentCell.h"

@implementation THKCompanyDetailBannerRollingAppointmentCell

- (void)setupSubviews{
    [super setupSubviews];
    self.imageView.layer.cornerRadius = 17;
    self.imageView.layer.borderColor = UIColorHexString(@"FFC899").CGColor;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.vertivalLine];
}

- (void)makeConstraints{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).inset(8);
        make.width.height.mas_equalTo(34);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.vertivalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(8);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(0.5, 30));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vertivalLine.mas_right).offset(8);
        make.top.mas_equalTo(9);
        make.right.equalTo(self.contentView).inset(24);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vertivalLine.mas_right).offset(8);
        make.bottom.equalTo(self.contentView).inset(11);
        make.right.equalTo(self.contentView).inset(24);
    }];
}

- (UIView *)vertivalLine{
    if (!_vertivalLine) {
        _vertivalLine = [[UIView alloc] init];
        _vertivalLine.backgroundColor = UIColor.whiteColor;
    }
    return _vertivalLine;
}


@end
