//
//  THKOnlineDesignHeader.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/11.
//

#import "THKOnlineDesignHeader.h"

@interface THKOnlineDesignHeader ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *subtitleLbl;

@end

@implementation THKOnlineDesignHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    [self addSubview:self.titleLbl];
    [self addSubview:self.subtitleLbl];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
    }];
    
    [self.subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
        make.left.equalTo(self.titleLbl);
    }];
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = UIFont(28);
        _titleLbl.textColor = UIColorDark;
        _titleLbl.text = @"多位设计师免费出图";
    }
    return _titleLbl;
}

- (UILabel *)subtitleLbl{
    if (!_subtitleLbl) {
        _subtitleLbl = [[UILabel alloc] init];
        _subtitleLbl.textColor = UIColorWeak;
        _subtitleLbl.font = UIFont(16);
        _subtitleLbl.text = @"3套效果图在线对比";
    }
    return _subtitleLbl;
}

@end
