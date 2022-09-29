//
//  THKGraphicDetailSectionHeaderView.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/20.
//

#import "THKGraphicDetailSectionHeaderView.h"

@interface THKGraphicDetailSectionHeaderView ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIView *line;

@end

@implementation THKGraphicDetailSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.titleLbl];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.right.mas_lessThanOrEqualTo(-20);
        make.height.mas_equalTo(22);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl);
        make.right.equalTo(self.titleLbl.mas_right).offset(4);
        make.bottom.equalTo(self.titleLbl);
        make.height.mas_equalTo(8);
    }];
}


- (void)setText:(NSString *)text{
    _text = text;
    
    self.titleLbl.text = text;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorPrimary;
        _titleLbl.font = UIFontSemibold(16);
    }
    return _titleLbl;
}

- (UIView *)line{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [UIColorGreen colorWithAlphaComponent:0.2];
    }
    return _line;
}

@end
