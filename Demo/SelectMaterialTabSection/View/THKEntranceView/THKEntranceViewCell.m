//
//  THKEntranceViewCell.m
//  Demo
//
//  Created by Joe.cheng on 2021/11/23.
//

#import "THKEntranceViewCell.h"

@interface THKEntranceViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation THKEntranceViewCell

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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(8).priorityHigh();
        make.bottom.mas_equalTo(0);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(CGCustomFloat(17));
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(CGCustomFloat(16));
        make.size.mas_equalTo(CGSizeMake(CGCustomFloat(40), CGCustomFloat(40)));
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.titleLabel.mas_top).offset(-8);
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
        _titleLabel.textColor = UIColorHex(1A1C1A);
        _titleLabel.font = [UIFont systemFontOfSize:CGCustomFont(12.0) weight:UIFontWeightMedium];
    }
    return _titleLabel;
}

@end
