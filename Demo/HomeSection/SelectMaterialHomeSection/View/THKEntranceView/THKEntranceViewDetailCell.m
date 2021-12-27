//
//  THKEntranceViewDetailCell.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKEntranceViewDetailCell.h"

@interface THKEntranceViewDetailCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@end

@implementation THKEntranceViewDetailCell

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self thk_setupView];
    }
    return self;
}

- (void)thk_setupView {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(5);
        make.left.right.equalTo(self.contentView);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(1);
        make.left.right.equalTo(self.contentView);
    }];
    
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorHex(333533);
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = UIColorHex(7E807E);
        _detailLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    }
    return _detailLabel;
}

@end
