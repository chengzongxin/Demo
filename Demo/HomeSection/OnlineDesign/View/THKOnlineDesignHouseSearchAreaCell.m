//
//  THKOnlineDesignHouseSearchAreaCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/8/13.
//

#import "THKOnlineDesignHouseSearchAreaCell.h"

@interface THKOnlineDesignHouseSearchAreaCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation THKOnlineDesignHouseSearchAreaCell

- (void)setupSubviews{
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.button];
    [self.contentView addSubview:self.titleLbl];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(80, 45));
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.button.mas_right).offset(28);
        make.centerY.equalTo(self.contentView);
    }];
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.borderColor = [UIColorBlack colorWithAlphaComponent:0.05];
        _bgView.borderWidth = 3;
        _bgView.layer.cornerRadius = 8;
        @weakify(self);
        [_bgView tmui_addSingerTapWithBlock:^{
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(searchAreaBtnClick:)]) {
                [self.delegate searchAreaBtnClick:self.bgView];
            }
        }];
    }
    return _bgView;
}

- (UIButton *)button{
    if (!_button) {
        _button = [TMUIButton tmui_button];
        _button.backgroundColor = [UIColorHex(F9F9F9) colorWithAlphaComponent:0.78];
        _button.cornerRadius = 6;
        _button.tmui_image = UIImageMake(@"od_house_search_icon");
        @weakify(self);
        [[_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(searchAreaBtnClick:)]) {
                [self.delegate searchAreaBtnClick:x];
            }
        }];
    }
    return _button;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.text = @"搜索小区，绑定我家户型";
        _titleLbl.textColor = UIColorDark;
        _titleLbl.font = UIFontSemibold(14);
    }
    return _titleLbl;
}

@end
