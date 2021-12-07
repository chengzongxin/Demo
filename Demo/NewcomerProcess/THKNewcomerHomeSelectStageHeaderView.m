//
//  THKNewcomerHomeSelectStageHeaderView.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/7.
//

#import "THKNewcomerHomeSelectStageHeaderView.h"

@interface THKNewcomerHomeSelectStageHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *unfoldBtn;

@end

@implementation THKNewcomerHomeSelectStageHeaderView


- (void)thk_setupViews{
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.unfoldBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(20);
        make.centerY.equalTo(self);
    }];
    
    [self.unfoldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_right).offset(20);
        make.centerY.equalTo(self);
    }];
    
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
    }
    return _contentLabel;
}

- (UIButton *)unfoldBtn{
    if (!_unfoldBtn) {
        _unfoldBtn = [[UIButton alloc] init];
        _unfoldBtn.tmui_image = UIImageMake(@"newcomer_dec_arrow");
    }
    return _unfoldBtn;
}

@end
